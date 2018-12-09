###############
## Functions
################

mkcd() {
	[ "${1}" ] || return 0
	[ -d "${1}" ] || mkdir -vp "${1}"
	[ -d "${1}" ] && builtin cd "${1}"
}

kopt() {
	[ -z "${1}" ] && return 1
	zgrep -i "${1}" /proc/config.gz
}

deps() {
	local bin dir
	# Find file
	# May be relative from PWD,
	# in PATH or in /usr/lib.
	if [ -f "${1}" ]; then
		bin="${1}"
	elif bin=$(which "${1}"); then
		:
	elif [ -f "/usr/lib/${1}" ]; then
		bin="/usr/lib/${1}"
	else
		echo "error: binary not found: ${1}"
		return 1
	fi
	# Output absolute path if it was changed
	if [ "${bin}" -a "${1}" != "${bin}" ]; then
		printf '%s => %s\n\n' "${1}" "${bin}"
	fi
	objdump -p "${bin}" | awk '/NEEDED/ { print $2 }'
}

straceall() {
	process="${1}"
	shift
	strace ${@} $(pgrep "${process}" | sed 's/\([0-9]*\)/-p \1/g')
}

tick() {
	[ "${#}" -lt 2 ] && return 1
	deadline="${1}"
	shift
	in +tickle wait:"${deadline}" "${@}"
}

alright() {
	unset REPORTTIME
	[ -z "${TMUX}" ] && TMUX="${OUTERTMUX}"
	export TMUX
	# Right side
	tmux splitw -h -p 85 calcurse
	# Left side
	tmux splitw -v -l $((${LINES} - 7)) -t 1 tasksh
	# Wait until tasksh started and clear screen
	(sleep .2; tmux send-keys -t 2 ^L) &
	# Go to calcurse and rename window
	tmux select-pane -t 3
	tmux rename-window 'My Day'
	# Run status
	exec @DOTFILES@/scripts/taskstatus
}

source "$zshincl/extract.zsh"
source "$zshincl/ldapid.zsh"
