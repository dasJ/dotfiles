###############
## tmux-friendly SSH agent
###############

if [ -z "${SSH_AUTH_SOCK}" ]; then
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/.ssh_socket"
fi

if ! [ -S "${SSH_AUTH_SOCK}" ]; then
	ssh-agent -a "${SSH_AUTH_SOCK}" > /dev/null
fi
