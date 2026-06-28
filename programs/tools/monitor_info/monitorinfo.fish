#!/usr/bin/env fish

function get_connected_monitors

    echo "🔍 Scanning DRM connectors..." >&2

    set -l active_card ""
    set -l connected_outputs

    for f in /sys/class/drm/card*-*/status

        if not test -e $f
            continue
        end

        set -l conn (string trim (cat $f))
        set -l output (basename (dirname $f))
        set -l card (string replace -r '/sys/class/drm/(card[0-9]+)-.*' '$1' $f)

        echo "- $output ($card): $conn" >&2

        if test "$conn" = "connected"
            set active_card $card
            set -a connected_outputs $output
        end
    end

    if test -z "$active_card"
        echo "❌ No active display found" >&2
        echo '{ "card": null, "monitoramount": 0, "monitors": {} }'
        return 0
    end

    set -l monitor_count (count $connected_outputs)

    echo "✅ Active card: $active_card" >&2
    echo "✅ Connected outputs: $monitor_count" >&2

    set -l monitors_entries

    for output in $connected_outputs
        set -l edid_path "/sys/class/drm/$output/edid"

        if not test -e $edid_path
            continue
        end

        set -l edid_output (edid-decode -s --skip-sha $edid_path)

        set -l vendor (echo "$edid_output" | string match -rg 'Manufacturer: ([A-Z0-9]+)')
        set -l model (echo "$edid_output" | string match -rg 'Model: ([0-9]+)')
        set -l alt_name (echo "$edid_output" | string match -rg "Alphanumeric Data String: '([^']+)'")
        set -l serial (echo "$edid_output" | string match -rg 'Serial Number: ([0-9]+)')

        if test -z "$vendor"
            set vendor "Unknown"
        end

        # model fallback chain
        if test -z "$model"
            if test -n "$alt_name"
                set model $alt_name
            else
                set model "Unknown"
            end
        end

        if test -z "$serial"
            set serial "Unknown"
        end

        set -l entry "\"$output\": {\"vendor\": \"$vendor\", \"model\": \"$model\", \"serial\": \"$serial\"}"
        set -a monitors_entries $entry
    end

    set -l joined (string join ", " $monitors_entries)

    echo "{ \"card\": \"$active_card\", \"monitoramount\": $monitor_count, \"monitors\": { $joined } }"
end

get_connected_monitors