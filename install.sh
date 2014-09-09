#/usr/bin/zsh

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

install_dotfiles () {
	ln -s $BASEDIR/gitconfig $HOME/.gitconfig
	ln -s $BASEDIR/vimrc $HOME/.vimrc
	ln -s $BASEDIR/prezto $HOME/.zprezto

	# Prezto
	ln -s $BASEDIR/prezto/runcoms/zlogin $HOME/.zlogin
	ln -s $BASEDIR/prezto/runcoms/zlogout $HOME/.zlogout
	ln -s $BASEDIR/prezto/runcoms/zpreztorc $HOME/.zpreztorc
	ln -s $BASEDIR/prezto/runcoms/zprofile $HOME/.zprofile
	ln -s $BASEDIR/prezto/runcoms/zshenv $HOME/.zshenv
	ln -s $BASEDIR/prezto/runcoms/zshrc $HOME/.zshrc
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

