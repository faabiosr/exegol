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
[ -r "${HOME}/.bash_private" ] && source "${HOME}/.bash_private"

# Aliases
alias l="ls"
alias ll="ls -lah"
alias sl="ls"

alias ..="cd .."
alias .-="cd -"

alias vi='nvim'
alias vim='nvim'

alias godoc="godoc -http='127.0.0.1:6060'"

# Functions

# tmux alias
tm () {
	# list tmux sessions
	if [ -z "${1}" ]; then
		tmux ls
		return
	fi

	# if a sessions exists and attach
	for s in $(tmux ls -F '#{session_name}' 2> /dev/null); do
		[ $s != ${1} ] && continue

		tmux attach -t ${1}
		return
	done

	# create session
	tmux new -s ${1}
}

# tmuxp alias
tmp () {
    # list all tmuxp fronzen sessions.
    if [ -z "${1}" ]; then
        for i in $(ls ${HOME}/.tmuxp); do
            echo ${i} | sed "s/.yaml//g";
        done
        return
    fi

    # check if a frozen sessions.
    for s in $(tmux ls -F '#{session_name}' 2> /dev/null); do
        [ $s != ${1} ] && continue

        echo "session was loaded, please use tmux"
    done

    # load fronzen session
    tmuxp load ${1}
}

# extracts the given file
x () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# generates an uuid.
uuid () {
    uuidgen | awk '{print tolower($1)}'
}

# generates an uuid and send to clipboard.
uuidp () {
    echo -n $(uuid) | pbcopy
}

# Search for a binary path inside home
[ -d "${HOME}/bin" ] && export PATH="${HOME}/bin:$PATH"

# Enable GIT prompt options
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

PROMPT_COMMAND='__git_ps1 "\[\e[0;36m\][\w]\[\e[39m\]" " " " \[\e[0;36m\][%s\[\e[0;36m\]]\[\e[39m\]"'

# Search for a binary path inside go path
[ -d "${GOPATH}/bin" ] && export PATH="${GOPATH}/bin:$PATH"

# Search for a binary path inside python local
[ -d "${HOME}/.local/bin" ] && export PATH="${HOME}/.local/bin:$PATH"
