#!/bin/sh

set -e
set -x

if [ "$#" -eq "0" ]; then
  wallpaper=$(ls $HOME/.local/share/wallpaper-at-boot/plain | sort -R | tail -1)
  echo "$wallpaper" > $HOME/.config/wallpaper-at-boot/wallpaper
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.local/share/wallpaper-at-boot/plain/$wallpaper"
  gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/wallpaper-at-boot/plain/$wallpaper"
  sudo set-gdm-wallpaper $HOME/.local/share/wallpaper-at-boot/blur/$wallpaper
fi
