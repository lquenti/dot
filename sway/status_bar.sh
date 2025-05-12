date=$(date +'%d.%m.%Y %H:%M:%S')
bat=$(cat /sys/class/power_supply/BAT0/capacity)
echo "$bat% | $date"
