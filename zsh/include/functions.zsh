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

straceall() {
	process="${1}"
	shift
	strace ${@} $(pgrep "${process}" | sed 's/\([0-9]*\)/-p \1/g')
}

rsl() {
	local currentPath
	unset REPORTTIME
	# Try locating the file
	if [ -f "${1}" ]; then
		currentPath="${1}"
	else
		currentPath="$(type -p "${1}" | cut -d' ' -f3-)"
	fi

	if [ -z "${currentPath}" ]; then
		return
	fi

	# Start resolving
	for i in {1..15}; do
		\ls --color "${currentPath}"
		if [ -L "${currentPath}" ]; then
			currentPath="$(readlink "${currentPath}")"
		else
			return 0
		fi
	:
	done
}

function ssh() {
	unset REPORTTIME
	@DOTFILES@/scripts/import-ssh
	REPORTTIME=0
	command ssh "${@}"
}

wiresharkRemote() {
	unset REPORTTIME
	local host
	host="${1}"
	shift

	ssh "${host}" sudo nix shell nixpkgs#tcpdump -c tcpdump -U -s0 -w - ${*} | wireshark -k -i -
}
