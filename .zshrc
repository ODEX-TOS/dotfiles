export ZSH=$HOME"/.oh-my-zsh"
export ZSH_LOAD=$ZSH/load
export ZSH_PRELOAD=$ZSH_LOAD/preload
PATH="$HOME/bin:$HOME/.local/bin:$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"
export PATH=/home/zeus/dev/flutter/bin:$PATH
export PATH=$HOME/bin:$HOME/opt/cross/bin:$PATH
export BROWSER="firefox-developer-edition"

user="dev-edition-default"
if [[ "$(which $BROWSER)" == "/usr/bin/firefox-developer-edition" ]]; then
    if [[ ! -d "$HOME/.mozilla/firefox/*.$user" ]]; then
        $BROWSER -Createprofile "$user"
        git clone https://github.com/F0xedb/dotfiles.git foxfiles
        cp -r foxfiles/tos/tos-firefox/* ~/.mozilla/firefox/*.tosilla
        rm -rf foxfiles
    fi
fi

function load() {
  for script in $(ls $1)
  do
    LOC=$1"/"$script
    if [ -f $LOC ]; then
      #only load a file that is an sh extentions
      if [[ $LOC == *.sh ]]; then
        . $LOC
      fi
    fi
  done
}

#load every script that needs to load before the oh my zsh framework
load $ZSH_PRELOAD

#load the oh my zsh framework
source $ZSH/oh-my-zsh.sh

#load every other script after the oh my zsh framework (thus we can use its functions) 
load $ZSH_LOAD

#print neofetch a terminal information tool
neofetch
