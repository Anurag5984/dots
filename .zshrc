####################
##      ZSH       ##
####################

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "hlissner/zsh-autopair"
plug "Aloxaf/fzf-tab"
plug "marlonrichert/zsh-autocomplete"

# Options
bindkey "^[[3~" delete-char
export PATH="$HOME/.cargo/bin:$HOME/.emacs.d/bin:$HOME/.config/scripts:$HOME/.config/emacs/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim

# source /usr/share/autojump/autojump.bash
printf %b '\e]4;4;#6495ed\a'

eval "$(thefuck --alias)"
export FZF_DEFAULT_OPTS=" --bind='ctrl-t:execute(nvim {})+abort' --cycle --reverse --prompt ' ' --pointer ' ' --marker='✔' -m --height=20% --color=bg+:#395b91,gutter:-1 --no-separator"
export MANPAGER="sh -c 'col -bx | bat --theme=OneHalfDark -l man -p'"


## ALIAS ##
alias ..='cd ..'
alias ...='cd ../..'

alias vi="nvim"
alias vim="nvim ./"
alias hx="flatpak run com.helix_editor.Helix -c ~/.config/helix/config.toml"
alias conf="ranger /home/admiral/dots"
alias pn="pnpm"

alias cat="bat -p --theme=OneHalfDark"
alias ls="exa --icons --group-directories-first"
alias la="exa --icons -a --group-directories-first"
alias ll="exa --icons -l --group-directories-first"
alias lp="exa | xargs sxiv -t -f"
alias tree="exa --icons --tree --group-directories-first"
alias pwd="/bin/pwd | lolcat ; /bin/pwd | xclip -selection clipboard"

alias gc="git clone"
alias update="sudo dnf update"
alias i="sudo dnf install"
alias install="sudo dnf install"

alias nf="neofetch "
alias live="$HOME/dots/scripts/live && sleep 0.5"
alias icat="kitty +kitten icat"

# Key Binds
quit_zsh() {
    exit
}
zle -N quit_zsh
bindkey "^[q" quit_zsh


# Load and initialise completion system
autoload -Uz compinit
compinit

# PROMPT
autoload -Uz vcs_info
autoload -U colors && colors

zstyle ':vcs_info:*' enable git 

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='!' # signify new files with a bang
    fi
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%})%{$reset_color%}"

PROMPT="%B%{$fg[yellow]%}⚡% %(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+="\$vcs_info_msg_0_ "


# Functions
function md {
    mkdir -p $argv
    if [[ $? -eq 0 ]]; then
        case $argv[-1] in
            -*)
                ;;
            *)
                cd $argv[-1]
                ;;
        esac
    fi
}

function backup {
    cp $argv[1] $argv[1].bak
}

function cd {
    if [[ -n $1 ]]; then
        builtin cd $1
        exa --icons
    else
        builtin cd ~
        exa --icons
    fi
}

function r {
    local dir1=$(autojump $1)

    if [[ -n $2 ]]; then
        local dir2=$(autojump $2)
    fi

    if [[ -n $3 ]]; then
        local dir3=$(autojump $3)
    fi

    ranger $dir1 $dir2 $dir3
}

function z {
    local dir1=$(autojump $1)
    builtin cd $dir1

    local session_name=$(basename $dir1)
    zellij -s $session_name
}

function j {
    cd $(autojump $1)
}


