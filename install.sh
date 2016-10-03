#/usr/bin/zsh
set -o nounset

###
# Configuration
###

# name|required?|graphical?|test|testparam
dependencies=(
	# Requirements
	"zsh|yes|no|command|zsh"
	"git|yes|no|command|git"
	# Optional stuff
	"vim|no|no|command|vim"
	"tmux|no|no|command|tmux"
	"pacaur|no|no|command|pacaur"
	"ctags for vim|no|no|command|ctags"
	"htop|no|no|command|htop"
	"fpp|no|no|command|fpp"
	"bc|no|no|command|bc"
	"tar|no|no|command|tar"
	"bzip2|no|no|command|bunzip2"
	"unrar|no|no|command|unrar"
	"gzip|no|no|command|gunzip"
	"unzip|no|no|command|unzip"
	"p7zip|no|no|command|7z"
	"xz|no|no|command|unlzma"
	"cabextract|no|no|command|cabextract"
	"binutils|no|no|command|objdump"
	"sl|no|no|file|/usr/bin/sl"
	# Graphical stuff
	"st|no|yes|command|st"
	"Anonymous Pro font|no|yes|exec|[ ! `fc-list "Anonymous Pro" | wc -l` -eq 0 ]"
	"numix theme|no|yes|file|/usr/share/themes/Numix/index.theme"
	# Stuff I like
	"curl|no|no|command|curl"
)


# file|graphical?
linkfiles=(
	"$HOME/.gemrc|no"
	"$HOME/.gitconfig|no"
	"$HOME/.zprezto|no"
	"$HOME/.zlogin|no"
	"$HOME/.zlogout|no"
	"$HOME/.zpreztorc|no"
	"$HOME/.zprofile|no"
	"$HOME/.zshenv|no"
	"$HOME/.zshrc|no"
	"$HOME/.vimrc|no"
	"$HOME/.tmux.conf|no"
	"$HOME/.Xresources|yes"
	"$HOME/.xsession|yes"
	"$HOME/.config/htop/htoprc|no"
	"$HOME/.vim/bundle:vundle|no"
	"$HOME/.tmux/plugins:tpm|no"
	"$HOME/.gtkrc-2.0|yes"
	"$HOME/.config/gtk-3.0/settings.ini:gtkrc-3.0|yes"
	"$HOME/.config/pacaur/config:pacaur|no"
)
# dir|graphical?
mkdirs=(
	"$HOME/.vim/backup|no"
	"$HOME/.vim/swap|no"
)

###
# Variables
###
BASEDIR="$(readlink -f $(dirname $0))"

###
# Functions
###

checkDependencies() {
	local optionalMissing=0
	local requiredMissing=0

	for dependency in "${dependencies[@]}"; do
		# Parse this dependency
		prettyname="`echo "${dependency}" | awk -F '|' '{ print $1 }'`"
		isoptional="`echo "${dependency}" | awk -F '|' '{ print $2 }'`"
		isgraphical="`echo "${dependency}" | awk -F '|' '{ print $3 }'`"
		checktype="`echo "${dependency}" | awk -F '|' '{ print $4 }'`"
		checkarg="`echo "${dependency}" | awk -F '|' '{ print $5 }'`"
		# Ignore if not graphical
		if [ -f "${BASEDIR}/nographical" ]; then
			if [ "${isgraphical}" == 'yes' ]; then
				continue
			fi
		fi
		# Print a nice message
		msgsuffix=''
		test "${isgraphical}" == 'yes' && msgsuffix="${msgsuffix} (graphical)"
		test "${isoptional}" != 'yes' && msgsuffix="${msgsuffix} (optional)"
		echo -ne ":: [ .... ] Checking for ${prettyname} ${msgsuffix}"
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
			if [ "${isoptional}" == 'yes' ]; then
				requiredMissing=1
			else
				optionalMissing=1
			fi
		fi
	done
	# Output results
	if [ "${requiredMissing}" -eq 1 ]; then
		echo "Could not find all required depdendencies."
		if [ "${optionalMissing}" -eq 1 ]; then
			echo "Some optional dependencies are missing as well."
		fi
		exit 1
	fi
	if [ "${optionalMissing}" -eq 1 ]; then
		while true; do
			read -p "Not all optional dependencies were found. Continue anyway? [yn] " yn
			case "${yn}" in
				[Yy]* ) break ;;
				[Nn]* ) exit 1 ;;
			esac
		done
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
				ln -svT "${BASEDIR}/${linkfrom}" "${filename}"
			fi
		else
			mkdir -pv "`dirname "${filename}"`"
			ln -svT "${BASEDIR}/${linkfrom}" "${filename}"
		fi
	done
}

updaterepos() {
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

