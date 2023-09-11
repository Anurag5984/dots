#!/bin/bash

opacity=$(grep "opacity: " ~/.config/alacritty/alacritty.yml | awk '{print $NF}')
opacity_final=$opacity

if [ "$1" == "inc" ]; then
    opacity_final=$(awk -v opacity="$opacity" 'BEGIN {printf "%.2f", opacity + 0.05}')
elif [ "$1" == "dec" ]; then
    opacity_final=$(awk -v opacity="$opacity" 'BEGIN {printf "%.2f", opacity - 0.05}')
else
    opacity_final=$1
fi

sed -i "s/opacity: $opacity/opacity: $opacity_final/g" ~/.config/alacritty/alacritty.yml
echo -e  "\e[33m  $opacity  $opacity_final \n \e[0m"

