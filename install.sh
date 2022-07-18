#!/bin/sh

set -e
set -x

DISTRO=$(lsb_release -a | grep -o 'Distributor ID:[^ ,]\+')
DISTRO="${DISTRO##*:}"
DISTRO=$(echo $DISTRO | tr '[:upper:]' '[:lower:]')

case "$DISTRO" in
  "ubuntu")
    sudo apt update
    sudo apt install imagemagick systemd-container
    ;;
  "fedora")
    sudo dnf install ImageMagick
    sudo dnf copr enable zirix/gdm-wallpaper
    sudo dnf install gdm-wallpaper
    ;;
  *)
    echo "Distro not supported yet."
    ;;
esac

WALLPAPER_DIR=$HOME/Pictures/Wallpapers
NAME="rotate-wallpaper"
blur_radius='30'

mkdir $HOME/.local/share/$NAME
mkdir $HOME/.local/share/$NAME/plain
mkdir $HOME/.local/share/$NAME/blurred
mkdir $HOME/.local/share/$NAME/bin
mkdir $HOME/.config/$NAME

DATA_DIR=$HOME/.local/share/$NAME
CONFIG_DIR=$HOME/.config/$NAME

for wallpaper in $WALLPAPER_DIR/*; do
  cp $wallpaper $DATA_DIR/plain

  convert $wallpaper -filter Gaussian -blur 0x$blur_radius $DATA_DIR/blurred/"${wallpaper##*/}"
done

sed -i "s|\$HOME|${HOME}|g" wallpaper_desktop.sh
sed -i "s|\$HOME|${HOME}|g" wallpaper_shutdown.sh
sed -i "s|\$DISTRO|${DISTRO}|g" wallpaper_shutdown.sh
sed -i "s|\$HOME|${HOME}|g" rotate-wallpaper.service
sed -i "s|\$HOME|${HOME}|g" rotate-wallpaper.desktop

cp wallpaper_desktop.sh $DATA_DIR/bin
cp wallpaper_shutdown.sh $DATA_DIR/bin
sudo cp rotate-wallpaper.service /etc/systemd/system/
cp rotate-wallpaper.desktop $HOME/.config/autostart

sudo systemctl enable rotate-wallpaper.service
sudo systemctl start rotate-wallpaper.service 
