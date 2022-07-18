#!/bin/sh

set -e
set -x

NAME="rotate-wallpaper"
DATA_DIR=$HOME/.local/share/$NAME
CONFIG_DIR=$HOME/.config/$NAME
WALLPAPER_DIR=$HOME/Pictures/Wallpaper

current_wallpaper=$(cat $CONFIG_DIR/wallpaper)

for wallpaper in $WALLPAPER_DIR; do
  if [ -e $DATA_DIR/plain/$wallpaper ]; then
  else
    cp $wallpaper $DATA_DIR/plain
  fi
done

for wallpaper in $DATA_DIR/plain; do
  if [ !-e $WALLPAPER_DIR/$wallpaper ] && [ "$wallpaper" != "$current_wallpaper" ]; then
    rm $wallpaper
    rm $DATA_DIR/blurred/$wallpaper
  fi
done

new_wallpaper=$(ls $DATA_DIR/plain | sort -R | tail -1)

while [ "$new_wallpaper" = "$current_wallpaper" ]; do
  new_wallpaper=$(ls $DATA_DIR/plain | sort -R | tail -1)
done

echo $new_wallpaper > $CONFIG_DIR/wallpaper

case "$DISTRO" in
  ubuntu)
    sudo machinectl shell gdm@ /bin/bash
    gsettings set com.ubuntu.login-screen background-picture-uri 'file://$DATA_DIR/blurred/$new_wallpaper'
    ;;
  fedora)
    sudo set-gdm-wallpaper $DATA_DIR/blurred/$new_wallpaper
    ;;
  *)
    ;;
esac
