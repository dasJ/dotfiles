#/usr/bin/zsh

###
# Configuration
###
REQUIRED_COMMANDS='zsh git'
OPTIONAL_COMMANDS='vim tmux fasd yaourt htop xsel curl'
DOTFILES_TO_LINK='gitconfig zprezto zlogin zlogout zpreztorc zprofile zshenv zshrc Xresources gemrc xsession'
cmdfiles=(
	"vimrc|vim"
	"tmux.conf|tmux"
	"yaourtrc|yaourt"
)
mkdirs=(
	"~/.vim|vim"
	"~/.vim/backup|vim"
	"~/.vim/swap|vim"
	"~/.tmux/plugins|tmux"
	"~/.config/htop|htop"
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
	for file in "${cmdfiles[@]}"; do
		if hash `echo "$mkdir" | awk -F "|" '{print $2}'` 2>/dev/null; then
			filename=`echo "$mkdir" | awk -F "|" '{print $1}'`
			ln -sv $BASEDIR/$filename ~/.$filename
		fi
	done
}

linkotherstuff () {
	ln -sv $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup
	if hash htop 2>/dev/null; then
		ln -sv $BASEDIR/htoprc ~/.config/htop/htoprc
	fi
}

createemptydirs () {
	for mkdir in "${mkdirs[@]}"; do
		if hash `echo "$mkdir" | awk -F "|" '{print $2}'` 2>/dev/null; then
			mkdir -pv `echo "$mkdir" | awk -F "|" '{print $1}'`
		fi
	done
}

cloneotherrepos () {
	if hash vim 2>/dev/null; then
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle.vim
	fi
	if hash tmux 2>/dev/null; then
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi
	git --git-dir=$BASEDIR/.git --work-tree=$BASEDIR submodule update --init --recursive
}

init () {
	if hash vim 2>/dev/null; then
		echo | vim +PluginInstall +qall
	fi
}

main () {
	if ! [ -f ~/.dotfiles/graphical ] && ! [ -f ~/.dotfiles/nographical ]; then
		echo "build"
	fi
	echo ":: Checking requirements..."
	checkcommands true $REQUIRED_COMMANDS
	checkcommands false $OPTIONAL_COMMANDS
	echo ":: Asking for configuration..."
	creategitconfig
	echo ":: Create empty directories..."
	createemptydirs
	echo ":: Cloning other repositories..."
	cloneotherrepos
	echo ":: Linking to home..."
	linktohome
	echo ":: Create more links..."
	linkotherstuff
	echo ":: Running post-installation stuff..."
	init
	echo ":: Think about chshing to zsh"
}

main

