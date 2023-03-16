###############
## tmux-friendly SSH agent
###############

if [ -z "${SSH_AUTH_SOCK}" ]; then
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/.ssh_socket"
fi

if ! [ -S "${SSH_AUTH_SOCK}" ]; then
	if [[ -n "${DISPLAY}" ]] && hash dunstify 2>/dev/null; then
		export SSH_ASKPASS="@DOTFILES@/scripts/fido2-askpass"
	fi
	ssh-agent -a "${SSH_AUTH_SOCK}" > /dev/null
fi
