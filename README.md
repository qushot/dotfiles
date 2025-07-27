# dotfiles_ubuntu

## GitHub Actions での自動テスト
* [GitHub Actions で dotfiles を自動テスト](https://qiita.com/rtakasuke/items/85133e396ba766458c20)

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
`ln -sf "src/file" "dest/file"` でシンボリックリンクを作成した場合、 `unlink "dest/file"` で解除する。

## 動作確認用 Ubuntu コンテナ
```sh
# 以下では sudo が使えないため、完全な動作確認はできない。
$ docker run -it --user ubuntu --volume $PWD:/home/ubuntu/$(basename "$PWD"):ro --workdir /home/ubuntu/$(basename "$PWD") --rm ubuntu /bin/bash
# 動作確認を行うためには、 Dockerfile を別途作成する必要がある。
```

## Visual Studio Code
### 設定
```sh
# settings.json
$ ln -sf "$(pwd)/vscode/settings.json" "$HOME/.config/Code/User/settings.json"`
```

### メモ
ユーザースニペットは使ってなかったけど、便利そうだなと思った https://qiita.com/12345/items/97ba616d530b4f692c97

## TODO
* https://github.com/olets/zsh-abbr は入れていいかも

## 良さげな記事
* [dotfilesのこだわりを晒す - エムスリーテックブログ](https://www.m3tech.blog/entry/dotfiles-bonsai)
* [ひさしぶりにzshに戻りました](https://blog.nishimu.land/entry/2022/03/21/003009)
