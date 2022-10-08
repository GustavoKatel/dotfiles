
export GPG_TTY=$(tty)

alias q="exit"

alias rmpyc="find . -name '*.pyc' -delete"

alias venv="source venv/bin/activate"

alias ..="cd .."
alias ...="cd ../.."

alias du-sort="du -h . | sort -h -r"

alias st="git status"

alias nv="nvim"

alias nvu="/Applications/goneovim.app/Contents/MacOS/goneovim --maximized >/dev/null 2>&1 & disown"

alias k="kubectl"

alias nr="npm run"
alias pnr="pnpm run"

function done-notify() {
  if [ $? -eq 0 ]; then
    RESULT="Ok"
  else
    RESULT="Fail ($?)"
  fi
  pb push "Done: $RESULT"
}

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM - wrappers to avoid big init delays
function nvm_load() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
alias nl=nvm_load
nvm_load

#function ssh() {
    #if [ "$TERM"=="xterm-kitty" ]; then
        ##kitty +kitten ssh $*
        #TERM="xterm-256color" ssh $*
    #else
        #ssh $*
    #fi
#}

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# END NVM wrappers

# task integration
#source $HOME/dev/task.sh

source $HOME/dev/shell_recursive_counter.sh

alias ee=exa
alias ea="exa -lh --git --icons"

export PATH="$HOME/go/bin/:$PATH"

alias pyenv_load=$HOME/dev/pyenv_load.sh

bindkey "\e[1;3D" backward-word # alt(option) + <-
bindkey "\e[1;3C" forward-word # alt(option) + ->

# Setup bindings for both smkx and rmkx key variants
# Home
bindkey '\e[H'  beginning-of-line
bindkey '\eOH'  beginning-of-line
# End
bindkey '\e[F'  end-of-line
bindkey '\eOF'  end-of-line
# Up
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
# Down
bindkey '\e[B' down-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
# Left
bindkey '\e[D' backward-char
bindkey '\eOD' backward-char
# Right
bindkey '\e[C' forward-char
bindkey '\eOC' forward-char
# Delete
bindkey '\e[3~' delete-char
# Backspace
bindkey '\e?' backward-delete-char
# PageUp
bindkey '\e[5~' up-line-or-history
# PageDown
bindkey '\e[6~' down-line-or-history
# Ctrl+Left
bindkey '\e[1;5D' backward-word
# Ctrl+Right
bindkey '\e[1;5C' forward-word
# Shift+Tab
bindkey '\e[Z' reverse-menu-complete

[ -f $HOME/.custom_work.zsh ] && source $HOME/.custom_work.zsh

eval $(starship init zsh)

