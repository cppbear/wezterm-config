local wezterm = require("wezterm")
local nf = wezterm.nerdfonts
local M = {}

local GLYPH_FILTER = nf.md_filter --[[ 󰈲 ]]

M.setup = function()
    wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
        if default_action and button == "Left" then
            window:perform_action(default_action, pane)
        end

        if default_action and button == "Right" then
            window:perform_action(
                wezterm.action.ShowLauncherArgs({
                    title = GLYPH_FILTER .. " Select/Search:",
                    flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS",
                }),
                pane
            )
        end
        return false
    end)
end

return M
