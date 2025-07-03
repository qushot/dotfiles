# Zsh configuration file

setopt PROMPT_SUBST

autoload -Uz add-zsh-hook

alias g='git'

ZSH_DIRS=(
    "$HOME/.zsh"
    "$HOME/.zsh/completions"
    "$HOME/.zsh/scripts"
)

# Create directories if they don't exist
for dir in "${ZSH_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
done

if command -v brew &>/dev/null; then
    # Set up Homebrew environment variables
    eval "$(brew shellenv)"

    # zsh-completions
    # NOTE: You may also need to force rebuild `zcompdump`: rm -f ~/.zcompdump; compinit
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    # Custom completions
    FPATH="$HOME/.zsh/completions:$FPATH"
    # NOTE: Managing custom completions
    # * docker: `rm -f ~/.zsh/completions/_docker; docker completion zsh > ~/.zsh/completions/_docker`
    # * rustup: `rm -f ~/.zsh/completions/_rustup; rustup completions zsh > ~/.zsh/completions/_rustup`
    # * cargo: `rm -f ~/.zsh/completions/_cargo; rustup completions zsh cargo > ~/.zsh/completions/_cargo`

    autoload -Uz compinit
    compinit

    # zsh-autosuggestions
    if [[ ! -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        echo "zsh-autosuggestions not found, installing..."
        brew install zsh-autosuggestions
    fi
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

    # zsh-syntax-highlighting
    if [[ ! -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        echo "zsh-syntax-highlighting not found, installing..."
        brew install zsh-syntax-highlighting
    fi
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
    local prompt_base="%B%F{063}%K{blue}[%~]%k%f%b"
    # local prompt_symbol="%(?,%F{green},%F{red})%(!,#,>)%f"
    local prompt_symbol="%(?,%F{green}(^-^,%F{red}(;o;)) %B%(!,#,$)%b%f"

    local prompt_git=""
    if [[ -f ~/.zsh/scripts/git-prompt.sh ]]; then
        prompt_git=" $(__git_ps1 "%s")"
    fi

    PS1="${prompt_base}${prompt_git}"$'\n'"${prompt_symbol} "
}
add-zsh-hook precmd __precmd_prompt

# Docker
export PATH=$HOME/bin:$PATH
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# Rust
. "$HOME/.cargo/env"

# for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo
