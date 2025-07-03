#!/bin/bash
set -euxo pipefail

### Finder
# 拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true
# 表示形式をリストビューに変更
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true
# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true
# 名前ソート時にフォルダを上に
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Finder起動時に開く場所
#defaults write com.apple.finder NewWindowTarget -string "PfDo"
# 適用
killall Finder

### Dock
defaults write com.apple.Dock appswitcher-all-displays -bool true
killall Dock

### Screenshot
# ファイル形式変更
defaults write com.apple.screencapture type png
# 名前
defaults write com.apple.screencapture name Screenshot
# 保存場所
defaults write com.apple.screencapture location ~/Pictures/Screenshots
# 適用
killall SystemUIServer

### .DS_Store
# ネットワークドライブ上への作成抑制
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# USB上への作成抑制
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

### システム関連
# スクロールバーを常に表示
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# スマート引用符無効
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# 自動ダッシュ無効
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
