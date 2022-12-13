###############
## Try to launch tmux
################

if hash tmux 2>/dev/null; then
	tmuxname='autoattach'

	# TMUX -> OUTERTMUX
	if [ -z "${OUTERTMUX}" -a ! -z "${TMUX}" ]; then
		export OUTERTMUX="${TMUX}"
		unset TMUX
	fi
	# Check if we already have an outer tmux
	if [ -z "${OUTERTMUX}" ]; then
		# Check if a base session exists
		if [ "$(tmux -L "${tmuxname}" ls 2>/dev/null | grep "^${tmuxname}-base:" | wc -l)" = 0 ]; then
			# Create new base session
			exec tmux -2 -L "${tmuxname}" new-session -s "${tmuxname}-base"
		else
			# Attach to existing base session
			sessionid="$(date +%s)"
			tmux -2 -L "${tmuxname}" new-session -d -t "${tmuxname}-base" -s "${tmuxname}-${sessionid}"
			exec tmux -2 -L "${tmuxname}" attach-session -t "${tmuxname}-${sessionid}"
		fi
	fi
fi
