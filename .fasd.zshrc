if [ $commands[fasd] ]; then # check if fasd is installed
    fasd_cache="$HOME/.cache/fasd-init-cache"
    if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
        fasd --init auto >| "$fasd_cache"
    fi
    source "$fasd_cache"
    unset fasd_cache
    # unalias a s d f sd sf z zz
    alias j="fasd_cd -d"
    alias jj="fasd -d -i"
fi
