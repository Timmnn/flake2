#!/bin/bash

# Simple rofi launcher
options="a
b"

# Show the menu
chosen=$(echo -e "$options" | rofi -dmenu -p "Choose")

# Do something based on choice
case $chosen in
    "a")
        echo "You chose A"
        ;;
    "b") 
        echo "You chose B"
        ;;
esac
