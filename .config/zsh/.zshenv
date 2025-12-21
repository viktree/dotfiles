# ---------------------------------------------------------------------------------------
# ~/.zshenv — environment only (no logic, no sourcing)
# ---------------------------------------------------------------------------------------
#
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.
#
# ---------------------------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$XDG_LOCAL_HOME/bin"

# Zsh configuration directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Brew
HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
export ANDROID_HOME="$HOMEBREW_PREFIX/android-sdk"
export ANDROID_NDK_HOME="$HOMEBREW_PREFIX/android-ndk"
export ANT_HOME="$HOMEBREW_PREFIX/ant/libexec"
export GRADLE_HOME="$HOMEBREW_PREFIX/gradle"
export MAVEN_HOME="$HOMEBREW_PREFIX/maven"

# PATH (zsh-native)
path=(
  $XDG_BIN_HOME
  $HOME/.spicetify
  $HOME/programs/google-cloud-sdk/bin
  $HOME/radioconda/bin
  $HOME/.rd/bin

  $XDG_DATA_HOME/pnpm
  $XDG_DATA_HOME/zinit/plugins/ogham---exa
  $XDG_DATA_HOME/zinit/polaris/bin

  # Applications
  /Applications/Ghostty.app/Contents/MacOS
  /Applications/Wireshark.app/Contents/MacOS

  # Standard Unix binaries
  /bin
  /usr/bin

  # System binaries for root/admin tasks
  /sbin
  /usr/sbin

  # Third-party tools
  /usr/local/bin

  /opt/X11/bin

  # Probably a custom or project-specific environment (e.g., a development toolkit).
  /opt/pmk/env/global/bin

  # GPG2 binaries installed separately.
  /usr/local/MacGPG2/bin

  # Default homebrew path
  /opt/homebrew/bin

  # Homebrew binaries for system administration tasks.
  /opt/homebrew/sbin
)

# ---------------------------------------------------------------------------------------
