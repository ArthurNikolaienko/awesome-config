#!/bin/sh

#Run with sudo
# [ "$UID" -eq 0 ] || { echo "This script m ust be run as root."; exit 1;}

deps=(
  # Desktop
  xorg{,-xinit}
  xsel
  awesome
  #picom #Regular picom will do, but i recommend using picom-ibhagwan-git from aur
  nitrogen
  rofi
  lxappearance
  gnome-themes-extra
  lxqt-policykit
  pcmanfm
  gvfs
  xarchiver
  unzip
  unrar
  p7zip
  atril

  #Editors
  vim
  neovim
  python-neovim
  code

  #Clipboard manager
  copyq

  #Screenshots
  flameshot

  #Password manager
  keepassxc

  git
  ssh-tools

  #Browsers
  firefox
  firefox-developer-edition
  chromium

  #The only thing Skype works with
  gnome-keyring

  #Sound
  pipewire{,-jack,-pulse,-alsa}
  wireplumber

  #Fonts
  ttf-dejavu
  noto-fonts{-emoji,-cjk}
)

# This packages won't be installed. They will be downloaded to ~/aur.
# You need to manually review them and run makepkg -si
aur_deps=(
  skypeforlinux-stable-bin
  picom-ibhagwan-git 
  webstorm
  nerd-fonts-hack
)

#install required packages
sudo pacman -Syu "${deps[@]}" --noconfirm --needed

#Assume this repo was cloned to ~/.config/awesome/
awesome_repo="$HOME/.config/awesome"

# link configs
ln -sf "$awesome_repo/rofi" "$HOME/.config/rofi"

# download AUR packages
for pkg in ${aur_deps[@]}; do
  git clone "https://aur.archlinux.org/$pkg.git" "$HOME/.aur/$pkg"
done
