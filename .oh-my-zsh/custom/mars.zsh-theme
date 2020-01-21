# oh-my-zsh Mars Theme

##### COMMAND DURATION #####
MARS_COMMAND_DURATION=""

mars_command_duration() {
  if [ $MARS_COMMAND_DURATION ]; then
      # 0s
      if [ $MARS_COMMAND_DURATION -eq 0 ]; then
          MARS_COMMAND_DURATION=""
          exit
      # days
      elif [ $MARS_COMMAND_DURATION -gt 86400 ]; then
          MARS_COMMAND_DURATION="~$(($MARS_COMMAND_DURATION / 86400))d"
      # hours
      elif [ $MARS_COMMAND_DURATION -gt 3600 ]; then
          MARS_COMMAND_DURATION="~$(($MARS_COMMAND_DURATION / 3600))h"
      # minutes
      elif [ $MARS_COMMAND_DURATION -gt 60 ]; then
          MARS_COMMAND_DURATION="~$(($MARS_COMMAND_DURATION / 60))m"
      else
          MARS_COMMAND_DURATION="${MARS_COMMAND_DURATION}s"
      fi
      echo "[%{$fg_bold[green]%}%{$reset_color%} $MARS_COMMAND_DURATION]"
   fi
}

### NVM

nvm_node_prompt() {
  # Only print if nvm is loaded
  type nvm 2>&1 >/dev/null || exit;

  echo "[%{$fg_bold[yellow]%}%{$reset_color%} `node -v` ]"
}

### Pyenv

pyenv_prompt() {
  # Only print if nvm is loaded
  type pyenv 2>&1 >/dev/null || exit;

  echo "[%{$fg_bold[blue]%}%{$reset_color%} `pyenv version 2>/dev/null | cut -c-5` ]"
}

### Shell recursive counter
shell_counter() {

  ignore_value=0
  if [ -n "$TMUX" ]; then
      # tmux adds one extra session
      ignore_value=1
  fi

  counter=$(($SHELL_RECURSIVE_COUNTER-$ignore_value))

  test $counter -eq 1 && exit;

  echo "[%{$fg_bold[black]%}%{$reset_color%}  $counter ]"
}

### Git [~branch-glyph~ master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX=" [%{$fg_bold[green]%}%{$reset_color%}%{$fg_bold[white]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%} "

mars_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

mars_git_status() {
  _STATUS=""

  # check status of files
  _INDEX=$(command git status --porcelain 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check status of local repository
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $_STATUS
}

mars_git_prompt () {
  local _branch=$(mars_git_branch)
  local _status=$(mars_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}


_PATH="%{$fg_bold[white]%}%~%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$fg_bold[white]%}%n"
  _LIBERTY="%{$fg[green]%}λ"
fi
_USERNAME="$_USERNAME%{$reset_color%}@%m"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

_1LEFT="$_USERNAME $_PATH"
_1RIGHT=""

mars_preexec() {
  timer=$SECONDS
  MARS_COMMAND_DURATION=""
}

mars_precmd () {
  # command duration
  if [ $timer ]; then
    MARS_COMMAND_DURATION=$(($SECONDS - $timer))
    timer=""
  else
    MARS_COMMAND_DURATION=0
  fi

  # prompt
  right="$(mars_command_duration) $_1RIGHT"
  _1SPACES=`get_space $_1LEFT $right`
  print
  print -rP "$_1LEFT$_1SPACES$right"
}

setopt prompt_subst
PROMPT='> $_LIBERTY '
RPROMPT='%{$fg_bold[white]%}$(legalist_check_env [ ])%{$reset_color%} $(kube_ps1) $(shell_counter)$(pyenv_prompt)$(nvm_node_prompt)$(mars_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook precmd mars_precmd
add-zsh-hook preexec mars_preexec
