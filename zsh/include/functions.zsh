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

source "$zshincl/extract.zsh"
