#!/bin/zsh

# https://qiita.com/kinchiki/items/57e9391128d07819c321
# この記事のマネをしてインストールする

git submodule add -f https://github.com/sorin-ionescu/prezto.git .zprezto
git submodule update --init --recursive

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/dotfiles/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

ln -sf ~/dotfiles/.zprezto ~/.zprezto
ln -sf ~/dotfiles/prompt_qushot_setup ~/.zprezto/modules/prompt/functions/prompt_qushot_setup
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc

source ~/.zpreztorc
source ~/.zshrc

# rm -rf .zlogin .zlogout .zprofile .zpreztorc .zshenv .zshrc .zprezto
