export EDITOR=/usr/bin/vim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GPG_TTY=$(tty)
export BROWSER="firefox-developer-edition"
PATH="$HOME/bin:$HOME/.local/bin:$PATH:/usr/lib/dart/bin:$HOME/.pub-cache/bin"

# custom env variables
export ZSH=$HOME"/.oh-my-zsh"
export ZSH_LOAD=$ZSH/load
export ZSH_PRELOAD=$ZSH_LOAD/preload
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="$HOME/.config/wget/wgetrc"
export INPUTRC="$HOME/.config/inputrc"
