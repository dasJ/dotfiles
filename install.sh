#/usr/bin/zsh

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


install_dotfiles () {

	ln -s $BASEDIR/prompt_janne_setup $BASEDIR/zprezto/modules/prompt/functions/prompt_janne_setup

	for toLink in gitconfig vimrc zprezto zlogin zlogout zpreztorc zprofile zshenv zshrc; do
		ln -s $BASEDIR/$toLink $HOME/.$toLink
	done
}

create_vim_dirs () {
	mkdir ~/.vim
	mkdir ~/.vim/backup
	mkdir ~/.vim/swap
}

clone_other_repos () {
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle.vim
}

init_stuff () {
	vim +PluginInstall +qall

init_submodules () {
	CURRENTDIR=`pwd`
	cd $BASEDIR
	git submodule init
	git submodule update
	cd $CURRENTDIR
}

install_dotfiles
init_submodules
create_vim_dirs
clone_other_repos
init_stuff

