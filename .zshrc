#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

export LANG=ja_JP.UTF-8 ##### 文字コードの指定
setopt print_eight_bit ###### 日本語ファイル名を表示可能にする
setopt auto_cd ############## cdなしでディレクトリ移動
function chpwd() { ls }

setopt no_beep ############## ビープ音の停止
setopt nolistbeep ########### ビープ音の停止(補完時)
setopt auto_pushd ########### cd -<tab>で以前移動したディレクトリを表示
HISTFILE=~/.zsh_history ##### ヒストリを保存、数を増やす
HISTSIZE=100000 #############
SAVEHIST=100000 #############
setopt share_history ######## zsh間でのヒストリ共有
setopt hist_ignore_dups ##### 直前と同じコマンドの場合には履歴に追加しない
setopt hist_ignore_all_dups # 同じコマンドをヒストリに残さない
setopt hist_ignore_space #### スペースから始まるコマンド行はヒストリに残さない
setopt hist_find_no_dups #### 履歴検索中、重複を飛ばす
setopt hist_reduce_blanks ### ヒストリに保存するときに余分なスペースを削除する
setopt hist_no_store ######## historyコマンドは記録しない

# zsh-completionsによる補完
if [ -e $(brew --prefix)/share/zsh-completions ]; then
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

# brewでインストールしたツールの補完(多分)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export DOCKER_HOST=unix://$HOME/.rd/docker.sock

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# kubectl completion
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

# Terraform
alias t=terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

autoload -Uz compinit && compinit -u

# GHQ
export GHQ_ROOT=$HOME/workspace/src
# GHQ_ROOTのディレクトリが無ければ作成
if [[ ! -d ${GHQ_ROOT} ]];then
  mkdir ${GHQ_ROOT}
fi

##### https://gist.github.com/yuttie/2aeaecdba24256c73bf2 #####
# Search shell history with peco: https://github.com/peco/peco
# Adapted from: https://github.com/mooz/percol#zsh-history-search
if which peco &> /dev/null; then
  function peco_select_history() {
    local tac
    { which gtac &> /dev/null && tac="gtac" } || \
      { which tac &> /dev/null && tac="tac" } || \
      tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | \
                peco --query "$LBUFFER")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_history
  bindkey '^R' peco_select_history

  function peco_select_gcloud_config() {
    local confname=$(gcloud config configurations list | tail -n +2 | peco --query "$LBUFFER" | awk '{print $1}')
    if [ -n "${confname}" ]; then
      BUFFER="gcloud config configurations activate ${confname}"
      zle accept-line
      zle -R -c       # refresh
    fi
  }
  zle -N peco_select_gcloud_config
  bindkey '^V' peco_select_gcloud_config
fi

