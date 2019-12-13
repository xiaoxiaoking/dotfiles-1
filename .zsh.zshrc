. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2> /dev/null || true

precmd () { rehash }

autoload -U zargs
setopt extendedglob
setopt globdots

fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -U compinit
compinit

setopt auto_menu
setopt complete_in_word
setopt always_to_end

(( $+commands[dircolors] )) && eval "$(dircolors -b)"
zstyle ':completion:*'           list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:*'   menu select
zstyle ':completion:*'           matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh"; mkdir -p "$HOME/.cache/zsh"

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

multibind () {  # cmd in-string [in-string...]
    for instr in ${@:2}; do
        bindkey $instr $1
    done
}

bindkey ' ' magic-space
bindkey '^[[Z' reverse-menu-complete
# multibind delete-char '^[[3~' "^[3'5~" '\e[3~'  # see Selection below

multibind beginning-of-line '^[[1;5A' '^[[H' '^[[1~'
multibind end-of-line '^[[1;5B' '^[[F' '^[[4~'

# multibind backward-word '^[[1;5D' '^[[5~'  # see Selection below
# multibind forward-word '^[[1;5C' '^[[6~'  # see Selection below

push-line-and-clear() { zle .push-line; zle .clear-screen }
zle -N push-line-and-clear
bindkey '^L' push-line-and-clear

expand-aliases() {  # https://unix.stackexchange.com/a/150737
    unset 'functions[_expand-aliases]'
    functions[_expand-aliases]=$BUFFER
    (($+functions[_expand-aliases])) &&
        BUFFER=${functions[_expand-aliases]#$'\t'} &&
        CURSOR=$#BUFFER
}
zle -N expand-aliases
bindkey '\e^E' expand-aliases

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
multibind history-beginning-search-backward-end '^[OA' '^[[A'
multibind history-beginning-search-forward-end  '^[OB' '^[[B'

bindkey -r '^s'

zcheck () {
    if [[ "$#" -gt 0 ]]; then
        grep -E --color=auto -i "$@" ~/.*zshrc || which "$@"
    else
        tail -vn +1 ~/.zshrc ~/.*.zshrc
    fi
}

# Selection: https://stackoverflow.com/a/30899296
r-delregion() {
    if ((REGION_ACTIVE)); then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

r-deselect() {
    ((REGION_ACTIVE = 0))
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

r-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

key-left () { r-deselect backward-char $@ }
zle -N key-left
bindkey '^[[D' key-left

key-right () { r-deselect forward-char $@ }
zle -N key-right
bindkey '^[[C' key-right

key-cleft () { r-deselect backward-word $@ }
zle -N key-cleft
multibind key-cleft '^[[1;5D' '^[[5~'

key-cright () { r-deselect forward-word $@ }
zle -N key-cright
multibind key-cright '^[[1;5C' '^[[6~'

key-sleft () { r-select backward-char $@ }
zle -N key-sleft
bindkey '^[[1;2D' key-sleft   # no good without tmux

key-sright () { r-select forward-char $@ }
zle -N key-sright
bindkey '^[[1;2C' key-sright  # no good without tmux

key-bs () { r-delregion backward-delete-char $@ }
zle -N key-bs
bindkey '^?' key-bs

key-del () { r-delregion delete-char $@ }
zle -N key-del
multibind key-del '^[[3~' "^[3'5~" '\e[3~'

key-csleft () { r-select backward-word $@ }
zle -N key-csleft
bindkey '^[[1;6D' key-csleft  # no good without tmux

key-csright () { r-select forward-word $@ }
zle -N key-csright
bindkey '^[[1;6C' key-csright # no good without tmux
# ^ Selection ^
