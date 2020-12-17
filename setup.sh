echo "Backing up old files...\n"

move() {
		FILENAME=$1

		echo "found $FILENAME"
		mv $FILENAME "$FILENAME.bck" && echo "moved $FILENAME to $FILENAME.bck"
		echo;
}

backup() {
	FILENAME=$1

	[ -e $FILENAME ] && move $FILENAME
	[ -h $FILENAME ] && move $FILENAME
}

symlinkhome() {
	FILENAME=$1

	ln -s ~/dotfiles/$FILENAME ~/$FILENAME
}

symlinkconfig() {
	FILENAME=$1

	ln -s ~/dotfiles/$FILENAME ~/.config/$FILENAME
}

backup dotfiles
backup .zshrc
backup .gitconfig
backup .config/nvim
backup .config/vimb
backup .emacs.d
backup .qutebrowser
backup .zprofile

echo "Cloning dotfiles repo...\n"
git clone https://github.com/kavin25/dotfiles.git dotfiles

echo "Symlynking files...\n"
symlinkhome .zshrc
symlinkhome .gitconfig
symlinkhome .emacs.d
symlinkhome .qutebrowser
symlinkhome .zprofile
symlinkconfig nvim
symlinkconfig vimb

echo "DONE!!!"
