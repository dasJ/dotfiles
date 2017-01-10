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
)


# file|graphical?
linkfiles=(
	"$HOME/.gemrc|no"
	"$HOME/.gitconfig|no"
	"$HOME/.zlogin:zsh/zlogin|no"
	"$HOME/.zlogout:zsh/zlogout|no"
	"$HOME/.zprofile:zsh/zprofile|no"
	"$HOME/.zshenv:zsh/zshenv|no"
	"$HOME/.zshrc:zsh/zshrc|no"
	"$HOME/.vimrc:vim/vimrc|no"
	"$HOME/.tmux.conf|no"
	"$HOME/.xinitrc:x11/xinitrc|yes"
	"$HOME/.config/htop/htoprc|no"
	"$HOME/.tmux/plugins:tpm|no"
	"$HOME/.gtkrc-2.0:x11/gtkrc-2.0|yes"
	"$HOME/.config/gtk-3.0/settings.ini:x11/gtkrc-3.0|yes"
	"$HOME/.config/pacaur/config:pacaur|no"
	"$HOME/.vim/autoload/plug.vim:vim/vim-plug/plug.vim|no"
)
# dir|graphical?
mkdirs=(
	"$HOME/.vim/autoload|no"
	"$HOME/.vim/backup|no"
	"$HOME/.vim/swap|no"
	"$HOME/.config/systemd/user"
)

###
# Variables
###
BASEDIR="$(readlink -f $(dirname $0))"

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
		echo -ne ":: [ .... ] Checking for ${prettyname}"
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
			echo -ne "\r:: [ \e[00;32mokay\e[00m ]\v\r"
		else
			echo -ne "\r:: [ \e[00;31mfail\e[00m ]\v\r"
			requiredMissing=1
		fi
	done
	# Output results
	if [ "${requiredMissing}" -eq 1 ]; then
		echo "Could not find all required depdendencies."
		exit 1
	fi
}

creategitconfig() {
	if ! [ -f "${BASEDIR}/gitcustom" ]; then
		read -p "Please enter your name for the git config: " name
		read -p "Please enter your mail for the git config: " email
		echo -e "[user]\n\tname = ${name}\n\temail = ${email}\n" > "${BASEDIR}/gitcustom"
	else
		echo ":: git configuration already exists."
	fi
}

creategraphicalconfig() {
	if ! [ -f "${BASEDIR}/graphical" ] && ! [ -f "${BASEDIR}/nographical" ]; then
		read -p "Installing in a graphical environment? [yN] " -n 1 reply
		if [[ "${reply}" =~ ^[YyJj] ]]; then
			touch "${BASEDIR}/graphical"
		else
			touch "${BASEDIR}/nographical"
		fi
	fi
}

makedirs() {
	for mkdir in "${mkdirs[@]}"; do
		path="`echo "${mkdir}" | awk -F '|' '{print $1}'`"
		graphical="`echo "${mkdir}" | awk -F '|' '{print $2}'`"
		if [ "${graphical}" == 'yes' ]; then
			if [ -f "${BASEDIR}/graphical" ]; then
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
			if [ -f "${BASEDIR}/graphical" ]; then
				mkdir -pv "`dirname "${filename}"`"
				ln -svTf "${BASEDIR}/${linkfrom}" "${filename}"
			fi
		else
			mkdir -pv "`dirname "${filename}"`"
			ln -svTf "${BASEDIR}/${linkfrom}" "${filename}"
		fi
	done
	# systemd user units
	for file in ${BASEDIR}/systemd/*; do
		ln -svTf "${file}" "${HOME}/.config/systemd/user/$(basename "${file}")"
	done
	if [ -f "${BASEDIR}/graphical" ]; then
		ln -svTf 'graphical.target' "${HOME}/.config/systemd/user/default.target"
	else
		ln -svTf 'headless.target' "${HOME}/.config/systemd/user/default.target"
	fi
	systemctl --user daemon-reload
}

updatesw() {
	vim +PlugUpdate +qall
	vim +PlugClean! +qall
	zsh -c "zshconf=${BASEDIR}/zsh; source ${BASEDIR}/zsh/include/antigen.zsh && antigen update"
}

updaterepos() {
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule init
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule update --init --recursive
	git "--git-dir=${BASEDIR}/.git" "--work-tree=${BASEDIR}" submodule foreach git pull origin master
}

echo ":: Asking for configuration..."
creategitconfig
creategraphicalconfig
echo ":: Checking requirements..."
checkDependencies
echo ":: Creating empty directories..."
makedirs
echo ":: Updating submodules..."
updaterepos
echo ":: Linking..."
link
echo ":: Updating plugins..."
updatesw
