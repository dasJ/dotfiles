#/usr/bin/zsh

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

set -e

install_dotfiles () {
	ln -s $BASEDIR/gitconfig $HOME/.gitconfig || true
	ln -s $BASEDIR/vimrc $HOME/.vimrc || true
	ln -s $BASEDIR/zprezto $HOME/.zprezto || true

	# Prezto
	ln -s $BASEDIR/zlogin $HOME/.zlogin || true
	ln -s $BASEDIR/zlogout $HOME/.zlogout || true
	ln -s $BASEDIR/zpreztorc $HOME/.zpreztorc || true
	ln -s $BASEDIR/zprofile $HOME/.zprofile || true
	ln -s $BASEDIR/zshenv $HOME/.zshenv || true
	ln -s $BASEDIR/zshrc $HOME/.zshrc || true

	ln -s $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup || true
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

