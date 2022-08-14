#!/bin/sh

function get_volume() {
    echo "$(wpctl get-volume @DEFAULT_SINK@ | awk -F': ' '{print $2}')"
}

current_vol=$(get_volume | awk -F'.' '{print ((100 * $1)+$2)}')
step='3%'

if [ $1 == 'inc' ]; then
    if [ $current_vol -lt 100 ]; then
        wpctl set-volume @DEFAULT_SINK@ "$step"+
    fi
elif [ $1 == 'dec' ]; then
    if [ $current_vol -gt 0 ] ; then
        wpctl set-volume @DEFAULT_SINK@ "$step"-
    fi
fi

echo $current_vol