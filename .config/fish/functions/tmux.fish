
function t --description "jump to Tmux"
    set dir1 (autojump $argv[1])

    # Check if dir1 is equal to a single dot (.)
    if test "$dir1" = "."
        return
    end

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
        # Do nothing
    else
        if test (count $sessions) -eq 1
            tmux attach
        else if test (count $sessions) -eq 0
            tmux new -s Main
        else
            echo -e "\n\n\e[1m\e[34mTmux Sessions:\e[0m"

            set selected_session (gum choose --selected="Clone" --cursor=" " $sessions)
            set selected_session (string split ":" $selected_session)[1]

            tmux attach -t $selected_session
        end
    end
end

bind \ea 'tmux_attach; commandline -f repaint'

