local wezterm = require("wezterm")
-- local math = require("utils.math")
local M = {}

local DOMAIN_DELAY = 85
local DELAY = 15

-- ref: https://github.com/wezterm/wezterm/discussions/5578#discussioncomment-10579542
M.center_window_once = function(window)
    wezterm.GLOBAL.windows_centered = wezterm.GLOBAL.windows_centered or {}

    local window_id = tostring(window:window_id())
    if wezterm.GLOBAL.windows_centered[window_id] then
        return
    end

    local screen = wezterm.gui.screens().active

    -- Need another delay if connecting to a domain
    wezterm.sleep_ms(DOMAIN_DELAY)

    local width = screen.width * 0.85
    local height = screen.height * 0.85
    window:set_inner_size(width, height)

    -- Short delay to allow the window to resize
    wezterm.sleep_ms(DELAY)

    local dimensions = window:get_dimensions()
    local x = screen.x + (screen.width - dimensions.pixel_width) * 0.5
    local y = screen.y + (screen.height - dimensions.pixel_height) * 0.5

    wezterm.GLOBAL.windows_centered[window_id] = true

    window:set_position(x, y)
end

M.setup = function()
    wezterm.on("update-status", function(window)
        M.center_window_once(window)
    end)
end

return M
