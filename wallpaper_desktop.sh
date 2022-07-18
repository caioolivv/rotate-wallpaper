#!/bin/sh

set -e
set -x

NAME="rotate-wallpaper"
DATA_DIR=$HOME/.local/share/$NAME
CONFIG_DIR=$HOME/.config/$NAME
WALLPAPER_DIR=$HOME/Pictures/Wallpaper

current_wallpaper=$(cat $CONFIG_DIR/wallpaper)

gsettings set org.gnome.desktop.background picture-uri-dark "file://$DATA_DIR/plain/$current_wallpaper"
gsettings set org.gnome.desktop.background picture-uri "file://$DATA_DIR/plain/$current_wallpaper"
