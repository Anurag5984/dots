function fish_prompt
    # This is a simple prompt. It looks like
    # alfa@nobby /path/to/dir $
    # with the path shortened and colored
    # and a "#" instead of a "$" when run as root.
    set -l symbol ' $ '
    set -l color $fish_color_cwd

    set_color $color
    echo -n (prompt_pwd)
    set_color normal

    echo -n $symbol
end
