#!/usr/bin/bash
set -o nounset

###
# Configuration
###

# name|test|testparam
dependencies=(
	"zsh|command|zsh"
	"git|command|git"
	"vim|command|vim"
	"curl|command|curl"
)

# file|graphical?
linkfiles=(
	"$HOME/.gemrc:misc/gemrc|no"
	"$HOME/.gitconfig:misc/gitconfig|no"
	"$HOME/.zlogin:zsh/zlogin|no"
	"$HOME/.zlogout:zsh/zlogout|no"
	"$HOME/.zprofile:zsh/zprofile|no"
	"$HOME/.zshenv:zsh/zshenv|no"
	"$HOME/.zshrc:zsh/zshrc|no"
	"$HOME/.vimrc:vim/vimrc|no"
	"$HOME/.tmux.conf:tmux/tmux.conf|no"
	"$HOME/.xinitrc:x11/xinitrc|yes"
	"$HOME/.config/htop/htoprc:misc/htoprc|no"
	"$HOME/.tmux/plugins/tpm:tmux/tpm|no"
	"$HOME/.gtkrc-2.0:x11/gtkrc-2.0|yes"
	"$HOME/.config/gtk-3.0/settings.ini:x11/gtkrc-3.0|yes"
	"$HOME/.config/pacaur/config:misc/pacaur|no"
	"$HOME/.vim/autoload/plug.vim:vim/vim-plug/plug.vim|no"
	"$HOME/.gnupg/gpg.conf:gpg/gpg.conf|no"
	"$HOME/.gnupg/gpg-agent.conf:gpg/gpg-agent.conf|no"
	"$HOME/.gnupg/dirmngr.conf:gpg/dirmngr.conf|no"
	"$HOME/.curlrc:misc/curlrc|no"
)
# dir|graphical?
mkdirs=(
	"$HOME/.vim/autoload|no"
	"$HOME/.vim/backup|no"
	"$HOME/.vim/swap|no"
	"$HOME/.config/systemd/user"
	"$HOME/.tmux/plugins"
	"$HOME/.gnupg"
)

# unit|graphical?
units=(
	'ssh-agent.service|no'
	'dirmngr.socket|no'
)

###
# Variables
###
BASEDIR="$(readlink -f $(dirname $0))"

###
# Colors, taken from makepkg
###
if tput setaf 0 &>/dev/null; then
	ALL_OFF="$(tput sgr0)"
	BOLD="$(tput bold)"
	BLUE="${BOLD}$(tput setaf 4)"
	GREEN="${BOLD}$(tput setaf 2)"
	RED="${BOLD}$(tput setaf 1)"
else
	ALL_OFF="\e[0m"
	BOLD="\e[1m"
	BLUE="${BOLD}\e[34m"
	GREEN="${BOLD}\e[32m"
	RED="${BOLD}\e[31m"
fi
msg() {
	local mesg="${1}"
	shift
	printf "${GREEN}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}
msg2() {
	local mesg="${1}"
	shift
	printf "${BLUE}  ->${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}
error() {
	local mesg="${1}"
	shift
	printf "${RED}==> ERROR:${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

###
# Functions
###

checkDependencies() {
	local requiredMissing=0

	for dependency in "${dependencies[@]}"; do
		# Parse this dependency
		prettyname="`echo "${dependency}" | awk -F '|' '{ print $1 }'`"
		checktype="`echo "${dependency}" | awk -F '|' '{ print $2 }'`"
		checkarg="`echo "${dependency}" | awk -F '|' '{ print $3 }'`"
		# Print a nice message
		msgsuffix=''
		echo -ne "    [ .... ] Checking for ${prettyname}${ALL_OFF}"
		# Perform the actual check
		okay=0
		case "${checktype}" in
			'command')
				hash "${checkarg}" &>/dev/null
				okay="${?}"
				;;
			'file')
				test -f "${checkarg}"
				okay="${?}"
				;;
			'exec')
				${checkarg} &>/dev/null
				okay="${?}"
				;;
			*)
				okay=255
		esac
		# Process check result
		if [ "${okay}" -eq 0 ]; then
			echo -ne "\r    [ ${GREEN}okay${ALL_OFF} ]\v\r"
		else
			echo -ne "\r    [ ${RED}fail${ALL_OFF} ]\v\r"
			requiredMissing=1
		fi
	done
	# Output results
	if [ "${requiredMissing}" -eq 1 ]; then
		error "Could not find all required depdendencies."
		exit 1
	fi
}
createlocalconfig() {
	mkdir -pv "${BASEDIR}/local"
	touch "${BASEDIR}/local/zsh"
	touch "${BASEDIR}/local/vim"
}

creategitconfig() {
	if ! [ -f "${BASEDIR}/local/gitcustom" ]; then
		read -p "    Please enter your name for the git config: " name
		read -p "    Please enter your mail for the git config: " email
		echo -e "[user]\n\tname = ${name}\n\temail = ${email}\n" > "${BASEDIR}/local/gitcustom"
	else
		msg2 "git configuration already exists."
	fi
}

