#!/bin/zsh

DOTFILES_DIR="$HOME/.dotfiles"

git clone https://github.com/qushot/dotfiles.git $DOTFILES_DIR
cd $DOTFILES_DIR

git submodule add -f https://github.com/sorin-ionescu/prezto.git .zprezto
git submodule update --init --recursive

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$DOTFILES_DIR}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

ln -sf $DOTFILES_DIR/.zprezto ~/.zprezto
ln -sf $DOTFILES_DIR/.vimrc ~/.vimrc
ln -sf $DOTFILES_DIR/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/.zpreztorc ~/.zpreztorc

# git
if [ ! -e ~/.config/git ]; then
  mkdir -p ~/.config/git
fi
ln -sf $DOTFILES_DIR/git/config ~/.config/git/config
ln -sf $DOTFILES_DIR/git/ignore ~/.config/git/ignore
# Create .gitconfig.local
GIT_CONFIG_LOCAL=~/.config/git/config.local
if [ ! -e $GIT_CONFIG_LOCAL ]; then
  echo -n "git config user.email?> "
  read GIT_AUTHOR_EMAIL

  echo -n "git config user.name?> "
  read GIT_AUTHOR_NAME

  cat << EOF > $GIT_CONFIG_LOCAL
[user]
    name = $GIT_AUTHOR_NAME
    email = $GIT_AUTHOR_EMAIL
EOF
fi

source ~/.zpreztorc
source ~/.zshrc

# rm -rf .zlogin .zlogout .zprofile .zpreztorc .zshenv .zshrc .zprezto
# rm -rf .git .gitmodules .zprezto
# curl -LSfs https://raw.githubusercontent.com/qushot/dotfiles/master/install.sh | zsh
