# ~/.bash_profile
#
# Author: Fabio Ribeiro <faabiosr@gmail.com>
# Part of https://github.com/faabiosr/exegol

# Non-interactive shell, don't do anything.
[ -z "${PS1}" ] && return

# Aliases
alias l="ls"
alias ll="ls -laht"
alias sl="ls"

alias ..="cd .."
alias .-="cd -"

# Search for a binary path inside home
[ -d "${HOME}/bin" ] && export PATH="${HOME}/bin:$PATH"
