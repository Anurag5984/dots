#!/bin/bash
shopt -s autocd 
export EDITOR='nvim'
export VISUAL='nvim'
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";
HISTSIZE= HISTFILESIZE= # Infinite history.
export PATH="$HOME/.cargo/bin:$PATH"

PS1='\[\e[38;5;63;1m\]\w\[\e[0m\] \[\e[38;5;49m\]$(git branch 2>/dev/null | grep '"'"' ^* '"'"' | colrm 1 2)\[\e[38;5;49m\] \[\e[0m\]'
printf '\e]4;4;#6495ed\a'

## ALIAS ##
alias ..='cd ..'
alias ...='cd ../..'

alias vi="nvim"
alias vim="nvim ./"
alias hx="flatpak run com.helix_editor.Helix -c ~/.config/helix/config.toml"
alias conf="ranger /home/admiral/dots"
alias pn="pnpm"

alias cat="bat -p --theme=OneHalfDark"
alias ls="exa --icons"
alias la="exa --icons -a"
alias ll="exa --icons -l"
alias lp="exa | xargs sxiv -t -f"
alias tree="exa --icons --tree"
alias pwd="/bin/pwd | lolcat ; /bin/pwd | xclip -selection clipboard"

alias gc="git clone"
alias update="sudo dnf update"
alias i="sudo dnf install"
alias install="sudo dnf install"

alias nf="neofetch "
alias live="$HOME/dots/scripts/live && sleep 0.5"
alias icat="kitty +kitten icat"

eval "$(thefuck --alias)"


# Functions
function md() {
    mkdir -p "$@"
    cd "$@"
}


source /home/aadmiral/.config/broot/launcher/bash/br
