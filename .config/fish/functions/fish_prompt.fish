function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color -o blue)(prompt_pwd)' '

    # echo -n (set_color red)''(set_color yellow)''(set_color green)' '
    # echo -n (set_color 4efce0)' '
    echo -n (set_color 3ac7b0)' '
    set_color normal
end
