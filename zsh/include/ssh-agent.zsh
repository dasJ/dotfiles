###############
## tmux-friendly SSH agent
###############

if [ -z "${SSH_AGENT_PID}" ]; then
	export SSH_AGENT_PID="$(cat "${HOME}/.ssh/.auth_pid")"
fi

if [ -z "${SSH_AUTH_SOCK}" ]; then
	export SSH_AUTH_SOCK="${HOME}/.ssh/.auth_socket"
fi
