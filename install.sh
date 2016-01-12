#/usr/bin/zsh

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
	# Graphical stuff
	"st|no|yes|command|st"
	"Anonymous Pro font|no|yes|exec|[ ! `fc-list "Anonymous Pro" | wc -l` -eq 0 ]"
	"numix theme|no|yes|file|/usr/share/themes/Numix/index.theme"
	# Stuff I like
	"curl|no|no|command|curl"
)


# file|requirement|graphical?
cmdfiles=(
	"$HOME/.gemrc|zsh|no"
	"$HOME/.gitconfig|git|no"
	"$HOME/.zprezto|zsh|no"
	"$HOME/.zlogin|zsh|no"
	"$HOME/.zlogout|zsh|no"
	"$HOME/.zpreztorc|zsh|no"
	"$HOME/.zprofile|zsh|no"
	"$HOME/.zshenv|zsh|no"
	"$HOME/.zshrc|zsh|no"
	"$HOME/.vimrc|vim|no"
	"$HOME/.tmux.conf|tmux|no"
	"$HOME/.Xresources|urxvt|yes"
	"$HOME/.xsession|zsh|yes"
	"$HOME/.config/htop/htoprc|htop|no"
	"$HOME/.vim/bundle:vundle|vim|no"
	"$HOME/.tmux/plugins:tpm|tmux|no"
	"$HOME/.gtkrc-2.0|zsh|yes"
	"$HOME/.config/gtk-3.0/settings.ini:gtkrc-3.0|zsh|yes"
	"$HOME/.config/pacaur/config:pacaur|pacaur|no"
)
# dir|graphical?
mkdirs=(
	"$HOME/.vim/backup|no"
	"$HOME/.vim/swap|no"
	"$HOME/.tmux|no"
	"$HOME/.config/htop|no"
	"$HOME/.config/gtk-3.0|yes"
	"$HOME/.config/pacaur|yes"
)

###
# Variables
###
BASEDIR=$(readlink -f $(dirname $0))

###
# Functions
###

checkDependencies() {
	local optionalMissing=0
	local requiredMissing=0

	for dependency in "${dependencies[@]}"; do
		if [ -f $BASEDIR/nographical ]; then
			if [ `echo $dependency | awk -F '|' '{ print $3 }'` == "yes" ]; then
				continue
			fi
		fi
		prettyname=`echo $dependency | awk -F '|' '{ print $1 }'`
		test `echo $dependency | awk -F '|' '{ print $2 }'` == "yes"
		optional=$?
		if [ $optional -eq 0 ]; then
			echo -ne ":: [ .... ] Checking for $prettyname"
		else
			echo -ne ":: [ .... ] Checking for $prettyname (optional)"
		fi
		# Perform the actual check
		okay=0
		arg=`echo $dependency | awk -F '|' '{ print $5 }'`
		if [ `echo $dependency | awk -F '|' '{ print $4 }'` == "command" ]; then
			hash $arg 2>/dev/null
			okay=$?
		fi
		if [ `echo $dependency | awk -F '|' '{ print $4 }'` == "file" ]; then
			test -f "$arg"
			okay=$?
		fi
		if [ `echo $dependency | awk -F '|' '{ print $4 }'` == "exec" ]; then
			$arg &> /dev/null
			okay=$?
		fi
		# Process check result
		if [ $okay -eq 0 ]; then
			echo -ne "\r:: [ \e[00;32mokay\e[00m ]\v\r"
		else
			echo -ne "\r:: [ \e[00;31mfail\e[00m ]\v\r"
			if [ $optional -eq 0 ]; then
				requiredMissing=1
			else
				optionalMissing=1
			fi
		fi
	done
	# Output stuff
	if [ $requiredMissing -eq 1 ]; then
		echo "Could not find all required depdendencies."
		if [ $optionalMissing -eq 1 ]; then
			echo "Some optional dependencies are missing as well."
		fi
		exit 1
	fi
	if [ $optionalMissing -eq 1 ]; then
		while true; do
			read -p "Not all optional dependencies were found. Continue anyway? [yn] " yn
			case $yn in
				[Yy]* ) break ;;
				[Nn]* ) exit 1 ;;
			esac
		done
	fi
}

creategitconfig() {
	if ! [ -f $BASEDIR/gitcustom ]; then
		read -p "Please enter your name for the git config: " name
		read -p "Please enter your mail for the git config: " email
		echo -e "[user]\n\tname = ${name}\n\temail = ${email}\n" > $HOME/.dotfiles/gitcustom
	else
		echo ":: git configuration already exists."
	fi
}

makedirs() {
	for mkdir in "${mkdirs[@]}"; do
		if [ "`echo "$mkdir" | awk -F "|" '{print $2}'`" == "yes" ]; then
			if [ -f $BASEDIR/graphical ]; then
				mkdir -pv `echo "$mkdir" | awk -F "|" '{print $1}'`
			fi
		else
			mkdir -pv `echo "$mkdir" | awk -F "|" '{print $1}'`
		fi
	done
}

link() {
	for file in "${cmdfiles[@]}"; do
		if hash `echo "$file" | awk -F "|" '{print $2}'` 2>/dev/null; then
			filename=`echo "$file" | awk -F "|" '{print $1}'`
			linkfrom=`basename "$filename" | sed 's/^\.\(.*\)/\1/'`
			if [[ "$filename" == *":"* ]]; then
				linkfrom=`echo "$filename" | awk -F ":" '{print $2}'`
				filename=`echo "$filename" | awk -F ":" '{print $1}'`
			fi
			if [ "`echo "$file" | awk -F "|" '{print $3}'`" == "yes" ]; then
				if [ -f $BASEDIR/graphical ]; then
					ln -svT $BASEDIR/$linkfrom $filename
				fi
			else
				ln -svT $BASEDIR/$linkfrom $filename
			fi
		fi
	done
}

updaterepos() {
	git --git-dir=$BASEDIR/.git --work-tree=$BASEDIR submodule update --init --recursive
	git --git-dir=$BASEDIR/.git --work-tree=$BASEDIR submodule foreach git pull origin master
}

# Graphical question
if ! [ -f $BASEDIR/graphical ] && ! [ -f $BASEDIR/nographical ]; then
	read -p "Installing in a graphical environment? [yN] " -n 1 -r
	echo
if [[ "$REPLY" =~ ^[Yy] ]]; then
		touch $BASEDIR/graphical
	else
		touch $BASEDIR/nographical
	fi
fi
echo ":: Checking requirements..."
checkDependencies
echo ":: Asking for configuration..."
creategitconfig
echo ":: Creating empty directories..."
makedirs
echo ":: Updating submodules..."
updaterepos
echo ":: Linking..."
link

