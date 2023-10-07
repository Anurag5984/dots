# -(Fish)- #

fish_add_path ~/Bin ~/.cargo/bin ~/.local/bin ~/Clone/zig-0.12.0 ~/.bun/bin
# set --erase --universal fish_user_paths[5]

source ~/.config/fish/functions/autojump.fish
source ~/.config/fish/functions/functions.fish
source ~/.config/fish/functions/tmux.fish
printf %b '\e]4;4;#6495ed\a'

set -gx EDITOR nvim
set -gx VISUAL nvim
set fish_greeting
set -g fish_key_bindings fish_default_key_bindings

export FZF_DEFAULT_OPTS=" --bind='ctrl-t:execute(nvim {})+abort' --cycle --reverse --prompt ' ' --pointer ' ' --marker='✔' -m --height=20% --color=bg+:#395b91,gutter:-1 --no-separator"
export MANPAGER="nvim +Man!"
eval "$(thefuck --alias)"

alias ..="cd .."
alias ...="cd ../.."

alias vi="nvim"
alias vim="nvim -c ':Oil'"
alias lv="lvim"
alias hx="flatpak run com.helix_editor.Helix -c ~/.config/helix/config.toml"
alias code="echo '󰨞 Codium ' && flatpak run com.vscodium.codium . ; sleep 3 ; xdotool key F11"
alias pn="pnpm"
alias px="pnpx"

alias cat="bat -p --theme=OneHalfDark"
alias ls="exa --icons --group-directories-first"
alias la="exa --icons -a --group-directories-first"
alias ll="exa --icons -l --group-directories-first"
alias lp="exa | xargs sxiv -t -f"
alias tree="exa --icons --tree --group-directories-first"
alias pwd="/bin/pwd | lolcat"
alias ywd="/bin/pwd | lolcat ; /bin/pwd | xclip -selection clipboard"
alias rm="trash"

alias update="sudo dnf update"
alias install="sudo dnf install"
alias remove="sudo dnf remove"
alias i="sudo dnf install"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias nf="neofetch "
alias live="$HOME/dots/scripts/live && sleep 0.5"
alias icat="kitty +kitten icat"
alias opacity="~/.config/alacritty/opacity_alacritty.sh"

bind \eq 'exit'
bind \ec 'clear; commandline -f repaint'
bind \er 'echo " Ranger" && ranger ; commandline -f repaint'
bind \ee 'echo " Neovim" && nvim -c ": Oil" ; commandline -f repaint'
bind \eg 'echo "󱓞 Jump to" && cd $(pwd | find -type d -maxdepth 3  | tail -n +2 | fzf) ; commandline -f repaint'
bind \eG 'echo "󱓞 Jump to" && cd $(echo $HOME | find -type d -maxdepth 3  | tail -n +2 | fzf ) ; commandline -f repaint'

