# Aliases
alias myip="curl http://myip.dnsomatic.com && echo ''"
alias xclip="xclip -selection clipboard"
alias doHibernate="dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend"

alias doCleanCache="sysctl -w vm.drop_caches=3"
alias doSleep="xset dpms force off"

# Functions
youtube() {
   # mplayer -fs -cookies -cookies-file cookie.txt $(youtube-dl -g --cookies cookie.txt -f 18 "http://www.youtube.com/watch?v=$1")
   echo "Not implemented"
}

pretty-json() {
    if [ $# -gt 0 ]; then
        echo $* | python -mjson.tool
    else
        python -mjson.tool
    fi
}

lsport() {
    if [ $# == 0 ]; then
        echo "Usage: lsport [port]"
        return
    fi  

     sudo lsof -n -P -i :$1
    
}

openserver() {
   ncat  -k -l $*
}

# PATH
export NDK_ROOT=~/android-ndk
export SDK_ROOT=~/android-sdks

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
