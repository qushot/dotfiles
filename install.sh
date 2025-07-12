#!/bin/bash
set -euxo pipefail

echo "今は使えません！！"
exit 1

# Set up the ZDOTDIR environment variable
echo "Setting up ZDOTDIR..."
echo export ZDOTDIR=\"\$HOME\"/.config/zsh | sudo tee -a /etc/zshenv

# Install Homebrew
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# TODO: XDG Base Directory specification 関連のディレクトリ作成

# ファイル・ディレクトリのリンクを作成
# TODO: .config 配下のファイルを増やしたので要変更
files_to_link=(
    ".zshrc"
    ".config/git"
)
for file in "${files_to_link[@]}"; do
    ln -sf "$(pwd)/$file" "$HOME/$file"
done

# 不要
# GIT_CONFIG_LOCAL=~/.config/git/local
# if [ ! -e $GIT_CONFIG_LOCAL ]; then
#   echo -n "git config user.email?> "
#   read GIT_AUTHOR_EMAIL

#   echo -n "git config user.name?> "
#   read GIT_AUTHOR_NAME

#   cat << EOF > $GIT_CONFIG_LOCAL
# [user]
#     name = $GIT_AUTHOR_NAME
#     email = $GIT_AUTHOR_EMAIL
# EOF
# fi

# zsh 関連のものをインストールする
# TODO: -> 普通に brew bundle でインストールしても良い気がした
brew bundle --global --file=.Brewfile
# brew bundle --file=formula.Brewfile
# brew bundle --file=vscode.Brewfile

# /etc/shells に zsh を追加
command -v zsh | sudo tee -a /etc/shells

# zsh をデフォルトシェルに変更
# sudo chsh -s "$(command -v zsh)" # たぶん sudo しなくても良い
chsh -s "$(command -v zsh)"

# macOS の場合は defaults_write.sh を実行する
# WARN: 動作未確認
case "$OSTYPE" in
  darwin*)
    sh defaults_write.sh
    ;;
esac

# 再起動
# sudo shutdown -r now
