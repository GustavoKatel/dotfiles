alias myip="curl http://myip.dnsomatic.com ; and echo ''"

alias clipi="xsel -b -i"
alias clipo="xsel -b -o"

alias g5="cd /media/Arquivos/g5"

alias q="exit"

alias upgrade="sudo apt update ; and sudo apt upgrade"

function pretty-json
    python -mjson.tool
end

set -x EDITOR 'vim'

# git helpers

alias push="git push"

alias commit="git commit"

# use x to open nvim
alias x="nvim"

# Enable direnv (per directory variables)
eval (direnv hook fish)

# add rustup to the path
# set PATH /home/$USER/.cargo/bin $PATH
