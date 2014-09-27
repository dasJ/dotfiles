#/usr/bin/zsh

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


install_dotfiles () {

	ln -s $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup

	for toLink in gitconfig vimrc zprezto zlogin zlogout zpreztorc zprofile zshenv zshrc; do
		ln -s $BASEDIR/$toLink $HOME/.$toLink
	done
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

