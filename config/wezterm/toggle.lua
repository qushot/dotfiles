local wezterm = require("wezterm")

local module = {}

function reactivate_setting_mode(window)
  window:perform_action(
    wezterm.action.ActivateKeyTable({ name = "setting_mode", one_shot = false, timeout_milliseconds = 1000 }),
    window:active_pane()
  )
end

function module.background_blur(window, value)
  local overrides = window:get_config_overrides() or {}
  if overrides.macos_window_background_blur == nil or overrides.macos_window_background_blur == 0 then
    overrides.macos_window_background_blur = value
  else
    overrides.macos_window_background_blur = 0
  end
  window:set_config_overrides(overrides)
end

function module.adjust_opacity(window, delta)
  local default_opacity = 0.85
  local overrides = window:get_config_overrides() or {}
  local current = overrides.window_background_opacity or default_opacity

  local new_opacity = math.max(0.5, math.min(1.0, current + delta))
  overrides.window_background_opacity = new_opacity
  window:set_config_overrides(overrides)

  reactivate_setting_mode(window)
end

function module.reset_opacity(window, value)
  local overrides = window:get_config_overrides() or {}
  overrides.window_background_opacity = value
  window:set_config_overrides(overrides)

  reactivate_setting_mode(window)
end

return module