function peco_cd_ghq_list() {
  local selected_dir=$(ghq list | peco --prompt "GHQ>")
  if [ -n "$selected_dir" ]; then
    BUFFER=" cd ${GHQ_ROOT}/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco_cd_ghq_list
bindkey '^]' peco_cd_ghq_list

# ghqでcloneしたリポジトリをpecoで選択してブラウザで開く
alias ghb='gh browse --repo $(ghq list | peco)'

# General
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/bin
export EDITOR="vim"
export VISUAL="vim"

# JetBrains IDE
export PATH="$PATH:~/Library/Application Support/JetBrains/Toolbox/cli"

#node
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Go
export GOPATH=$HOME/workspace # default: $HOME/go
export GOBIN=$HOME/go/bin     # default: $GOPATH/bin
export PATH=$PATH:$GOBIN
export GOVERSION=1.22.2
export GOSDK=$HOME/sdk/go$GOVERSION
export PATH=$GOSDK/bin:$PATH # homebrewでインストールしたgoは使わないため、PATHの先頭に追加している

function print_managing_go_sdk() {
  echo "Managing Go SDK (https://go.dev/doc/manage-install)"
  echo "  go install golang.org/dl/goX.YY.ZZ@latest"
  echo "  goX.YY.ZZ download"
  echo "  goX.YY.ZZ version"
}


# myself script
export PATH=$PATH:$HOME/shellscript/bin

# gcloud
export CLOUDSDK_PYTHON=python3.9

# alias git="git-switch-trainer"
alias lla="ls -la"
alias g="git"

# used /usr/local/bin/pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
###-begin-ng-completion###
#

# ng command completion script
#   This command supports 3 cases.
#   1. (Default case) It prints a common completion initialisation for both Bash and Zsh.
#      It is the result of either calling "ng completion" or "ng completion -a".
#   2. Produce Bash-only completion: "ng completion -b" or "ng completion --bash".
#   3. Produce Zsh-only completion: "ng completion -z" or "ng completion --zsh".
#
# Usage: . <(ng completion --bash) # place it appropriately in .bashrc or
#        . <(ng completion --zsh) # find a spot for it in .zshrc
#
_ng_completion () {
  local words cword opts
  read -Ac words
  read -cn cword
  let cword-=1

  case $words[cword] in
    ng|help) opts="--version -v b build completion doc e e2e eject g generate get help l lint n new s serve server set t test update v version xi18n" ;;
   b|build) opts="--aot --app --base-href --build-optimizer --bundle-dependencies --common-chunk --delete-output-path --deploy-url --environment --extract-css --extract-licenses --i18n-file --i18n-format --locale --missing-translation --named-chunks --output-hashing --output-path --poll --preserve-symlinks --progress --service-worker --show-circular-dependencies --skip-app-shell --sourcemaps --stats-json --subresource-integrity --target --vendor-chunk --verbose --watch -a -aot -bh -buildOptimizer -bundleDependencies -cc -d -dop -e -ec -extractLicenses -i18nFile -i18nFormat -locale -missingTranslation -nc -oh -op -poll -pr -preserveSymlinks -scd -skipAppShell -sm -sri -statsJson -sw -t -v -vc -w" ;;
   completion) opts="--all --bash --zsh -a -b -z" ;;
   doc) opts="--search -s" ;;
   e|e2e) opts="--aot --app --base-href --build-optimizer --bundle-dependencies --common-chunk --config --delete-output-path --deploy-url --disable-host-check --element-explorer --environment --extract-css --extract-licenses --hmr --host --i18n-file --i18n-format --live-reload --locale --missing-translation --named-chunks --open --output-hashing --output-path --poll --port --preserve-symlinks --progress --proxy-config --public-host --serve --serve-path --service-worker --show-circular-dependencies --skip-app-shell --sourcemaps --specs --ssl --ssl-cert --ssl-key --subresource-integrity --suite --target --vendor-chunk --verbose --watch --webdriver-update -H -a -aot -bh -buildOptimizer -bundleDependencies -c -cc -d -disableHostCheck -dop -e -ec -ee -extractLicenses -hmr -i18nFile -i18nFormat -live-reload-client -locale -lr -missingTranslation -nc -o -oh -op -p -pc -poll -pr -preserveSymlinks -s -scd -servePath -skipAppShell -sm -sp -sri -ssl -sslCert -sslKey -su -sw -t -v -vc -w -wu" ;;
   eject) opts="--aot --app --base-href --build-optimizer --bundle-dependencies --common-chunk --delete-output-path --deploy-url --environment --extract-css --extract-licenses --force --i18n-file --i18n-format --locale --missing-translation --named-chunks --output-hashing --output-path --poll --preserve-symlinks --progress --service-worker --show-circular-dependencies --skip-app-shell --sourcemaps --subresource-integrity --target --vendor-chunk --verbose --watch -a -aot -bh -buildOptimizer -bundleDependencies -cc -d -dop -e -ec -extractLicenses -force -i18nFile -i18nFormat -locale -missingTranslation -nc -oh -op -poll -pr -preserveSymlinks -scd -skipAppShell -sm -sri -sw -t -v -vc -w" ;;
   g|generate) opts="--app --collection --dry-run --force --lint-fix -a -c -d -f -lf" ;;
   get) opts="--global -global" ;;
   help) opts="--short -s" ;;
   l|lint) opts="--fix --force --format --type-check -fix -force -t -typeCheck" ;;
   n|new) opts="--collection --dry-run --verbose -c -d -v" ;;
   s|serve|server) opts="--aot --app --base-href --build-optimizer --bundle-dependencies --common-chunk --delete-output-path --deploy-url --disable-host-check --environment --extract-css --extract-licenses --hmr --host --i18n-file --i18n-format --live-reload --locale --missing-translation --named-chunks --open --output-hashing --output-path --poll --port --preserve-symlinks --progress --proxy-config --public-host --serve-path --service-worker --show-circular-dependencies --skip-app-shell --sourcemaps --ssl --ssl-cert --ssl-key --subresource-integrity --target --vendor-chunk --verbose --watch -H -a -aot -bh -buildOptimizer -bundleDependencies -cc -d -disableHostCheck -dop -e -ec -extractLicenses -hmr -i18nFile -i18nFormat -live-reload-client -locale -lr -missingTranslation -nc -o -oh -op -p -pc -poll -pr -preserveSymlinks -scd -servePath -skipAppShell -sm -sri -ssl -sslCert -sslKey -sw -t -v -vc -w" ;;
   set) opts="--global -g" ;;
   t|test) opts="--app --browsers --code-coverage --colors --config --environment --log-level --poll --port --preserve-symlinks --progress --reporters --single-run --sourcemaps --watch -a -browsers -c -cc -colors -e -logLevel -poll -port -preserveSymlinks -progress -reporters -sm -sr -w" ;;
   update) opts="--dry-run --next -d -next" ;;
   xi18n) opts="--app --i18n-format --locale --out-file --output-path --progress --verbose -a -f -l -of -op -progress -verbose" ;;
   *) opts="" ;;
  esac

  setopt shwordsplit
  reply=($opts)
  unset shwordsplit
}

