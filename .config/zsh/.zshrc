echo "loaded .zshrc"
# Zsh configuration file

# emacs key bindings (NOTE: `EDITOR=vim` defaults to vi key bindings, so need changing to emacs key bindings)
bindkey -e

setopt INTERACTIVE_COMMENTS # interactiveモードでの#コメントを有効化
setopt PROMPT_SUBST # プロンプトで変数を展開する

autoload -Uz add-zsh-hook

eval "$(sheldon source)"

alias g='git'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# TODO: path, fpath を追加する（存在する時のみ追加される）
# path=(
# )
# fpath=(
# )

# zshaddhistory() {
#     local line="${1%%$'\n'}"
#     [[ ! "$line" =~ "^(cd|jj?|lazygit|la|ll|ls|rm|rmdir)($| )" ]]
# }

setopt NO_BEEP     # ビープ音の停止
setopt NOLISTBEEP  # ビープ音の停止(補完時)

### HISTORY ###
# $XDG_STATE_HOME/zsh ディレクトリが存在しない場合は作成する
if [[ ! -d "$XDG_STATE_HOME/zsh" ]]; then
    echo "Creating zsh state directory: $XDG_STATE_HOME/zsh"
    mkdir -p "$XDG_STATE_HOME/zsh"
fi
export HISTFILE=$XDG_STATE_HOME/zsh/history
(( HISTSIZE = (2 ** 31) - 1 ))   # Number of history can be saved in memory
(( SAVEHIST = (2 ** 31) - 1 ))   # Number of history can be saved in HISTFILE
setopt INC_APPEND_HISTORY        # 履歴ファイルに即座に書き込む
setopt SHARE_HISTORY             # セッション間で履歴を共有する
setopt HIST_IGNORE_DUPS          # 直前と同じコマンドの場合には履歴に追加しない
setopt HIST_IGNORE_ALL_DUPS      # 同じコマンドをヒストリに残さない
setopt HIST_IGNORE_SPACE         # スペースから始まるコマンド行はヒストリに残さない
setopt HIST_FIND_NO_DUPS         # 履歴検索中、重複を飛ばす
setopt HIST_REDUCE_BLANKS        # ヒストリに保存するときに余分なスペースを削除する
setopt HIST_NO_STORE             # historyコマンドは記録しない
# setopt HIST_VERIFY               # 履歴からコマンドを選択したときに、実行前に確認する
# setopt HIST_EXPIRE_DUPS_FIRST    # 重複を優先的に削除する
# setopt HIST_SAVE_NO_DUPS         # 保存時に重複を削除する
### HISTORY ###

# ディレクトリ名のみで移動できるようになる
# https://qiita.com/yaotti/items/157ff0a46736ec793a91
# .zshenvに書くべき?
setopt AUTO_CD ############## cdなしでディレクトリ移動
cdpath=(
  $HOME/go/src/github.com(N-/)
  $cdpath
)

ZSH_DIRS=(
    "$HOME/.zsh"
    "$HOME/.zsh/scripts"
)

# Create directories if they don't exist
for dir in "${ZSH_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
done

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

if command -v brew &>/dev/null; then
    # zsh-completions
    # NOTE: You may also need to force rebuild `zcompdump`: rm -f "$ZCOMPDUMP_FILE"; compinit -d "$ZCOMPDUMP_FILE"
    if [[ ! -d "$ZCOMPDUMP_DIR" ]]; then
        # $XDG_CACHE_HOME/zsh ディレクトリが存在しない場合は作成する
        echo "Creating zsh completions cache directory: $ZCOMPDUMP_DIR"
        mkdir -p "$ZCOMPDUMP_DIR"
    fi

    # Enable caching of completion candidates
    zstyle ':completion:*' use-cache on
    # Set the cache path for completion candidates
    zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
    
    # FPATH=$(brew --prefix)/share/zsh-completions:$FPATH # 不要？

    # Custom completions
    if [[ ! -d "$XDG_CACHE_HOME/zsh/completions" ]]; then
        echo "Creating custom completions directory: $XDG_CACHE_HOME/zsh/completions"
        mkdir -p "$XDG_CACHE_HOME/zsh/completions"
    fi
    fpath=(
        "$XDG_CACHE_HOME/zsh/completions"
        $fpath
    )
    # NOTE: Managing custom completions
    # * docker: `rm -f $XDG_CACHE_HOME/zsh/completions/_docker; docker completion zsh > $XDG_CACHE_HOME/zsh/completions/_docker`
    # * rustup: `rm -f $XDG_CACHE_HOME/zsh/completions/_rustup; rustup completions zsh > $XDG_CACHE_HOME/zsh/completions/_rustup`
    # * cargo: `rm -f $XDG_CACHE_HOME/zsh/completions/_cargo; rustup completions zsh cargo > $XDG_CACHE_HOME/zsh/completions/_cargo`

    autoload -Uz compinit
    compinit -d "$ZCOMPDUMP_FILE"

    # zsh-autosuggestions
    # if [[ ! -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    #     echo "zsh-autosuggestions not found, installing..."
    #     brew install zsh-autosuggestions
    # fi
    # source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # zsh-syntax-highlighting
    # if [[ ! -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    #     echo "zsh-syntax-highlighting not found, installing..."
    #     # brew install zsh-syntax-highlighting
    # fi
    # source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# junegunn/fzf (https://github.com/junegunn/fzf)
