```
    ____  ____  __________________    ___________
   / __ \/ __ \/_  __/ ____/  _/ /   / ____/ ___/
  / / / / / / / / / / /_   / // /   / __/  \__ \
 / /_/ / /_/ / / / / __/ _/ // /___/ /___ ___/ /
/_____/\____/ /_/ /_/   /___/_____/_____//____/

```

# dotfiles

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/powered-by-electricity.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/fuck-it-ship-it.svg)](https://forthebadge.com)

> This repo contains my dotfiles for `zsh` `i3` `urxvt` `rofi` `polybar` and more.

## Prerequisite

- xserver
- i3-gaps
- urxvt
- zsh
- oh-my-zsh
- rofi
- polybar
- pulseaudio
- mpd
- xclip
- xbacklight
- amixer
- lsd
- dunst

### extension

#### spotify

- python3
- python-dbus
- spotify

This extension enables spotify support in the polybar

#### zsh plugins

- zsh-autosuggestions
- zsh-syntax-highlight

## Arch installer

```
sudo pacman -Syu

#use your pacman wrapper here
yay -Syu i3-gaps rxvt-unicode rofi polybar mpd xclip xbacklight amixer lsd dunst

#install extention
yay -Syu spotify python python-pip
sudo pip install dbus

#install fonts
yay -Syu nerd-fonts-complete ttf-fira-code

#clone .config
cd && mkdir tmp && cd tmp
git clone url
mv dotfiles/* ~/.config
cd && rm -rf tmp

#reload xResources
xrdb .config/.XResources

#install zsh with oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#move .config/.oh-my-zsh to ~/.oh-my-zsh and .config/.zshrc to ~/.zshrc
mv -r ~/.config/.oh-my-zsh ~
mv ~/.config/.zshrc ~

```

## i3 key bindings

| key bind             |                         effect                         |
| -------------------- | :----------------------------------------------------: |
| mod+enter            |                    open a terminal                     |
| mod+Shift+w          |             open firefox-developer-edition             |
| mod+arrow_key        |      focus to the window that the arrow points to      |
| mod+Shift+arrow_key  |              move window to the direction              |
| mod+d                |             open rofi (used to open apps)              |
| mod+number           |                move to workspace number                |
| mod+shift+number     |  move the current focused window to workspace number   |
| mod+q                |                  kill current program                  |
| mod+f                |        toggle program into and from fullscreen         |
| function keys        |             perform the standard function              |
| zebra stripes        |                        are neat                        |
| mod+r                |                   enter resize mode                    |
| mod+arrow            | In resize mode use arrow keys to resize current window |
| mod+esc or mod+enter |                    exit resize mode                    |

## to be included

- explanation for installing zsh plugins
- fix oh-my-zsh submodule
- vim directory
