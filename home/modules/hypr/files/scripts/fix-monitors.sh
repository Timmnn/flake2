#!/usr/bin/env bash

# Monitor fix script for NVIDIA + Hyprland
# Run this if monitors are detected but running at wrong refresh rates

echo "Fixing monitor configuration..."

# Force reload compositor
hyprctl reload

# Wait a bit for detection
sleep 2

# Set specific monitor configurations
hyprctl keyword monitor "eDP-1,1920x1080@60,0x800,1"
hyprctl keyword monitor "HDMI-A-3,2560x1440@144,1920x800,1" 
hyprctl keyword monitor "DP-3,2560x1440@144,4480x0,1,transform,1"

# Check current monitors
echo "Current monitor status:"
hyprctl monitors

# Check if external monitors are detected
external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name')

if [[ -z "$external_monitors" ]]; then
    echo "No external monitors detected, trying to force detection..."
    
    # Try to wake up monitors
    sudo ddcutil detect --async
    
    # Force DRM mode refresh
    sudo modprobe -r nvidia_drm
    sudo modprobe nvidia_drm
    
    sleep 3
    hyprctl reload
    
    echo "Retrying monitor detection..."
    hyprctl monitors
fi

echo "Monitor fix complete!"