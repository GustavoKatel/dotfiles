# Aliases
alias myip="curl http://myip.dnsomatic.com && echo ''"

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

# PATH
export NDK_ROOT=~/android-ndk
export SDK_ROOT=~/android-sdks

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
