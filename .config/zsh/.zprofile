# Set up Homebrew environment variables
case "$OSTYPE" in
  darwin*)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  linux*)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
esac

# Show the current zsh version
zsh --version
