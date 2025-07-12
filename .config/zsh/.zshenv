# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Zsh environment settings
# export EDITOR="vim" # 何故か Ctrl+N,P,B,F,A,E などが効かなくなる
# export VISUAL="vim" # 何故か Ctrl+N,P,B,F,A,E などが効かなくなる
export ZCOMPDUMP_DIR="$XDG_CACHE_HOME/zsh"
export ZCOMPDUMP_FILE="$ZCOMPDUMP_DIR/zcompdump-$ZSH_VERSION"

# History settings
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export PATH="$HOME/bin:$PATH"
export DOCKER_HOST=unix://"$XDG_RUNTIME_DIR"/docker.sock

# Rust
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
. "$CARGO_HOME/env"
