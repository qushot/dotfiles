echo "loaded .zshenv"
# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Zsh environment settings
export EDITOR="vim"
export VISUAL="vim"
export ZCOMPDUMP_DIR="$XDG_CACHE_HOME/zsh"
export ZCOMPDUMP_FILE="$ZCOMPDUMP_DIR/zcompdump-$ZSH_VERSION"

# History settings
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# User binaries
export PATH="$HOME/bin:$PATH"

# Homebrew
export HOMEBREW_BUNDLE_FILE_GLOBAL="$XDG_CONFIG_HOME"/homebrew/Brewfile

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
case "$OSTYPE" in
  darwin*)
    ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
    export DOCKER_HOST=unix://${HOME}/.rd/docker.sock
    export PATH="${HOME}/.rd/bin:$PATH"
    ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
    ;;
  linux*)
    export DOCKER_HOST=unix://"$XDG_RUNTIME_DIR"/docker.sock
    ;;
esac

# fzf
export FZF_DEFAULT_OPTS="--height 50% --tmux 90%,70% --layout=reverse --info=inline \
--bind 'ctrl-/:change-preview-window(80%|hidden|)' \
--bind 'ctrl-u:preview-half-page-up' \
--bind 'ctrl-d:preview-half-page-down' \
"
# Disable fzf's default key bindings
export FZF_CTRL_T_COMMAND=
export FZF_CTRL_R_COMMAND=
export FZF_ALT_C_COMMAND=
# # Preview file content using bat (https://github.com/sharkdp/bat)
# export FZF_CTRL_T_OPTS="
#     --walker-skip .git,node_modules,target
#     --preview 'bat -n --color=always {}'
#     --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# # Print tree structure in the preview window
# export FZF_ALT_C_OPTS="
#     --walker-skip .git,node_modules,target
#     --preview 'tree -C {}'"

# Go
export GOPATH="$XDG_DATA_HOME"/go # default: $HOME/go
export PATH=$PATH:$GOPATH/bin
# NOTE: If you want to use a different version of Go, uncomment and set the following
# export GOVERSION=1.25.5
# export PATH=$HOME/sdk/go$GOVERSION/bin:$PATH

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
if [ -f "$CARGO_HOME/env" ]; then
. "$CARGO_HOME/env"
fi
