#!/bin/bash

if [ "$SHELL" != "/bin/zsh" ]; then
	chsh -s /bin/zsh $USER
	echo "Set default shell to zsh. Restart terminal."
	exit 0
fi

echo "Copying dotfiles to ~/"
cp .bash* ~/
cp .gitconfig ~/
cp .zshrc ~/
cp .emacs ~/
# Install prezto
echo "Installing prezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
/bin/zsh -c 'setopt EXTENDED_GLOB'
/bin/zsh -c 'for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done'

cp prompt_riccardo_setup ~/.zprezto/modules/prompt/functions/
cp .zpreztorc ~/

# Install pip
if hash pip 2>/dev/null; then
    echo "pip already installed, exiting..."
    exit
fi
    
echo "Installing pip..."
sudo easy_install pip

echo "Done! Restart terminal"
