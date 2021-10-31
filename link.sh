#!/usr/bin/env sh
#
# Author: Fabio Ribeiro <faabiosr@gmail.com>
# Part of https://github.com/faabiosr/exegol

SCRIPT=$(readlink -f "$0")
BASE_DIR=$(dirname "${SCRIPT}")
HOME_DIR=${BASE_DIR}/home

_out () {
    echo '=>' $@
}

_link () {
    echo "linking files"
    for f in $(find ${HOME_DIR} -type f -name '*' -printf "%P ")
    do
        _out ${f}
        mkdir -p $(dirname ${HOME}/${f})
        ln -sf "${HOME_DIR}/${f}" "${HOME}/${f}"
    done
}

_unlink () {
    echo "unlinking files"
    for f in $(find ${HOME_DIR} -type f -name '*' -printf "%P ")
    do
        _out ${f}
        unlink "${HOME}/${f}"
    done
}

[ "$1" = "-u" ] && _unlink || _link
