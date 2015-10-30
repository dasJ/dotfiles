#/usr/bin/zsh

###
# Configuration
###
REQUIRED_COMMANDS='zsh git'
OPTIONAL_COMMANDS='vim tmux fasd yaourt htop xsel curl urxvt'

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
	"$HOME/.yaourtrc|yaourt|no"
	"$HOME/.Xresources|urxvt|yes"
	"$HOME/.xsession|zsh|yes"
	"$HOME/.config/htop/htoprc|htop|no"
	"$HOME/.vim/bundle:vundle|vim|no"
	"$HOME/.tmux/plugins:tpm|tmux|no"
	"$HOME/.gtkrc-2.0|zsh|yes"
)
mkdirs=(
	"$HOME/.vim|vim|no"
	"$HOME/.vim/backup|vim|no"
	"$HOME/.vim/swap|vim|no"
	"$HOME/.tmux|tmux|no"
	"$HOME/.config/htop|htop|no"
)

###
# Variables
###
BASEDIR=$(readlink -f $(dirname $0))

###
# Functions
###

checkcommands () {
	local everythingFound=true
	local everythingRequired=$1
	shift
	
	for cmd in $@; do
		if $everythingRequired; then
			echo -ne ":: [ .... ] Checking for $cmd"
		else
			echo -ne ":: [ .... ] Checking for $cmd (optional)"
		fi
		if hash $cmd 2>/dev/null; then
			echo -ne "\r:: [ \e[00;32mokay\e[00m ]\v\r"
		else
			echo -ne "\r:: [ \e[00;31mfail\e[00m ]\v\r"
			everythingFound=false
		fi
	done

	if ! $everythingFound; then
		if $everythingRequired; then
			echo "Could not find all dependencies."
			exit 1
		fi
		while true; do
			read -p "Not all optional commands were found. Continue anyway? [yn] " yn
			case $yn in
				[Yy]* ) break ;;
				[Nn]* ) exit 1 ;;
			esac
		done
	fi
}

creategitconfig () {
	if ! [ -f $HOME/.dotfiles/gitcustom ]; then
		read -p "Please enter your name for the Git config: " name
		read -p "Please enter your mail for the Git config: " email
		echo -e "[user]\n\tname = ${name}\n\temail = ${email}\n" > $HOME/.dotfiles/gitcustom
	else
		echo "Git configuration already exists."
	fi
}

link () {
	for file in "${cmdfiles[@]}"; do
		if hash `echo "$file" | awk -F "|" '{print $2}'` 2>/dev/null; then
			filename=`echo "$file" | awk -F "|" '{print $1}'`
			linkfrom=`basename "$filename" | sed 's/^\.\(.*\)/\1/'`
			if [[ "$filename" == *":"* ]]; then
				linkfrom=`echo "$filename" | awk -F ":" '{print $2}'`
				filename=`echo "$filename" | awk -F ":" '{print $1}'`
			fi
			if [ `echo "$file" | awk -F "|" '{print $3}'` == "yes" ]; then
				if [ -f $BASEDIR/graphical ]; then
					ln -svT $BASEDIR/$linkfrom $filename
				fi
			else
				ln -svT $BASEDIR/$linkfrom $filename
			fi
		fi
	done
	ln -svT $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup
}

createemptydirs () {
	for mkdir in "${mkdirs[@]}"; do
		if hash `echo "$mkdir" | awk -F "|" '{print $2}'` 2>/dev/null; then
			if [ `echo "$mkdir" | awk -F "|" '{print $3}'` == "yes" ]; then
				if [ -f $BASEDIR/graphical ]; then
					mkdir -pv `echo "$mkdir" | awk -F "|" '{print $1}'`
				fi
			else
				mkdir -pv `echo "$mkdir" | awk -F "|" '{print $1}'`
			fi
		fi
	done
}

updaterepos () {
	git --git-dir=$BASEDIR/.git --work-tree=$BASEDIR submodule update --init --recursive
}

init () {
	if hash vim 2>/dev/null; then
		echo | vim +PluginInstall +qall
	fi
}

main () {
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
	checkcommands true $REQUIRED_COMMANDS
	checkcommands false $OPTIONAL_COMMANDS
	echo ":: Asking for configuration..."
	creategitconfig
	echo ":: Create empty directories..."
	createemptydirs
	echo ":: Updating repositories..."
	updaterepos
	echo ":: Linking..."
	link
	echo ":: Running post-installation stuff..."
	init
	echo ":: Think about chshing to zsh"
}

main

