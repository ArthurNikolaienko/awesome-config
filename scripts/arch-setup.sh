#!/bin/bash

#Assume this repo was cloned to ~/.config/awesome/
awesome_repo="$HOME/.config/awesome"

#Run with sudo
# [ "$UID" -eq 0 ] || { echo "This script m ust be run as root."; exit 1;}

deps=(
  # Desktop
  xorg{,-xinit}
  xsel
  awesome
  picom #Regular picom will do, but i recommend using picom-ibhagwan-git from aur
  nitrogen
  rofi
  kitty
  lxappearance
  gnome-themes-extra
  lxqt-policykit
  pcmanfm
  ffmpegthumbnailer
  gvfs
  xarchiver
  unzip
  unrar
  p7zip
  atril
  gtk3
  adwaita-qt5
  cutefish-icons
  usbutils
  udisks2

  #Utilities
  rclone
  gdu
  bleachbit
  btop
  neofetch
  openvpn
  openresolv
  wget
  libqalculate
  xsecurelock
  playerctl
  lazygit

  # Media
  gpicview
  gpick
  inkscape
  lxmusic
  vlc

  #Editors
  vim
  neovim
  python-neovim
  code
  leafpad

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
  webstorm
  postman-bin
)

echo "Installing packages"
#install required packages
sudo pacman -Syu "${deps[@]}" --noconfirm --needed

systemctl --user enable pipewire wireplumber

# link configs
ln -sf "$awesome_repo/rofi" "$HOME/.config/rofi"
echo "Linked configs"

# download AUR packages
for pkg in "${aur_deps[@]}"; do
  echo "Trying to download PKGBUILD for $pkg"
  git clone "https://aur.archlinux.org/$pkg.git" "$HOME/aur/$pkg"
done


# download wallpapers
wp_dir="$HOME/pictures/wallpapers"

if [ ! -d "$wp_dir" ]; then
  echo 'Downloading wallpapers'
  mkdir "$wp_dir"
  git clone https://gitlab.com/exorcist365/wallpapers.git "$wp_dir"
fi

#install bundled fonts
for dir in "$awesome_repo"/fonts/*; do
  sudo cp "$dir/usr" "/" -r
done

#Write environment vars. OVERRIDES THE FILE!!!
echo 'Writing environment variables'
echo \
'QT_STYLE_OVERRIDE=adwaita-dark
XSECURELOCK_COMPOSITE_OBSCURER=0
XSECURELOCK_DIM_ALPHA=0.8
XSECURELOCK_PASSWORD_PROMPT=time_hex
EDITOR=vim' \
| sudo tee /etc/environment > /dev/null
