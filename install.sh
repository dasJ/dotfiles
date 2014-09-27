#/usr/bin/zsh

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

install_dotfiles () {
	ln -s $BASEDIR/gitconfig $HOME/.gitconfig
	ln -s $BASEDIR/vimrc $HOME/.vimrc
	ln -s $BASEDIR/prezto $HOME/.zprezto

	# Prezto
	ln -s $BASEDIR/zlogin $HOME/.zlogin
	ln -s $BASEDIR/zlogout $HOME/.zlogout
	ln -s $BASEDIR/zpreztorc $HOME/.zpreztorc
	ln -s $BASEDIR/zprofile $HOME/.zprofile
	ln -s $BASEDIR/zshenv $HOME/.zshenv
	ln -s $BASEDIR/zshrc $HOME/.zshrc
}

init_submodules () {
	CURRENTDIR=`pwd`
	cd $BASEDIR
	git submodule init
	git submodule update
	cd $CURRENTDIR
}

install_dotfiles
init_submodules

