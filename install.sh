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

GIT_CONFIG_LOCAL=~/.config/git/local
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

# zsh 関連のものをインストールする
# TODO: -> 普通に brew bundle でインストールしても良い気がした
# brew bundle --file=formula.Brewfile
# brew bundle --file=vscode.Brewfile
brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

# /etc/shells に zsh を追加
command -v zsh | sudo tee -a /etc/shells
# zsh をデフォルトシェルに変更
sudo chsh -s "$(command -v zsh)"

# TODO: Macの場合は defaults_write.sh を実行するように
# sh defaults_write.sh

# 再起動
# sudo shutdown -r now
