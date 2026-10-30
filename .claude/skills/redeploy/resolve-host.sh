#!/usr/bin/env bash
# Resolves which nixosConfigurations output the redeploy skill applies on this machine.
#
#   resolve-host.sh          detect the configuration this machine runs
#   resolve-host.sh <host>   validate an explicitly requested configuration
#
# Run from the repository root. On success prints key=value lines:
#   host=<output to apply>  current=<detected output or "unknown">  source=<how current was found>
# Exits non-zero with a message on stderr when the host cannot be determined or applied here.
# Detection never guesses: it uses only
#   1. /etc/nixos-flake-host, written by every configuration in flake.nix
#   2. a hostname that is itself a flake output and that the output sets as networking.hostName
#   3. the ThinkPad's DMI product name (20KHS2LF00)
set -euo pipefail

requested="${1:-}"

hosts=$(nix eval --raw .#nixosConfigurations --apply 'c: builtins.concatStringsSep "\n" (builtins.attrNames c)') || {
  echo "error: could not evaluate the flake's nixosConfigurations" >&2
  exit 1
}

is_host() { grep -qxF -- "$1" <<<"$hosts"; }

current=""
source=""
if [[ -r /etc/nixos-flake-host ]]; then
  marker=$(tr -d '[:space:]' </etc/nixos-flake-host)
  if is_host "$marker"; then
    current=$marker
    source=/etc/nixos-flake-host
  else
    echo "warning: /etc/nixos-flake-host names '$marker', which is not a flake output (anymore)" >&2
  fi
fi
if [[ -z $current ]]; then
  name=$(uname -n)
  if is_host "$name" &&
    [[ $(nix eval --raw ".#nixosConfigurations.$name.config.networking.hostName") == "$name" ]]; then
    current=$name
    source=hostname
  fi
fi
if [[ -z $current ]] &&
  [[ $(cat /sys/class/dmi/id/product_name 2>/dev/null) == 20KHS2LF00 ]] && is_host thinkpadx1carbon; then
  current=thinkpadx1carbon
  source=dmi
fi

if [[ -n $requested ]]; then
  if ! is_host "$requested"; then
    echo "error: '$requested' is not a configuration in this flake. Available:" >&2
    sed 's/^/  /' <<<"$hosts" >&2
    exit 1
  fi
  host=$requested
elif [[ -n $current ]]; then
  host=$current
else
  cat >&2 <<EOF
error: cannot detect which configuration this machine runs.
  /etc/nixos-flake-host is missing (the machine has not been switched to a configuration that
  writes it yet), the hostname '$(uname -n)' does not identify a flake output, and the DMI
  product name '$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo unknown)' is not known.
  Nothing was built. Run the skill once with the host as argument, e.g. /redeploy <host>. Available:
$(sed 's/^/    /' <<<"$hosts")
EOF
  exit 2
fi

host_system=$(nix eval --raw ".#nixosConfigurations.$host.pkgs.stdenv.hostPlatform.system")
this_system=$(nix eval --raw --impure --expr builtins.currentSystem)
if [[ $host_system != "$this_system" ]]; then
  echo "error: $host is built for $host_system, this machine is $this_system; it cannot run it" >&2
  exit 1
fi

echo "host=$host"
echo "current=${current:-unknown}"
echo "source=${source:-none}"
