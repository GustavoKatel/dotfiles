# Aliases
alias myip="curl http://myip.dnsomatic.com && echo ''"
alias doHibernate="dbus-send --system --print-reply --dest=\"org.freedesktop.UPower\" /org/freedesktop/UPower org.freedesktop.UPower.Suspend"
alias doCleanCache="sysctl -w vm.drop_caches=3"
alias doSleep="xset dpms force off"

alias clipi="xsel -b -i"
alias clipo="xsel -b -o"

alias g5="cd ~/g5"

alias q="exit"

alias upgrade="sudo aptitude update && sudo aptitude upgrade"

alias la='ls -la'

# vim with nerdtree auto load, also maps for the session the 'q' key to close all windows ('qall')
alias vimt="vim +\"NERDTree .\" +\"command Q qall\" +\"cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Q' : 'q')<CR>\""
alias svim="sudo vim"

# curl for useragents
alias curl-ie="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)\""
alias curl-firefox="curl -H \"User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.0 (.NET CLR 3.5.30729)\""
alias curl-chrome="curk -H \"User-Agent: Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36\""

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

# CONFIG AND PATH
export EDITOR='vim'

export NDK_ROOT=~/android-ndk
export SDK_ROOT=~/android-sdks

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export LD_LIBRARY_PATH="/usr/local/lib:/opt/openmpi/lib:$LD_LIBRARY_PATH"

# MxPost (NLP)
CLASSPATH="/media/Arquivos/g5/ufpb/PIBIC - NLP&ML/AeliusPOS/versions/jmx/mxpost.jar"
export CLASSPATH
PATH="${PATH}:/media/Arquivos/g5/ufpb/PIBIC - NLP&ML/AeliusPOS/versions/jmx"
export PATH

