#!/usr/bin/env fish

# Toggles the Wi-Fi card between hotspot mode and normal WLAN mode.
# The hotspot shares another connection (e.g. USB tethering) and lives only in NetworkManager, not
# in this repo. The NixOS firewall drops the hotspot clients' DHCP and DNS requests, so the ports are
# opened for the hotspot interface while it runs; the rules vanish on reboot or firewall restart.
# Run it as your normal user; it calls sudo itself for the firewall rules.

set -g hotspot "super duper hotspot"

# One firewall rule per entry, matched on the hotspot interface: DHCP and DNS
set -g rules "-p udp -m multiport --dports 53,67" "-p tcp --dport 53"

function wifi_interface
    set -l iface (nmcli -g connection.interface-name connection show $hotspot 2>/dev/null)
    if test -z "$iface"
        set iface (nmcli -t -f DEVICE,TYPE device | string match -r '^[^:]+(?=:wifi$)')[1]
    end
    echo $iface
end

function hotspot_active
    contains -- $hotspot (nmcli -g NAME connection show --active)
end

function open_ports -a iface
    for rule in $rules
        set -l args -i $iface (string split ' ' -- $rule) -j nixos-fw-accept
        if not sudo iptables -C nixos-fw $args 2>/dev/null
            sudo iptables -I nixos-fw $args; or return
        end
    end
    echo "🔓 Opened DHCP and DNS ports on $iface"
end

function close_ports -a iface
    for rule in $rules
        set -l args -i $iface (string split ' ' -- $rule) -j nixos-fw-accept
        while sudo iptables -C nixos-fw $args 2>/dev/null
            sudo iptables -D nixos-fw $args; or return
        end
    end
    echo "🔒 Closed DHCP and DNS ports on $iface"
end

function create_hotspot -a iface
    echo "❔ NetworkManager has no '$hotspot' profile yet, creating it"
    read -s -P "Hotspot password (at least 8 characters): " password; or return
    if test (string length -- "$password") -lt 8
        echo "❌ The password needs at least 8 characters" >&2
        return 1
    end
    nmcli connection add type wifi ifname $iface con-name $hotspot autoconnect no ssid $hotspot \
        802-11-wireless.mode ap 802-11-wireless.band bg \
        ipv4.method shared ipv6.method ignore \
        wifi-sec.key-mgmt wpa-psk wifi-sec.proto rsn wifi-sec.pairwise ccmp wifi-sec.group ccmp \
        wifi-sec.psk $password >/dev/null
end

function to_wlan -a iface
    echo "📡 Hotspot '$hotspot' is active, switching to WLAN mode"
    nmcli connection down $hotspot >/dev/null; or return
    close_ports $iface
    echo "🔍 Looking for known WLAN networks…"
    nmcli device wifi rescan ifname $iface 2>/dev/null
    sleep 3
    if nmcli --wait 30 device connect $iface >/dev/null 2>&1
        set -l network (nmcli -g GENERAL.CONNECTION device show $iface)
        echo "📶 Now in WLAN mode, connected to '$network'"
    else
        echo "📶 Now in WLAN mode, but no known network is in range yet; NetworkManager keeps looking"
    end
end

function to_hotspot -a iface
    set -l network (nmcli -g GENERAL.CONNECTION device show $iface)
    if test -n "$network"
        echo "📶 WLAN mode is active (connected to '$network'), switching to hotspot mode"
    else
        echo "📶 WLAN mode is active (not connected), switching to hotspot mode"
    end

    if not contains -- $hotspot (nmcli -g NAME connection show)
        create_hotspot $iface; or return
    end

    set -l uplink (ip route show default | string match -rv " dev $iface( |\$)")
    if test -z "$uplink"
        echo "⚠️  No internet connection besides $iface (e.g. USB tethering); hotspot clients will be offline"
    end

    open_ports $iface; or return
    if not nmcli connection up $hotspot >/dev/null
        echo "❌ Could not start the hotspot" >&2
        close_ports $iface
        return 1
    end
    echo "📡 Hotspot '$hotspot' is now active"
end

set -l iface (wifi_interface)
if test -z "$iface"
    echo "❌ No Wi-Fi device found" >&2
    exit 1
end

if hotspot_active
    to_wlan $iface
else
    to_hotspot $iface
end
