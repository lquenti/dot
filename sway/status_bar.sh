temp=$(sensors -j | jq '(.["coretemp-isa-0000"]["Core 0"].temp2_input * 10 | floor) / 10')
bat1=$(cat /sys/class/power_supply/BAT0/capacity)
bat2=$(cat /sys/class/power_supply/BAT0/status)
date=$(date +'%a. %d.%m.%Y %H:%M')
echo "${temp}°C | $bat1% ($bat2) | $date"
