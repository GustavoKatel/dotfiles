# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="mars"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  kubectl
  kube-ps1
)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

alias q="exit"

alias clipi="xsel -b -i"
alias clipo="xsel -b -o"

#alias code="code-oss --enable-proposed-api GitHub.vscode-pull-request-github"

alias rmpyc="find . -name '*.pyc' -delete"

alias venv="source venv/bin/activate"

alias ..="cd .."
alias ...="cd ../.."

alias du-sort="du -h . | sort -h -r"

alias st="git status"

alias nv="nvim"

alias nvu="xfce4-terminal --command=nvim --working-directory=$PWD"

function done-notify() {
  if [ $? -eq 0 ]; then
    RESULT="Ok"
  else
    RESULT="Fail ($?)"
  fi
  pb push "Done: $RESULT"
}

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# FZF
FZF_BINDINGS=/usr/share/fzf/key-bindings.zsh
[ -f $FZF_BINDINGS ] && source $FZF_BINDINGS
FZF_COMPLETITIONS=/usr/share/fzf/completion.zsh
[ -f $FZF_COMPLETITIONS ] && source $FZF_COMPLETITIONS

# NVM - wrappers to avoid big init delays
function nvm_load() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
alias nl=nvm_load

function json() {
  nvm_load
  fx $@
}

# Miniconda
# export PATH=$HOME/miniconda3/bin:$PATH

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# dry docker version integration
source $HOME/Projects/dry.sh

# task integration
source $HOME/Projects/task.sh

# docker-machine extensions
source $HOME/Projects/docker-machine-wrapper.sh
source $HOME/Projects/docker-machine-prompt.sh

# Shell recursive counter
source $HOME/Projects/shell_recursive_counter.sh

export PATH=/opt/ngrok:$PATH

# go bin path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

function conda_load() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/home/gustavokatel/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/home/gustavokatel/miniconda3/etc/profile.d/conda.sh" ]; then
          . "/home/gustavokatel/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="/home/gustavokatel/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
}

function pyenv_load() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PYENV_VERSION=3.7.9
  eval "$(pyenv init -)"
}

# Disable KUBE_PS1
kubeoff

function docker-rmf() {
  docker rm $(docker ps -a -f status=exited -q)
}

alias sysupdate="cargo make --makefile $HOME/Projects/sysupdate.toml"

alias ee=exa
alias ea="exa -lh --git --icons"

# legalist goodies
source ~/Jobs/legalist/env_prompt.sh
alias legalist_shell=~/Jobs/legalist/env_shell.sh

cat ~/.config/sequences

eval $(starship init zsh)

