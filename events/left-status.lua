local wezterm = require("wezterm")
local nf = wezterm.nerdfonts
local M = {}

M.separator_char = " ~ "

M.colors = {
    key_fg = "#FF8000",
    key_bg = "#0F2536",
    workspace_fg = "#00CFFF",
    workspace_bg = "#0F2536",
    separator_fg = "#786D22",
    separator_bg = "#0F2536",
}

M.cells = {} -- wezterm FormatItems (ref: https://wezterm.org/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
M.push = function(text, icon, fg, bg, separate)
    table.insert(M.cells, { Foreground = { Color = fg } })
    table.insert(M.cells, { Background = { Color = bg } })
    table.insert(M.cells, { Attribute = { Intensity = "Bold" } })
    table.insert(M.cells, { Text = icon .. " " .. text })

    if separate then
        table.insert(M.cells, { Foreground = { Color = M.colors.separator_fg } })
        table.insert(M.cells, { Background = { Color = M.colors.separator_bg } })
        table.insert(M.cells, { Text = M.separator_char })
    end

    table.insert(M.cells, "ResetAttributes")
end

local GLYPH_KEY_TABLE = nf.md_table_key --[[ 󱏅 ]]
local GLYPH_KEY = nf.md_key --[[ 󰌆 ]]
local GLYPH_WORKSPACE = nf.md_briefcase --[[ 󰃖 ]]

M.setup = function()
    wezterm.on("update-status", function(window, pane)
        M.cells = {}
        local table_name = window:active_key_table()
        local workspace = window:active_workspace()

        if table_name then
            M.push(" " .. table_name:upper(), GLYPH_KEY_TABLE, M.colors.key_fg, M.colors.key_bg, true)
        end

        if window:leader_is_active() then
            M.push(" LEADER", GLYPH_KEY, M.colors.key_fg, M.colors.key_bg, true)
        end

        M.push(" " .. workspace, GLYPH_WORKSPACE, M.colors.workspace_fg, M.colors.workspace_bg, false)

        window:set_left_status(wezterm.format(M.cells))
    end)
end

return M
