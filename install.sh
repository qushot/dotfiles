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

# XDG Base Directory specification 関連のディレクトリ作成
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

mkdir -p \
    "$XDG_CONFIG_HOME" \
    "$XDG_CACHE_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME"

# .config 配下のディレクトリをリンク
# TODO: dotfiles のディレクトリに移動する必要がありそう
ln -sfv $(pwd)/config/* ${XDG_CONFIG_HOME}
# 動作確認のために ~/.config 配下のシンボリックリンクを削除するスクリプト
# for name in $(ls ${XDG_CONFIG_HOME}); do unlink ${XDG_CONFIG_HOME}/${name}; done

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
