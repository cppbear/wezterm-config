local wezterm = require("wezterm")
local M = {}

local DELAY = 100

-- ref: https://github.com/wezterm/wezterm/discussions/5578#discussioncomment-10579542
M.center_window_once = function(window)
    wezterm.GLOBAL.windows_centered = wezterm.GLOBAL.windows_centered or {}

    local window_id = tostring(window:window_id())
    if wezterm.GLOBAL.windows_centered[window_id] then
        return
    end

    local screen = wezterm.gui.screens().active

    -- Need a delay if connecting to a domain
    wezterm.sleep_ms(DELAY)

    local width = math.floor(screen.width * 0.85)
    local height = math.floor(screen.height * 0.85)
    window:set_inner_size(width, height)

    local dimensions = window:get_dimensions()
    while dimensions.pixel_width ~= width do
        dimensions = window:get_dimensions()
    end

    local x = screen.x + (screen.width - dimensions.pixel_width) * 0.5
    local y = screen.y + (screen.height - dimensions.pixel_height) * 0.5
    window:set_position(x, y)

    wezterm.GLOBAL.windows_centered[window_id] = true
end

M.setup = function()
    wezterm.on("update-status", function(window)
        M.center_window_once(window)
    end)
end

return M
