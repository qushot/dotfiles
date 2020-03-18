#!/bin/zsh

DOTFILES_DIR="$HOME/.ditfiles"

git clone https://github.com/qushot/dotfiles.git $DOTFILES_DIR
cd $DOTFILES_DIR

git submodule add -f https://github.com/sorin-ionescu/prezto.git .zprezto
git submodule update --init --recursive

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$DOTFILES_DIR}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

ln -sf $DOTFILES_DIR/.zprezto ~/.zprezto
ln -sf $DOTFILES_DIR/prompt_qushot_setup ~/.zprezto/modules/prompt/functions/prompt_qushot_setup
ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.zpreztorc ~/.zpreztorc

source ~/.zpreztorc
source ~/.zshrc

# rm -rf .zlogin .zlogout .zprofile .zpreztorc .zshenv .zshrc .zprezto
# rm -rf .git .gitmodules .zprezto
# curl -LSfs https://raw.githubusercontent.com/qushot/dotfiles/master/install.sh | bash
