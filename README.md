# dotfiles_ubuntu

## Homebrew 関連のメモ
### dump 時に種類で分割可能
* `brew bundle dump --formula --file formula.Brewfile`
* `brew bundle dump --cask --file cask.Brewfile`
* `brew bundle dump --vscode --file vscode.Brewfile`

## install.sh
### `set -euxo pipefail` の意味メモ
* `-e`: コマンドが失敗した場合、スクリプトを直ちに終了する。
* `-u`: 未定義の変数を使用した場合、エラーを発生させる。
* `-x`: 実行される各コマンドを表示する。
* `-o pipefail`: パイプライン内のどのコマンドが失敗しても、全体を失敗とみなす。

### シンボリックリンクの解除
`ln -sf "foo/file" "bar/file"` でシンボリックリンクを作成した場合、 `unlink "bar/file"` で解除する。