if command -v fzf &>/dev/null; then
    # Set up fzf key bindings and fuzzy completion
    source <(fzf --zsh)

    # Preview file content using bat (https://github.com/sharkdp/bat)
    export FZF_CTRL_T_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'bat -n --color=always {}'
        --bind 'ctrl-/:change-preview-window(down|hidden|)'"

    # Print tree structure in the preview window
    export FZF_ALT_C_OPTS="
        --walker-skip .git,node_modules,target
        --preview 'tree -C {}'"
fi

# Git
# NOTE
# * update: `rm -f ~/.zsh/scripts/git-prompt.sh; curl -o ~/.zsh/scripts/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh`
if [[ -f ~/.zsh/scripts/git-prompt.sh ]]; then
    source ~/.zsh/scripts/git-prompt.sh

    # Enable optional git-prompt features
    # NOTE: You may need to set the following variables in your ~/.zshenv
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_STATESEPARATOR="%F{green}:%f"
    GIT_PS1_SHOWCOLORHINTS=true
    GIT_PS1_SHOWCONFLICTSTATE=true
    GIT_PS1_DESCRIBE_STYLE="branch"
fi

function __precmd_prompt() {
    local prompt_base="%B%F{063}[%~]%f%b"
    # local prompt_symbol="%(?,%F{green},%F{red})%(!,#,>)%f"
    local prompt_symbol="%(?,%F{green}(^-^,%F{red}(;o;)) %B%(!,#,$)%b%f"

    local prompt_git=""
    if [[ -f ~/.zsh/scripts/git-prompt.sh ]]; then
        prompt_git=" $(__git_ps1 "%s")"
    fi

    PS1="${prompt_base}${prompt_git}"$'\n'"${prompt_symbol} "
}
add-zsh-hook precmd __precmd_prompt

function __precmd_add_newline() {
  if [[ -z $PS1_NEWLINE_LOGIN ]]; then
    PS1_NEWLINE_LOGIN=true
  else
    printf '\n'
  fi
}
add-zsh-hook precmd __precmd_add_newline

# Go
export GOPATH=$HOME/workspace # default: $HOME/go
# export GOPATH="$XDG_DATA_HOME"/go
export GOBIN=$HOME/go/bin     # default: $GOPATH/bin
export PATH=$PATH:$GOBIN
export GOVERSION=1.24.5
export GOSDK=$HOME/sdk/go$GOVERSION
export PATH=$GOSDK/bin:$PATH # homebrewでインストールしたgoは使わないため、PATHの先頭に追加している
# zsh-completionsで定義されている関数 __go_packages を削除、あるいは無効化したい…
# unset -f __go_packages >/dev/null 2>&1 # NG
# unfunction __go_packages # NG

function print_managing_go_sdk() {
  echo "Managing Go SDK (https://go.dev/doc/manage-install)"
  echo "  go install golang.org/dl/goX.YY.ZZ@latest"
  echo "  goX.YY.ZZ download"
  echo "  goX.YY.ZZ version"
}

# GHQ
export GHQ_ROOT=$HOME/workspace/src
# GHQ_ROOTのディレクトリが無ければ作成
if [[ ! -d ${GHQ_ROOT} ]];then
  mkdir ${GHQ_ROOT}
fi

# fzf (ref: https://junegunn.github.io/fzf/reference/)
if command -v fzf &> /dev/null; then
  # Set up fzf key bindings and fuzzy completion
  source <(fzf --zsh)

  function fzf_select_history() {
    local tac
    { which gtac &> /dev/null && tac="gtac" } || \
      { which tac &> /dev/null && tac="tac" } || \
      tac="tail -r"
    local selected_command=$(fc -l -n 1 | eval $tac | fzf --query "${LBUFFER}" --height 50% --layout=reverse --info=inline)
    if [ -n "${selected_command}" ]; then
      BUFFER="${selected_command}"
      CURSOR=$(($CURSOR + ${#selected_command}))
    else
      BUFFER="${LBUFFER}"
    fi
    zle redisplay
  }
  zle -N fzf_select_history
  bindkey '^R' fzf_select_history

  function fzf_cd_ghq_list() {
    local selected_dir=$(ghq list | fzf --prompt "cd " --height 50% --layout=reverse --info=inline --preview 'tree -a -C ${GHQ_ROOT}/{} -I "\.DS_Store|\.idea|\.git|node_modules|target" -N')
    if [ -n "$selected_dir" ]; then
      BUFFER="cd $(ghq root)/${selected_dir}"
      zle accept-line
    fi
    zle redisplay
  }
  zle -N fzf_cd_ghq_list
  bindkey '^]' fzf_cd_ghq_list

  function fzf_git_log() {
    local selected_commit=$(git log --oneline -n 45 | fzf --height 50% --layout=reverse --info=inline | awk '{print $1}')
    if [ -n "$selected_commit" ]; then
      # バッファの現在のカーソル位置にコミットハッシュを挿入
      BUFFER="${BUFFER:0:$CURSOR}${selected_commit}${BUFFER:$CURSOR}"
      # カーソル位置を挿入したコミットハッシュの直後に移動
      CURSOR=$(($CURSOR + ${#selected_commit}))
    fi
    zle redisplay
  }
  zle -N fzf_git_log
  bindkey '^s' fzf_git_log

fi

# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
