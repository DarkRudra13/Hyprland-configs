#!/bin/bash

# -------------------------------
# SETTINGS
# -------------------------------
WALLDIR="$HOME/Pictures/Wallpapers"
CACHEDIR="$HOME/.cache/rofi-wallpapers"
THEME="$HOME/.config/rofi/launchers/type-3/style-6.rasi"

# -------------------------------
# CREATE CACHE FOLDER
# -------------------------------
mkdir -p "$CACHEDIR"

# -------------------------------
# GENERATE THUMBNAILS (IF MISSING)
# -------------------------------
for img in "$WALLDIR"/*; do
    [ -f "$img" ] || continue

    filename=$(basename "$img")
    thumb="$CACHEDIR/$filename.png"

    if [ ! -f "$thumb" ]; then
        magick "$img" -resize 500x500^ -gravity center -extent 500x500 "$thumb"
    fi
done

# -------------------------------
# BUILD ROFI MENU WITH ICONS
# -------------------------------
SELECTED=$(for img in "$WALLDIR"/*; do
    [ -f "$img" ] || continue

    filename=$(basename "$img")
    echo -e "$filename\x00icon\x1f$CACHEDIR/$filename.png"
done | rofi -dmenu \
    -theme "$THEME" \
    -show-icons \
    -columns 4 \
    -p "Select Wallpaper")

# -------------------------------
# EXIT IF NOTHING SELECTED
# -------------------------------
[ -z "$SELECTED" ] && exit

# -------------------------------
# APPLY WALLPAPER (HYPRLAND)
# -------------------------------
swww img "$WALLDIR/$SELECTED" \
    --transition-type wave \
    --transition-duration 1.5
