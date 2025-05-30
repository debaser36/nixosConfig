#!/usr/bin/env fish

function get_connected_monitors
    set -l output_json '{'

    echo "🔍 Detecting graphics card..." >&2
    set -l card_paths /sys/class/drm/card*
    if test (count $card_paths) -eq 0
        echo "❌ No cardX found in /sys/class/drm/" >&2
        return 1
    end

    set -l card (basename (readlink -f $card_paths[1]))
    echo "✅ Using card: $card" >&2

    echo "🔍 Scanning outputs for card: $card" >&2
    set -l connected_outputs
    for f in /sys/class/drm/$card-*/status
        set -l monitor_status (cat $f)
        set -l output_name (basename (dirname $f))
        echo "- Found output $output_name with status: $monitor_status" >&2
        if test "$monitor_status" = "connected"
            set -a connected_outputs $output_name
        end
    end

    set -l monitor_count (count $connected_outputs)
    echo "✅ Connected outputs: $monitor_count" >&2

    set output_json "$output_json\"card\": \"$card\","
    set output_json "$output_json\"monitoramount\": $monitor_count,"
    set output_json "$output_json\"monitors\": {"

    for output in $connected_outputs
        echo "📦 Reading EDID for output: $output"
        set -l edid_path "/sys/class/drm/$output/edid"
        echo "🔍 EDID path: $edid_path"
        if test -e "$edid_path"
            edid-decode -s --skip-sha $edid_path > ./LOG.txt
            set -l edid_output (cat ./LOG.txt)
            #echo "📄 EDID output for $output: $edid_output"

            set -l vendor (echo "$edid_output" | string match -rg 'Manufacturer: ([A-Z0-9]+)')
            set -l model (echo "$edid_output" | string match -rg "Display Product Name: '([^']+)'")
            set -l serial (echo "$edid_output" | string match -rg "Display Product Serial Number: '([^']+)'")
            
            if test -z "$vendor"
               set vendor "Unknown"
            end

            if test -z "$model"
               set model "Unknown"
            end

            if test -z "$serial"
               set serial "Unknown"
            end


            echo "🖥️  Output $output info:"
            echo "   - Vendor: $vendor"
            echo "   - Model:  $model"
            echo "   - Serial: $serial"
            echo "   - Best resolution: $best_res"

            

            set -l monitors_json_entry "\"$identifier\": {\"mappedToOutput\": \"$output_base\", \"highestResolution\": \"$best_res\"}"

            set -a monitors_entries $monitors_json_entry
        else
            echo "❌ No EDID found for $output"
        end
    end

    set -l joined_monitors (string join ", " $monitors_entries)


   echo "{
  \"card\": \"$card\",
  \"monitoramount\": (count $connected_outputs),
  \"monitors\": {
    $joined_monitors
  }
}"
end

get_connected_monitors
