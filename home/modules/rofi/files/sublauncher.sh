#!/bin/bash

# Function to show main menu
show_main_menu() {
    options="a
b"
    
    chosen=$(echo -e "$options" | rofi -dmenu -p "Choose")
    
    case $chosen in
        "a")
            show_submenu_a
            ;;
        "b")
            show_submenu_b
            ;;
        "")
            # User pressed ESC, exit
            exit 0
            ;;
    esac
}

# Function for submenu A
show_submenu_a() {
    sub_options="a1
a2"
    
    sub_chosen=$(echo -e "$sub_options" | rofi -dmenu -p "A Menu")
    
    case $sub_chosen in
        "a1") 
            echo "You chose A1" 
            ;;
        "a2") 
            echo "You chose A2" 
            ;;
        "")
            # User pressed ESC, go back to main menu
            show_main_menu
            ;;
    esac
}

# Function for submenu B
show_submenu_b() {
    sub_options="b1
b2"
    
    sub_chosen=$(echo -e "$sub_options" | rofi -dmenu -p "B Menu")
    
    case $sub_chosen in
        "b1") 
            echo "You chose B1" 
            ;;
        "b2") 
            echo "You chose B2" 
            ;;
        "")
            # User pressed ESC, go back to main menu
            show_main_menu
            ;;
    esac
}

# Start with main menu
show_main_menu
