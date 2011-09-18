#!/usr/bin/env bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak
    fi

    ln -sf ${source} ${target}
}

if [ "$1" = "vim" ]; then
    for i in _vim*
    do
        echo linking $i
       link_file $i
    done
else
    for i in _*
    do
        link_file $i
    done
fi

echo "first sync"
git submodule sync
echo "first init"
git submodule init
echo "first update"
git submodule update

echo "pull for each"
git submodule foreach git pull origin master
echo "init for each"
git submodule foreach git submodule init
echo "update for each"
git submodule foreach git submodule update

# setup command-t

#Dont care for command t
#cd _vim/bundle/command-t
#rake make

#Note, cygwin and cassini don't have certificates sooo
#export GIT_SSL_NO_VERIFY=true
