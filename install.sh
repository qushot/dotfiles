#!/bin/bash
set -euxo pipefail

# TODO: homebrew のインストール
if ! command -v brew &>/dev/null; then
    echo "brew がインストールされていません。"

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ファイル・ディレクトリのリンクを作成
files_to_link=(
    ".zshrc"
    ".config/git"
)
for file in "${files_to_link[@]}"; do
    ln -sf "$(pwd)/$file" "$HOME/$file"
done

# zsh 関連のものをインストールする
# TODO: -> 普通に brew bundle でインストールしても良い気がした
brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

# /etc/shells に zsh を追加
command -v zsh | sudo tee -a /etc/shells
# zsh をデフォルトシェルに変更
sudo chsh -s "$(command -v zsh)"

# 再起動
# sudo shutdown -r now
