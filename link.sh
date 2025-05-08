#!/usr/bin/env sh
#
# Author: Fabio Ribeiro <faabiosr@gmail.com>
# Part of https://github.com/faabiosr/exegol

# osx gnu apps
if [ $(uname) == "Darwin" ];
then
    alias find="gfind"
    alias readlink="greadlink"
fi

SCRIPT=$(readlink -f "$0")
BASE_DIR=$(dirname "${SCRIPT}")
HOME_DIR=${BASE_DIR}/home

files=$(find ${HOME_DIR} -type f -name '*' -not -path '*AppData/*' -not -path '*scoop/*' -not -path '*Documents/*' -printf "%P ")

_link () {
    echo "linking files"
    for f in $files
    do
        echo "=> ${f}"
        mkdir -p $(dirname ${HOME}/${f})
        ln -sf "${HOME_DIR}/${f}" "${HOME}/${f}"
    done
}

_unlink () {
    echo "unlinking files"
    for f in $files
    do
        echo "=> ${f}"
        unlink "${HOME}/${f}"
    done
}

[ "$1" = "-u" ] && _unlink || _link
