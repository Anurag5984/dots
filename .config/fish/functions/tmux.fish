
function t --description "jump to Tmux"
    set dir1 (autojump $argv[1])
    set sessions (tmux ls)

    if set -q TMUX
        tmux new -ds $(basename $dir1) -c $dir1
        tmux switch-client -t $(basename $dir1)
    else
        tmux new -s $(basename $dir1) -c $dir1
    end
end


function tmux_attach
    set sessions (tmux ls | grep -o '^[^:]*')

    if set -q TMUX
        if test (count $sessions) -eq 1
            # Do nothing
        else
            tmux choose-session
        end
    else
        if test (count $sessions) -eq 1
            tmux attach $selected_session
        else if test (count $sessions) -eq 0
            tmux new -s Main
        else
            set selected_session (tmux list-sessions | fzf)
            tmux attach $selected_session
        end
    end
end

alias rename_tab="tmux rename-window"
bind \ea 'tmux_attach; commandline -f repaint'





