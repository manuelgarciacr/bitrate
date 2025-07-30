#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/utils.sh"

lan_icon=$(get_tmux_option "@tmux2k-bitrate-ethernet-icon" "󰈀")
wifi_icon=$(get_tmux_option "@tmux2k-bitrate-wifi-icon" "")
essid=$(get_tmux_option "@tmux2k-bitrate-essid" "false")
no_names=$(get_tmux_option "@tmux2k-bitrate-no-names" "false")
filteredInterfaces=$(get_tmux_option "@tmux2k-bitrate-devices" "")

space=$(echo -e "\u2800")

if [ "$essid" != "true" ]; then
    essid="false"
fi
if [ "$no_names" != "true" ]; then
    no_names="false"
fi

get_lan() {
    local allInterfaces=$(ls /sys/class/net | awk '{print $1}')
    local OUTPUT=""
    
    for DEVICE in $allInterfaces; do
        local BITRATE=$(ethtool $DEVICE | grep -i speed | awk '{print $2}')
        local PREVIOUS_BITRATE=$(get_tmux_option "tmux2k-bitrate-previous-$DEVICE" "waiting...")
        local DATA=""

        # Filter
             
        if [[ -n "$filteredInterfaces" ]] && [[ ! " $filteredInterfaces " =~ " $DEVICE " ]]; then
            continue
        fi
    
		if [[ ! $BITRATE =~ ^[0-9]+[[:space:]]*[a-zA-Z\/]+$ ]]; then
			continue
		fi
		
        # BITRATE
     
        if [ -n "$BITRATE" ]; then
            BITRATE=$(echo "$BITRATE" | sed -r 's/([0-9]+)/ & /g') 
            PREVIOUS_BITRATE="$BITRATE"
            tmux set -g "tmux2k-bitrate-previous-$DEVICE" "$PREVIOUS_BITRATE..."
        fi
   
        local DATA="$DATA $PREVIOUS_BITRATE"
        
        # DEVICE data
   
        if [[ "$no_names" == "true" ]]; then
            DEVICE=""
        else
        	DEVICE="$DEVICE:"
        fi

        if [ -n "$DATA" ]; then 
            DATA=$(printf '%s' "$lan_icon $DEVICE$DATA")
        else
            DATA=$(printf '%s' "$lan_icon $DEVICE")
        fi

		if [ -n "$OUTPUT" ]; then 
            OUTPUT="$OUTPUT $DATA"
        else
            OUTPUT="$DATA"
        fi
    done
    
    echo $OUTPUT
}

get_wifi() {
    local allInterfaces=$(cat <<<$(iwconfig  2>/dev/null) | grep ESSID | awk '{print $1 }')
    local OUTPUT=""
    
    for DEVICE in $allInterfaces; do
        local ESSID=$(iwconfig $DEVICE | grep -oP '(?<=ESSID:\").*(?=\")')
        local BITRATE=$(iwconfig $DEVICE | grep -oP '(?<=Bit Rate=).*' | awk '{print $1, $2}')
        local WPOWER=$(iwconfig $DEVICE | grep -oP '(?<=Tx-Power=).*' | awk '{print $1, $2}')
        local PREVIOUS_BITRATE=$(get_tmux_option "tmux2k-bitrate-previous-$DEVICE" "waiting...")
        local DATA=""
        local bitrate_var_name="$DEVICE_bitrate"
	
        # Filter
        
        if [[ -n "$filteredInterfaces" ]] && [[ ! " $filteredInterfaces " =~ " $DEVICE " ]]; then
            continue
        fi
            
        # ESSID
        
        if [[ "$essid" == "true" && -n "$ESSID" ]]; then
            local DATA="$DATA $ESSID"
        fi
        
        # BITRATE
        
        if [ -n "$BITRATE" ]; then
            PREVIOUS_BITRATE="$BITRATE"
            tmux set -g "tmux2k-bitrate-previous-$DEVICE" "$PREVIOUS_BITRATE..."
        fi
   
        local DATA="$DATA $PREVIOUS_BITRATE"
        
        # POWER
        
        if [ -n "$WPOWER" ]; then
            local DATA="$DATA $WPOWER"
        fi
        
        # DEVICE data
        
        if [[ "$no_names" == "true" ]]; then
            DEVICE=""
        else
        	DEVICE="$DEVICE:"
        fi

        if [ -n "$DATA" ]; then 
            DATA=$(printf '%s' "$wifi_icon $space$DEVICE$DATA")
        else
            DATA=$(printf '%s' "$wifi_icon $space$DEVICE")
        fi

        if [ -n "$OUTPUT" ]; then 
            OUTPUT="$OUTPUT $DATA"
        else
            OUTPUT="$DATA"
        fi
    done
    
    echo $OUTPUT
}

main() {
    local OUTPUT=$(get_lan)
    local WIFI=$(get_wifi)

	if [ -n "$WIFI" ]; then
        OUTPUT="$OUTPUT $WIFI"
    fi
    echo "$OUTPUT"
}

main