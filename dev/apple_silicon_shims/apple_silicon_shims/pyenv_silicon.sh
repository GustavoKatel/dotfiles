# PYENV
ARCH=`arch`
if [[ "${ARCH}"  == "arm64" ]]; then
    export PYENV_ROOT="$HOME/.pyenv/arm64"
else
    export PYENV_ROOT="$HOME/.pyenv/rosetta"
fi
PYENV_BIN="$PYENV_ROOT/bin"
export PYENV_SHELL=zsh
# export PYENV_ROOT=$(pyenv root)
# export PYENV_VERSION=$(pyenv version-name)
export PYTHONPATH=$PYENV_ROOT/shims

export PATH="$PYENV_ROOT/bin:$PATH"


if [[ "${ARCH}"  == "arm64" ]]; then
    PREFIX="/opt/homebrew/opt"
else
    PREFIX="/usr/local/opt"
fi

LIBS=( \
"${PREFIX}/zlib" \
"${PREFIX}/bzip2" \
"${PREFIX}/readline" \
"${PREFIX}/sqlite" \
"${PREFIX}/openssl@1.1" \
"${PREFIX}/postgresql" \
)

for LIB in ${LIBS[*]}; do

    BINDIR="$LIB/bin"
    if [ -d "${BINDIR}" ]; then
        export PATH="${BINDIR}:$PATH"
    fi

    LIBDIR="$LIB/lib"
    if [ -d "${LIBDIR}" ]; then
        export LDFLAGS="-L${LIBDIR} $LDFLAGS"
        export DYLD_LIBRARY_PATH="${LIBDIR}:$DYLD_LIBRARY_PATH"
        PKGCFGDIR="${LIBDIR}/pkgconfig"
        if [ -d "${PKGCFGDIR}" ]; then
            export PKG_CONFIG_PATH="${PKGCFGDIR} $PKG_CONFIG_PATH"
        fi
    fi

    INCDIR="$LIB/include"
    if [ -d "${INCDIR}" ]; then
        export CFLAGS="-I${INCDIR} $CFLAGS" 
    fi

done

export CPPFLAGS="${CFLAGS}"
export CXXFLAGS="${CFLAGS}"


#export PYTHON_CONFIGURE_OPTS="--enable-framework"
#export PYTHON_CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl) ${PYTHON_CONFIGURE_OPTS}"


eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
