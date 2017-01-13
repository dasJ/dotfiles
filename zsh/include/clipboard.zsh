clipboard() {
	# Read answerback to ^E
	old="$(stty -F /dev/tty -g)"
	stty -F /dev/tty raw -echo min 0 time 3
	# TODO Only use tmux escapes in tmux
	echo -ne '\033Ptmux;\005\033\\' > /dev/tty
	read answerback < /dev/tty
	stty -F /dev/tty "${old}"

	# Somebody piped to this script
	if [ ! -t 0 ]; then
		case "${answerback}" in
			PuTTY|KiTTY)
				# TODO Only use tmux escapes in tmux
				printf '\033Ptmux;\033\033[5i%s\033\033[4i\033\\' "$(< /dev/stdin)"
			;;
		esac
		# TODO Write to st
	else
		# Nobody piped to this script
		# TODO READ CLIPBOARD
	fi
}
