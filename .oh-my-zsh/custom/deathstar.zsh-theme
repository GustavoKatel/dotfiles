local ret_status="%(?:%{$fg_bold[cyan]%}✔ :%{$fg_bold[red]%}✘ )"

PROMPT='%{$fg_bold[red]%}➜  ${ret_status}%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info) λ '

RPROMPT='%{$fg_bold[yellow]%} $(deathstart_command_duration) %{$fg_bold[red]%}Λ %{$fg[cyan]%}$(date +%H:%M:%S)%{$reset_color%}'


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"


##### COMMAND DURATION #####
export DEATHSTAR_COMMAND_DURATION=""

function deathstart_preexec() {
  timer=$SECONDS
  DEATHSTAR_COMMAND_DURATION=""
}

function deathstart_precmd() {
  if [ $timer ]; then
    export DEATHSTAR_COMMAND_DURATION=$(($SECONDS - $timer))
    timer=""
  else
    DEATHSTAR_COMMAND_DURATION=""
  fi
}

function deathstart_command_duration() {

    if [ $DEATHSTAR_COMMAND_DURATION ]; then

        # 0s
        if [ $DEATHSTAR_COMMAND_DURATION -eq 0 ]; then
            DEATHSTAR_COMMAND_DURATION=""
        # days
        elif [ $DEATHSTAR_COMMAND_DURATION -gt 86400 ]; then
            DEATHSTAR_COMMAND_DURATION="~$(($DEATHSTAR_COMMAND_DURATION / 86400))d"
        # hours
        elif [ $DEATHSTAR_COMMAND_DURATION -gt 3600 ]; then
            DEATHSTAR_COMMAND_DURATION="~$(($DEATHSTAR_COMMAND_DURATION / 3600))h"
        # minutes
        elif [ $DEATHSTAR_COMMAND_DURATION -gt 60 ]; then
            DEATHSTAR_COMMAND_DURATION="~$(($DEATHSTAR_COMMAND_DURATION / 60))m"
        else
            DEATHSTAR_COMMAND_DURATION="${DEATHSTAR_COMMAND_DURATION}s"
        fi

        echo $DEATHSTAR_COMMAND_DURATION
    fi

}

autoload -U add-zsh-hook
add-zsh-hook precmd deathstart_precmd
add-zsh-hook preexec deathstart_preexec
