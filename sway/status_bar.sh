date=$(date +'%d.%m.%Y %H:%M')
bat1=$(cat /sys/class/power_supply/BAT0/capacity)
bat2=$(cat /sys/class/power_supply/BAT0/status)
echo "$bat1% ($bat2) | $date"
