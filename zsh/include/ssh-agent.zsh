###############
## tmux-friendly SSH agent
###############

if [ -z "${SSH_AUTH_SOCK}" ]; then
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
fi