compctl -K _ng_completion ng

alias kctx="kubectx"
alias kctxp='kctx $(kctx | peco)'
alias kns="kubens"
###-end-ng-completion###
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# curl
export PATH="/usr/local/opt/curl/bin:$PATH"

# https://cloud.google.com/run/docs/authenticating/developers?hl=ja
alias gcurl='curl --header "Authorization: Bearer $(gcloud auth print-identity-token)"'

autoload -U colors; colors

# zsh-kubectl-promptが無ければインストール
# if [[ ! -d ~/.zsh-kubectl-prompt ]];then
#   git clone https://github.com/superbrothers/zsh-kubectl-prompt.git ~/.zsh-kubectl-prompt
# fi
# source $HOME/.zsh-kubectl-prompt/kubectl.zsh
# zstyle ':zsh-kubectl-prompt:' separator '('
# zstyle ':zsh-kubectl-prompt:' preprompt ''
# zstyle ':zsh-kubectl-prompt:' postprompt ')'
# K8SPROMPT='%F{blue}K8s: $ZSH_KUBECTL_PROMPT%f'

# function gcp_info {
#   if [ -f "$HOME/.config/gcloud/active_config" ]; then
#     gcp_profile=$(cat $HOME/.config/gcloud/active_config)
#     gcp_account=$(awk '/account/{print $3}' $HOME/.config/gcloud/configurations/config_$gcp_profile)
#     gcp_project=$(awk '/project/{print $3}' $HOME/.config/gcloud/configurations/config_$gcp_profile)
#     if [ ! -z ${gcp_project} ]; then
#       echo "${gcp_project}(${gcp_account}"
#     fi
#   fi
# }
# GCPROMPT='%F{cyan}GCP: `gcp_info`)%f'

# PROMPT=${GCPROMPT}"
# ${K8SPROMPT}
# ${PROMPT}"

# ESC + 「x」キーを入力し「testris」と入力
autoload -Uz tetris
zle -N tetris

# ディレクトリ名のみで移動できるようになる
# https://suin.io/568
# .zshenvに書くべき
cdpath=(
  $HOME/go/src/github.com(N-/)
  $cdpath
)

# zplugが無ければインストール
# if [[ ! -d ~/.zplug ]];then
  # git clone https://github.com/zplug/zplug ~/.zplug
# fi

# Java 17
export JAVA_HOME=`/usr/libexec/java_home -v 17`
PATH=${JAVA_HOME}/bin:${PATH}

# Flutter
export PATH="$PATH:$HOME/sdk/flutter/bin"

# Apigee/Sackmesser
export PATH="$PATH:$HOME/shellscript/devrel/tools/apigee-sackmesser/bin"

# iTerm2
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh || true

# direnv
eval "$(direnv hook zsh)"

#PATH=~/.docker/cli-plugins:${PATH}

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
export PATH="/usr/local/opt/libpq/bin:$PATH"

# n
export N_PREFIX="$HOME/.n"
export PATH="$PATH:$N_PREFIX/bin"
