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
	# Check if we need to spawn the outer tmux
	if [ -z "${OUTERTMUX}" ]; then
		# Check if a base session exists
		if [ "$(tmux -L "${tmuxname}" ls 2>/dev/null | grep "^${tmuxname}-base:" | wc -l)" = 0 ]; then
			# Create new base session
			exec tmux -2 -L "${tmuxname}" new-session -s "${tmuxname}-base"
		else
			# Kill old detached sessions
			tmux -L "${tmuxname}" ls | \
				grep '^autoattach-[[:digit:]]*:' | \
				grep -v '(attached)$' | \
				awk -F':' '{print $1}' | \
				xargs -n1 tmux -L "${tmuxname}" kill-session -t
			# Attach to existing base session
			sessionid="$(date +%Y%m%d%H%M%S)"
			tmux -2 -L "${tmuxname}" new-session -d -t "${tmuxname}-base" -s "${tmuxname}-${sessionid}"
			exec tmux -2 -L "${tmuxname}" attach-session -t "${tmuxname}-${sessionid}"
		fi
	fi
fi
