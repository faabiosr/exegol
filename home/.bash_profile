# ~/.bash_profile
#
# Author: Fabio Ribeiro <faabiosr@gmail.com>
# Part of https://github.com/faabiosr/exegol
# vim: noet ts=4 sw=4 ft=sh:

# Non-interactive shell, don't do anything.
[ -z "${PS1}" ] && return

source "${HOME}/.bash_environment"

# Load bash profile based on OS
source "${HOME}/.bash_profile_$(uname -s | tr A-Z a-z)"

# Load WSL profile
[ ! -z "$(uname -a | grep 'microsoft')" ] && source "${HOME}/.bash_profile_wsl"

# Load private bash profile
[ -r "${HOME}/.bash_private" ] && source "${HOME}/.bash_profile"

# Aliases
alias l="ls"
alias ll="ls -lah"
alias sl="ls"

alias ..="cd .."
alias .-="cd -"

alias vi='nvim'
alias vim='nvim'

# Search for a binary path inside home
[ -d "${HOME}/bin" ] && export PATH="${HOME}/bin:$PATH"

# Enable GIT prompt options
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\w]\[\e[39m\]" " " " \[\e[0;36m\][%s\[\e[0;36m\]]\[\e[39m\]"'

# Search for a binary path inside go path
[ -d "${GOPATH}/bin" ] && export PATH="${GOPATH}/bin:$PATH"
