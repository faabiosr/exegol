#!/usr/bin/env sh

folder=$(dirname "${0}")

_out () {
    echo '=>' $@
}

_link () {
    echo "linking files"
    for f in $(find ${folder}/home -type f -name '*')
    do
        filename="$(basename ${f})"
        _out ${f}
        ln -sf "${f}" "${HOME}/${filename}"
    done
}

_unlink () {
    echo "unlinking files"
    for f in $(find ${folder}/home -type f -name '*')
    do
        filename="$(basename ${f})"
        _out ${f}
        unlink "${HOME}/${filename}"
    done
}

[ "$1" = "-u" ] && _unlink || _link
