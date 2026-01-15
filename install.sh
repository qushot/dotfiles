#!/bin/bash
set -euo pipefail

# Check for required commands
REQUIRED_CMDS=("curl" "git")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd is not installed. Please install $cmd and rerun the script."
        exit 1
    fi
done

DOTFILES_DIR="$HOME/.dotfiles"

git clone https://github.com/qushot/dotfiles.git "$DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Set up the ZDOTDIR environment variable
echo "Setting up ZDOTDIR..."
echo export ZDOTDIR=\"\$HOME\"/.config/zsh | sudo tee -a /etc/zshenv

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
ln -sfv ${DOTFILES_DIR}/config/* ${XDG_CONFIG_HOME}
# 動作確認のために ~/.config 配下のシンボリックリンクを削除するスクリプト
# for name in $(ls ${XDG_CONFIG_HOME}); do unlink ${XDG_CONFIG_HOME}/${name}; done

# Install Homebrew
echo "Installing Homebrew..."
NONINTERACTIVE=1 \
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  linux*)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt-get update -y && sudo apt-get install build-essential -y
    ;;
esac

brew bundle --global --quiet || true # エラーを無視
# brew bundle --file=formula.Brewfile
# brew bundle --file=vscode.Brewfile

# /etc/shells に zsh を追加
command -v zsh | sudo tee -a /etc/shells

# zsh をデフォルトシェルに変更
sudo chsh -s "$(command -v zsh)" "$USER"

# macOS の場合は defaults_write.sh を実行する
# WARN: 動作未確認
case "$OSTYPE" in
  darwin*)
    sh defaults_write.sh
    ;;
esac

# 再起動
case "$OSTYPE" in
  darwin*)
    echo "Please restart your Mac to apply all changes."
    ;;
  linux*)
    echo "Rebooting the system..."
    sudo shutdown -r now
    ;;
esac