creategraphicalconfig() {
	if ! [ -f "${BASEDIR}/local/graphical" ] && ! [ -f "${BASEDIR}/local/nographical" ]; then
		read -p "Installing in a graphical environment? [yN] " -n 1 reply
		if [[ "${reply}" =~ ^[YyJj] ]]; then
			touch "${BASEDIR}/local/graphical"
		else
			touch "${BASEDIR}/local/nographical"
		fi
	fi
}

makedirs() {
	for mkdir in "${mkdirs[@]}"; do
		path="`echo "${mkdir}" | awk -F '|' '{print $1}'`"
		graphical="`echo "${mkdir}" | awk -F '|' '{print $2}'`"
		if [ "${graphical}" == 'yes' ]; then
			if [ -f "${BASEDIR}/local/graphical" ]; then
				mkdir -pv "${path}"
			fi
		else
			mkdir -pv "${path}"
		fi
	done
}

link() {
	for file in "${linkfiles[@]}"; do
		filename="`echo "${file}" | awk -F '|' '{print $1}'`"
		linkfrom="`basename "${filename}" | sed 's/^\.\(.*\)/\1/'`"
		# Allow files to be renamed on linking
		if [[ "${filename}" == *":"* ]]; then
			linkfrom="`echo "$filename" | awk -F ':' '{print $2}'`"
			filename="`echo "$filename" | awk -F ':' '{print $1}'`"
		fi
		# Ensure directory exists
		if [ "`echo "$file" | awk -F '|' '{print $2}'`" == 'yes' ]; then
			if [ -f "${BASEDIR}/local/graphical" ]; then
				mkdir -pv "`dirname "${filename}"`"
				ln -svTf "${BASEDIR}/${linkfrom}" "${filename}"
			fi
		else
			mkdir -pv "`dirname "${filename}"`"
			ln -svTf "${BASEDIR}/${linkfrom}" "${filename}"
		fi
	done
}

systemd() {
	# Link
	msg2 'Link'
	for file in ${BASEDIR}/systemd/*; do
		ln -svTf "${file}" "${HOME}/.config/systemd/user/$(basename "${file}")"
	done
	# Default target
	# `systemctl set-default` can not be used because graphical.target and headless.target are symlinks
	msg2 'Default'
	if [ -f "${BASEDIR}/local/graphical" ]; then
		ln -svTf 'graphical.target' "${HOME}/.config/systemd/user/default.target"
	else
		ln -svTf 'headless.target' "${HOME}/.config/systemd/user/default.target"
	fi
	# Reload
	msg2 'Reload'
	systemctl --user daemon-reload
	# Enable units
	msg2 'Enable'
	for line in "${units[@]}"; do
		unit="`echo "${line}" | awk -F '|' '{print $1}'`"
		graphical="`echo "${line}" | awk -F '|' '{print $2}'`"
		if [ "${graphical}" == 'yes' ]; then
			if [ -f "${BASEDIR}/local/graphical" ]; then
				systemctl --user enable "${unit}"
			fi
		else
			systemctl --user enable "${unit}"
		fi
	done
}

updatesw() {
	msg2 'vim'
	vim +PlugUpdate +qall
	vim +PlugClean! +qall
	msg2 'zsh'
	if [ ! -f "${BASEDIR}/bin/antibody" ]; then
		# TODO How to update??
		curl -sL https://github.com/getantibody/antibody/releases/download/v2.2.4/antibody_Linux_x86_64.tar.gz | tar xzvC "${BASEDIR}/bin" antibody
	fi
	# Install
	zsh -c "zshconf=\"${BASEDIR}/zsh\" source \"${BASEDIR}/zsh/include/antibody.zsh\""
	# Update
	ANTIBODY_HOME="${BASEDIR}/zsh/antibody/repos" "${BASEDIR}/bin/antibody" update
	msg2 'tmux'
	"${HOME}/.tmux/plugins/tpm/bin/install_plugins"
	"${HOME}/.tmux/plugins/tpm/bin/update_plugins" all
}

updaterepos() {
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule init
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule update --init --recursive
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule foreach git pull origin master
}

gitfilters() {
	sum="$(sha512sum "${BASEDIR}/.git/config")"
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" config filter.vars.smudge "${BASEDIR}/util/smudge-filter"
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" config filter.vars.clean "${BASEDIR}/util/clean-filter"
	if [ "${sum}" != "$(sha512sum "${BASEDIR}/.git/config")" ]; then
		git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" checkout .
	fi
}

msg "Configuring git filters..."
gitfilters
msg "Creating local configuration..."
createlocalconfig
msg "Asking for configuration..."
creategitconfig
creategraphicalconfig
msg "Checking requirements..."
checkDependencies
msg "Creating empty directories..."
makedirs
msg "Updating submodules..."
updaterepos
msg " Linking..."
link
msg "Configuring systemd..."
systemd
msg "Updating plugins..."
updatesw
