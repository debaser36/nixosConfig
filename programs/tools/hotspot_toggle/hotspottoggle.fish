#!/usr/bin/env fish

# Toggles the Wi-Fi card between hotspot mode and normal WLAN mode, or changes the hotspot's name
# and password (--settings).
# The hotspot shares another connection (e.g. USB tethering) and lives only in NetworkManager, not
# in this repo; it is the Wi-Fi profile in access point mode, so renaming it keeps it working.
# The NixOS firewall drops the hotspot clients' DHCP and DNS requests, so the ports are opened for
# the hotspot interface while it runs; the rules vanish on reboot or firewall restart.
# Run it as your normal user; it calls sudo itself for the firewall rules.

set -g default_name "super duper hotspot"

# One firewall rule per entry, matched on the hotspot interface: DHCP and DNS
set -g rules "-p udp -m multiport --dports 53,67" "-p tcp --dport 53"

function usage
    echo "Usage: "(status basename)" [-s | --settings] [-h | --help]"
    echo "  (no option)     switch between hotspot and WLAN mode"
    echo "  -s, --settings  change the hotspot's name and/or password"
    echo "  -h, --help      show this help"
end

# UUID of the NetworkManager profile in access point mode
function hotspot_uuid
    for uuid in (nmcli -g UUID,TYPE connection show | string match -rg '^(.+):802-11-wireless$')
        set -l mode (nmcli -g 802-11-wireless.mode connection show $uuid)
        if test "$mode" = ap
            echo $uuid
            return
        end
    end
    return 1
end

function hotspot_name -a uuid
    nmcli -e no -g connection.id connection show $uuid
end

function hotspot_active -a uuid
    test -n "$uuid"; and contains -- $uuid (nmcli -g UUID connection show --active)
end

function wifi_interface -a uuid
    set -l iface
    if test -n "$uuid"
        set iface (nmcli -g connection.interface-name connection show $uuid)
    end
    if test -z "$iface"
        set iface (nmcli -t -f DEVICE,TYPE device | string match -r '^[^:]+(?=:wifi$)')[1]
    end
    echo $iface
end

# Asks for a new password twice and stores it in $entered_password (empty when the user just
# presses Enter)
function read_password -a prompt
    set -g entered_password
    read -l -s -P "$prompt" password; or return
    test -z "$password"; and return
    set -l length (string length -- "$password")
    if test $length -lt 8 -o $length -gt 63
        echo "❌ The password needs 8 to 63 characters" >&2
        return 1
    end
    read -l -s -P "Repeat the password: " repeated; or return
    if test "$password" != "$repeated"
        echo "❌ The passwords don't match" >&2
        return 1
    end
    set entered_password $password
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
    echo "❔ NetworkManager has no hotspot profile yet, creating it"
    read -l -P "Hotspot name [$default_name]: " name; or return
    test -z "$name"; and set name $default_name
    read_password "Hotspot password (8 to 63 characters): "; or return
    set -l password $entered_password
    if test -z "$password"
        echo "❌ The hotspot needs a password" >&2
        return 1
    end
    nmcli connection add type wifi ifname $iface con-name $name autoconnect no ssid $name \
        802-11-wireless.mode ap 802-11-wireless.band bg \
        ipv4.method shared ipv6.method ignore \
        wifi-sec.key-mgmt wpa-psk wifi-sec.proto rsn wifi-sec.pairwise ccmp wifi-sec.group ccmp \
        wifi-sec.psk $password >/dev/null; or return
    echo "✅ Created hotspot '$name'"
end

function change_settings -a uuid iface
    if test -z "$uuid"
        create_hotspot $iface
        return
    end

    set -l name (hotspot_name $uuid)
    echo "⚙️  Settings of hotspot '$name' (press Enter to keep the current value)"
    read -l -P "Name [$name]: " new_name; or return
    read_password "Password [unchanged]: "; or return
    set -l new_password $entered_password

    set -l changes
    if test -n "$new_name" -a "$new_name" != "$name"
        set -a changes connection.id $new_name 802-11-wireless.ssid $new_name
    end
    if test -n "$new_password"
        set -a changes 802-11-wireless-security.psk $new_password
    end
    if test (count $changes) -eq 0
        echo "ℹ️  Nothing changed"
        return
    end

    nmcli connection modify $uuid $changes; or return
    echo "✅ Saved the new settings of hotspot '"(hotspot_name $uuid)"'"
    if hotspot_active $uuid
        nmcli connection up $uuid >/dev/null; or return
        echo "🔄 Restarted the hotspot with the new settings; clients have to reconnect"
    end
end

function to_wlan -a uuid iface
    echo "📡 Hotspot '"(hotspot_name $uuid)"' is active, switching to WLAN mode"
    nmcli connection down $uuid >/dev/null; or return
    close_ports $iface
    echo "🔍 Looking for known WLAN networks…"
    nmcli device wifi rescan ifname $iface 2>/dev/null
    sleep 3
    if nmcli --wait 30 device connect $iface >/dev/null 2>&1
        set -l network (nmcli -e no -g GENERAL.CONNECTION device show $iface)
        echo "📶 Now in WLAN mode, connected to '$network'"
    else
        echo "📶 Now in WLAN mode, but no known network is in range yet; NetworkManager keeps looking"
    end
end

function to_hotspot -a uuid iface
    set -l network (nmcli -e no -g GENERAL.CONNECTION device show $iface)
    if test -n "$network"
        echo "📶 WLAN mode is active (connected to '$network'), switching to hotspot mode"
    else
        echo "📶 WLAN mode is active (not connected), switching to hotspot mode"
    end

    if test -z "$uuid"
        create_hotspot $iface; or return
        set uuid (hotspot_uuid)
    end

    set -l uplink (ip route show default | string match -rv " dev $iface( |\$)")
    if test -z "$uplink"
        echo "⚠️  No internet connection besides $iface (e.g. USB tethering); hotspot clients will be offline"
    end

    open_ports $iface; or return
    if not nmcli connection up $uuid >/dev/null
        echo "❌ Could not start the hotspot" >&2
        close_ports $iface
        return 1
    end
    echo "📡 Hotspot '"(hotspot_name $uuid)"' is now active"
end

if not argparse h/help s/settings -- $argv
    usage >&2
    exit 1
end
if set -q _flag_help
    usage
    exit 0
end

set -l uuid (hotspot_uuid)
set -l iface (wifi_interface $uuid)
if test -z "$iface"
    echo "❌ No Wi-Fi device found" >&2
    exit 1
end

if set -q _flag_settings
    change_settings "$uuid" $iface
else if hotspot_active $uuid
    to_wlan $uuid $iface
else
    to_hotspot "$uuid" $iface
end
