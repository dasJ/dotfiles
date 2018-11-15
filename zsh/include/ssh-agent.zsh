###############
## tmux-friendly SSH agent
###############

if [ -z "${SSH_AUTH_SOCK}" ]; then
	mkdir -p "${HOME}/.ssh"
	export SSH_AUTH_SOCK="/tmp/${USER}/.auth_socket"
fi

if ! [ -S "${SSH_AUTH_SOCK}" ]; then
	ssh-agent -a "${SSH_AUTH_SOCK}" > /dev/null
	echo "${?}" > "/tmp/${USER}/.auth_pid"
fi

if [ -z "${SSH_AGENT_PID}" -a -f "/tmp/${USER}/.auth_pid" ]; then
	export SSH_AGENT_PID="$(< "/tmp/${USER}/.auth_pid")"
fi
