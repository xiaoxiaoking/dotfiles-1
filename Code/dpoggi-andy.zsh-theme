if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

name="%{$fg[$NCOLOR]%}%n%{$reset_color%}"
host="%{$fg[cyan]%}%m%{$reset_color%}"
tty="%{$fg[cyan]%}$(echo $TTY | egrep -o '\w+$')%{$reset_color%}"
directory="%{$fg[magenta]%}%~%{$reset_color%}"
time="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"

PROMPT='${name}@${host}.${tty}:${directory}$(git_prompt_info)
%{$fg[red]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'
RPROMPT='${time}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
