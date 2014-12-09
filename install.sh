#/usr/bin/zsh

###
# Configuration
###
REQUIRED_COMMANDS='zsh git curl'
OPTIONAL_COMMANDS='vim tmux'
DOTFILES_TO_LINK='gitconfig vimrc zprezto zlogin zlogout zpreztorc zprofile zshenv zshrc tmux.conf'

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
		echo -ne ":: [ .... ] Checking for $cmd"
		if hash $cmd 2>/dev/null; then
			echo -ne "\r:: [ \e[00;32mokay\e[00m ]\v\r"
		else
			echo -ne "\r:: [ \e[00;31mfail\e[00m ]\v\r"
			everythingFound=false
		fi
	done

	if ! $everythingFound; then
		if [ $everythingRequired -eq 1 ]; then
			echo "Could not find all dependencies."
			exit 1
		fi
		while true; do
			read -p "Not all optional commands were found. Continue anyway? [yn] " yn
			case $yn in
				[Yy]* ) ;;
				[Nn]* ) exit 1 ;;
			esac
		done
	fi
}

creategitconfig () {
	if ! [ -f ~/.dotfiles/gitcustom ]; then
		read -p "Please enter your name for the Git config: " name
		read -p "Please enter your mail for the Git config: " email
		echo -e "[user]\n\tname = ${name}\n\temail = ${email}\n" > ~/.dotfiles/gitcustom
	else
		echo "Git configuration already exists."
	fi
}

linktohome () {
	for toLink in $DOTFILES_TO_LINK; do
		ln -sv $BASEDIR/$toLink ~/.$toLink
	done
}

linkotherstuff () {
	ln -sv $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup
}

createemptydirs () {
	mkdir -vp ~/.vim
	mkdir -vp ~/.vim/backup
	mkdir -vp ~/.vim/swap
}

cloneotherrepos () {
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle.vim
}

init () {
	vim +PluginInstall +qall
}

main () {
	echo ":: Checking requirements..."
	checkcommands 1 $REQUIRED_COMMANDS
	checkcommands 0 $OPTIONAL_COMMANDS
	echo ":: Asking for configuration..."
	creategitconfig
	echo ":: Create empty directories..."
	createemptydirs
	echo ":: Linking to home..."
	linktohome
	echo ":: Create more links..."
	linkotherstuff
	echo ":: Cloning other repositories..."
	cloneotherrepos
	echo ":: Running post-installation stuff..."
	init
	echo ":: Think about chshing to zsh"
}

main

