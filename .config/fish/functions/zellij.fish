
function z --description "jump to Zellij"
    set dir1 (autojump $argv[1])
    builtin cd $dir1

    set session_name (basename $dir1)
    zellij -s $session_name
end


function zellij_attach
    set sessions (zellij list-sessions)

    if test (count $sessions) -eq 1
        zellij attach $sessions[1] && sleep 0.2 && xdotool key enter
    else if test (count $sessions) -eq 0
        zellij && sleep 0.2 && xdotool key enter
    else
        set selected_session (zellij list-sessions | fzf)
        zellij attach $selected_session && sleep 0.2 && xdotool key enter
    end
end

alias rename_tab="zellij action rename-tab "
bind \ea 'zellij_attach' 

