###############
## set the terminal emulator's title
###############

autoload -U add-zsh-hook

add-zsh-hook precmd precmd
add-zsh-hook preexec preexec

termTitle() {
	case "$TERM" in
		cygwin|xterm*|putty*|rxvt*|ansi)
			print -Pn "\e]2;$1:q\a" # set window name
			print -Pn "\e]1;$1:q\a" # set tab name
			;;
		screen*|tmux*)
			print -Pn "\ek$1:q\e\\" # set screen hardstatus
			;;
	esac
}

# Gets executed before showing the prompt
precmd() {
	termTitle 'zsh'
}

# Gets executed before running a command
preexec() {
	local cmd

	if [ "$#" -lt 1 ]; then
		return
	fi
	setopt local_options
	setopt shwordsplit
	set -- $1

	# Handle sudo
	if [ "$1" = 'sudo' ]; then
		if ! [ "$2" = '-h' -o "$2" = '-K' -o "$2" = '-k' -o "$2" = '-V' -o "$2" = '-v' -o "$2" = '-l' ]; then
			# Running some command through sudo
			shift # shift away sudo
			while :; do
				# User entered no command
				if [ -z "$1" ]; then
					break
				fi
				# sudo flags
				if [[ "$1" =~ '^-[AknSbEHnPis]*' ]]; then
					# Handles flags and parameters combined
					if [[ "$1" =~ '[aCcghprtu]$' ]]; then
						shift
					fi
					shift
					continue
				fi
				# sudo parameters
				if [[ "$1" =~ '-[aCcghprtu]$' ]]; then
					shift 2
					continue
				fi
				# environment variable
				if [[ "$1" =~ '^[\w\d_]*=' ]]; then
					shift
					continue
				fi
				break
			done
		fi
	elif [ "${1:0:2}" = '$(' ]; then
		set -- zsh
	fi
	# Set title
	termTitle "${1##*/}"
}
