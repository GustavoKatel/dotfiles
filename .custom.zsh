

alias q="exit"

alias rmpyc="find . -name '*.pyc' -delete"

alias venv="source venv/bin/activate"

alias ..="cd .."
alias ...="cd ../.."

alias du-sort="du -h . | sort -h -r"

alias st="git status"

alias nv="nvim"

alias nvu="/Applications/goneovim.app/Contents/MacOS/goneovim >/dev/null 2>&1 & disown"

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
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
alias nl=nvm_load

# task integration
source $HOME/dev/task.sh

source $HOME/dev/shell_recursive_counter.sh

alias ee=exa
alias ea="exa -lh --git --icons"

export PATH="$HOME/go/bin/:$PATH"

alias pyenv_load=$HOME/dev/pyenv_load.sh

# legalist goodies
source ~/dev/legalist/env_prompt.sh
alias legalist_shell=~/dev/legalist/env_shell.sh

alias rosetta_shell=$HOME/dev/apple_silicon_shims/rosetta_shell.sh

# homebrew
#alias brew=$HOME/dev/apple_silicon_shims/brew.sh
alias mbrew="/opt/homebrew/bin/brew"
alias ibrew="rosetta_shell /usr/local/bin/brew"
# end homebrew

eval $(starship init zsh)
