local wezterm = require("wezterm")
local math = require("utils.math")
local nf = wezterm.nerdfonts
local M = {}

M.separator_char = " ~ "

M.colors = {
    date_fg = "#3E7FB5",
    date_bg = "#0F2536",
    battery_fg = "#B52F90",
    battery_bg = "#0F2536",
    separator_fg = "#786D22",
    separator_bg = "#0F2536",
}

M.cells = {} -- wezterm FormatItems (ref: https://wezterm.org/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
---@param separate boolean
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

local ICON_DATE = nf.fa_calendar --[[  ]]

M.set_date = function()
    local date = wezterm.strftime(" %a %H:%M")
    M.push(date, ICON_DATE, M.colors.date_fg, M.colors.date_bg, true)
end

local discharging_icons = {
    nf.md_battery_alert, --[[ 󰂃 ]]
    nf.md_battery_20, --[[ 󰁻 ]]
    nf.md_battery_30, --[[ 󰁼 ]]
    nf.md_battery_40, --[[ 󰁽 ]]
    nf.md_battery_50, --[[ 󰁾 ]]
    nf.md_battery_60, --[[ 󰁿 ]]
    nf.md_battery_70, --[[ 󰂀 ]]
    nf.md_battery_80, --[[ 󰂁 ]]
    nf.md_battery_90, --[[ 󰂂 ]]
    nf.md_battery, --[[ 󰁹 ]]
}
local charging_icons = {
    nf.md_battery_charging_10, --[[ 󰢜 ]]
    nf.md_battery_charging_20, --[[ 󰂆 ]]
    nf.md_battery_charging_30, --[[ 󰂇 ]]
    nf.md_battery_charging_40, --[[ 󰂈 ]]
    nf.md_battery_charging_50, --[[ 󰢝 ]]
    nf.md_battery_charging_60, --[[ 󰂉 ]]
    nf.md_battery_charging_70, --[[ 󰢞 ]]
    nf.md_battery_charging_80, --[[ 󰂊 ]]
    nf.md_battery_charging_90, --[[ 󰂋 ]]
    nf.md_battery_charging, --[[ 󰂅 ]]
}

M.set_battery = function()
    -- ref: https://wezterm.org/config/lua/wezterm/battery_info.html
    local charge = ""
    local icon = ""

    for _, b in ipairs(wezterm.battery_info()) do
        local idx = math.clamp(math.round(b.state_of_charge * 10), 1, 10)
        charge = string.format("%.0f%%", b.state_of_charge * 100)

        if b.state == "Charging" then
            icon = charging_icons[idx]
        else
            icon = discharging_icons[idx]
        end
    end

    M.push(charge, icon, M.colors.battery_fg, M.colors.battery_bg, false)
end

M.setup = function()
    wezterm.on("update-status", function(window, _pane)
        M.cells = {}
        M.set_date()
        M.set_battery()

        window:set_right_status(wezterm.format(M.cells))
    end)
end

return M
