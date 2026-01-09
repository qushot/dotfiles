local wezterm = require("wezterm")

local module = {}

function module.background_blur(window, value)
  local overrides = window:get_config_overrides() or {}
  if overrides.macos_window_background_blur == nil or overrides.macos_window_background_blur == 0 then
    overrides.macos_window_background_blur = value
  else
    overrides.macos_window_background_blur = 0
  end
  window:set_config_overrides(overrides)
end

return module
