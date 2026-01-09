local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- wezterm.target_triple: https://wezterm.org/config/lua/wezterm/target_triple.html

local background_opacity = 0.85
local background_blur = 10
local scheme_name = "Ubuntu" -- , Kanagawa (Gogh), 
config.automatically_reload_config = true -- default is true since version 20201031-154415-9614e117
config.use_ime = true -- default is true since version 20220319-142410-0fcdea07

config.initial_cols = 180
config.initial_rows = 50
config.color_scheme = scheme_name
config.window_background_opacity = background_opacity
config.macos_window_background_blur = background_blur
-- config.win32_system_backdrop = 'Acrylic'
config.font = wezterm.font {
  family = 'HackGen Console NF',
  weight = 'Bold',
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.font_size = 12.0 -- Windows
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  config.font_size = 14.0 -- MacOS
end

config.enable_scroll_bar = true
config.default_cursor_style = 'BlinkingUnderline'

------------------
-- Tab
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Gnome"
config.integrated_title_button_alignment = "Right"

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = background_opacity
config.show_new_tab_button_in_tab_bar = false
local scheme = wezterm.color.get_builtin_schemes()[scheme_name]
config.colors = {
  -- https://wezterm.org/config/appearance.html#retro-tab-bar-appearance
  -- https://wezterm.org/config/appearance.html#defining-your-own-colors
  tab_bar = {
    background = scheme.background,
    active_tab = { bg_color = scheme.ansi[5], fg_color = scheme.brights[5], intensity = "Bold" },
    inactive_tab = { bg_color = scheme.background, fg_color = scheme.brights[1] },
    inactive_tab_hover = { bg_color = scheme.background, fg_color = scheme.brights[5], italic = true },
  }
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

------------------
-- Keybinds
config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
  -- Toggle macOS window background blur
  {
    key = "q",
    mods = "LEADER",
    action = wezterm.action_callback(
      function(window)
        require("toggle").background_blur(window, background_blur)
      end
    ),
  },
}
config.key_tables = {
  -- Additional key tables can be defined here
}
config.mouse_bindings = {
  -- Right click to paste from clipboard
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

------------------
-- Default Shell
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- Windows
  config.default_prog = { "wsl.exe", "--distribution-id", "{ca735016-15db-4e93-a771-7688aad8ec92}", "--cd", "~" }
  -- config.default_prog = { "wsl.exe", "--distribution-id", "{564ad482-51b6-4cb9-9aa8-ccadb93a9c1f}", "--cd", "~" } -- dotfiles
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  -- MacOS
  config.default_prog = { "/opt/homebrew/bin/zsh", "-l" }
end

return config
