#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# DOTFILES_DIR/config 配下のディレクトリが XDG_CONFIG_HOME 配下に無ければ、シンボリックリンクを作成する
for dir in $(ls "${DOTFILES_DIR}"/config); do
    if [ ! -e "${XDG_CONFIG_HOME}/${dir}" ]; then
        echo "[LINK] Linking '${dir}' to ${XDG_CONFIG_HOME}"
        ln -sfv "${DOTFILES_DIR}/config/${dir}" "${XDG_CONFIG_HOME}"
    else
        echo "[SKIP] '${dir}' already exists in ${XDG_CONFIG_HOME}"
    fi
done
