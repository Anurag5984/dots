# Functions Island

function md -d "Create a directory and set CWD"
    command mkdir -p $argv
    if test $status = 0
        switch $argv[(count $argv)]
            case '-*'

            case '*'
                cd $argv[(count $argv)]
                return
        end
    end
end


# BANG BANG!!
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

bind ! __history_previous_command
bind '$' __history_previous_command_arguments


# set up the same key bindings for insert mode if using fish_vi_key_bindings
if test "$fish_key_bindings" = 'fish_vi_key_bindings'
    bind --mode insert ! __history_previous_command
    bind --mode insert '$' __history_previous_command_arguments
end

function _plugin-bang-bang_uninstall --on-event plugin-bang-bang_uninstall
    bind --erase --all !
    bind --erase --all '$'
    functions --erase _plugin-bang-bang_uninstall
end


# Function for creating a backup file
function backup --argument filename
    cp $filename $filename.bak
end

function s 
    echo -e "\033[31msudo $(history -n 1)\033[0m"
    history -n 1 | sed 's/^ */sudo /' | source
end

function ranger_pwd
  /bin/ranger --choosedir=$HOME/.config/ranger/.rangerdir 
  echo ""
  cat $HOME/.config/ranger/.rangerdir | lolcat
  echo ""
  cd $(cat $HOME/.config/ranger/.rangerdir)
end


function cd --description "auto ls for each cd"
    if [ -n $argv[1] ]
        builtin cd $argv[1]
        and exa --icons 
    else
        builtin cd ~
        and exa --icons 
    end
end


function v --description "Jump to vim"
    cd $(autojump $argv[1])
    nvim ./
end


function r --description "jump to ranger"
    set dir1 (autojump $argv[1])

    if test -n "$argv[2]"
        set dir2 (autojump $argv[2])
    end

    if test -n "$argv[3]"
        set dir3 (autojump $argv[3])
    end

    ranger $dir1 $dir2 $dir3
end


function j
    cd (command autojump $argv)
end


function gc --description "Super Git Clone"
    set clipboard (xclip -o)
    set dir_name (basename $clipboard '.git')
    git clone $clipboard && cd $dir_name
end


function sync_config --description "Sync dot files"
    config add ~/.bashrc ~/.config/alacritty/ ~/.config/fish ~/.config/alacritty/ ~/.config/kitty ~/.config/qutebrowser/ ~/.config/zellij/ ~/.zshrc ~/.config/tmux ~/.config/ranger ~/.config/doom ~/.config/lvim ~/.Xresources  ~/.config/nvim ~/.config/helix/ ~/.config/mpv ~/Scripts

    config commit -m "$(gum input --prompt=" " --placeholder="Write a commit message")" 
    config push
end

