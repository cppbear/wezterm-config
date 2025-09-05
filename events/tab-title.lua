local wezterm = require("wezterm")
local platform = require("utils.platform")
local nf = wezterm.nerdfonts

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local GLYPH_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[  ]]
local GLYPH_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[  ]]
local GLYPH_CIRCLE = nf.fa_circle --[[  ]]
local GLYPH_ADMIN = nf.md_shield_half_full --[[ 󰞀 ]]
local GLYPH_WINDOWS = nf.fa_windows --[[  ]]
local GLYPH_LINUX = nf.cod_terminal_linux --[[  ]]
local GLYPH_MAC = nf.fa_apple --[[  ]]
local GLYPH_FILTER = nf.md_filter --[[ 󰈲 ]]
local GLYPH_DEBUG = nf.fa_bug --[[  ]]
local GLYPH_TERMINAL = nf.fa_terminal --[[  ]]
local GLYPH_PWSH = nf.md_powershell --[[ 󰨊 ]]
local GLYPH_CMD = nf.cod_terminal_cmd --[[  ]]
local PCT_GLYPHS = {
    nf.md_checkbox_blank_circle_outline, -- [[ 󰄰 ]]
    nf.md_circle_slice_1,                -- [[ 󰪞 ]]
    nf.md_circle_slice_2,                -- [[ 󰪟 ]]
    nf.md_circle_slice_3,                -- [[ 󰪠 ]]
    nf.md_circle_slice_4,                -- [[ 󰪡 ]]
    nf.md_circle_slice_5,                -- [[ 󰪢 ]]
    nf.md_circle_slice_6,                -- [[ 󰪣 ]]
    nf.md_circle_slice_7,                -- [[ 󰪤 ]]
    nf.md_circle_slice_8,                -- [[ 󰪥 ]]
}

local process_name_map = {
    ["cmd"] = GLYPH_CMD .. "  Cmd",
    ["pwsh"] = GLYPH_PWSH .. "  PowerShell",
    ["powershell"] = GLYPH_PWSH .. "  PowerShell",
    ["zsh"] = "Zsh",
    ["bash"] = "Bash",
    ["wslhost"] = "WSL",
}

local M = {}

M.cells = {}

M.colors = {
    default = {
        bg = "#8C246F",
        fg = "#0F2536",
    },
    is_active = {
        bg = "#3A854B",
        fg = "#0F2536",
    },

    hover = {
        bg = "#8C246F",
        fg = "#0F2536",
    },
}

M.pct_glyph = function(pct)
    pct = math.floor(pct)

    if pct >= 0 and pct <= 5 then
        return PCT_GLYPHS[1] -- empty circle
    elseif pct >= 6 and pct <= 18 then
        return PCT_GLYPHS[2] -- centered at 12 (slightly smaller than 12.5)
    elseif pct >= 19 and pct <= 31 then
        return PCT_GLYPHS[3] -- centered at 25
    elseif pct >= 32 and pct <= 43 then
        return PCT_GLYPHS[4] -- centered at 37.5
    elseif pct >= 44 and pct <= 56 then
        return PCT_GLYPHS[5] -- half-filled circle, centered at 50
    elseif pct >= 57 and pct <= 68 then
        return PCT_GLYPHS[6] -- centered at 62.5
    elseif pct >= 69 and pct <= 81 then
        return PCT_GLYPHS[7] -- centered at 75
    elseif pct >= 82 and pct <= 94 then
        return PCT_GLYPHS[8] -- centered at 88 (slightly larger than 87.5)
    elseif pct >= 95 and pct <= 100 then
        return PCT_GLYPHS[9] -- filled circle
    else
        return PCT_GLYPHS[9]
    end
end

M.get_process_name = function(s)
    local a = string.gsub(s, "(.*[/\\])(.*)", "%2")
    return a:gsub("%.[eE][xX][eE]$", "")
end

M.set_title = function(process_name, static_title, active_title, max_width, is_wsl, inset)
    local title

    if process_name:len() > 0 and static_title:len() == 0 then
        process_name = process_name_map[process_name] or process_name
        if platform.is_win then
            if is_wsl then
                title = GLYPH_LINUX .. "  " .. process_name
            else
                title = process_name
            end
        elseif platform.is_linux then
            title = GLYPH_LINUX .. "  " .. process_name
        elseif platform.is_mac then
            title = GLYPH_MAC .. "  " .. process_name
        end
    elseif static_title:len() > 0 then
        title = static_title
    else
        if active_title == "Debug" then
            title = GLYPH_DEBUG .. "  DEBUG"
        elseif active_title == "wezterm" then
            title = GLYPH_TERMINAL .. "  WezTerm"
        else
            if active_title == GLYPH_FILTER .. " Select/Search:" then
                title = active_title
            else
                local active_name = M.get_process_name(active_title)
                title = process_name_map[active_name] or active_name
            end
        end
    end

    if title:len() > max_width - inset then
        local diff = title:len() - max_width + inset
        title = wezterm.truncate_right(title, title:len() - diff)
    end

    return title
end

M.check_if_admin = function(p)
    if p:match("^Administrator: ") or p:match('(Admin)') then
        return true
    end
    return false
end

M.check_if_wsl = function(p)
    if p:match("^wsl") then
        return true
    end
    return false
end

M.tab_colors = function(tab, hover)
    local bg, fg
    if tab.is_active then
        bg = M.colors.is_active.bg
        fg = M.colors.is_active.fg
    elseif hover then
        bg = M.colors.hover.bg
        fg = M.colors.hover.fg
    else
        bg = M.colors.default.bg
        fg = M.colors.default.fg
    end
    return bg, fg
end

M.progress = function(tab)
    local status, color
    local progress = tab.active_pane.progress or 'None'

    if progress ~= "None" then
        color = "#FFC107" -- "#2196F3" "#007bff" "#4CAF50" "#28a745"
        if progress.Percentage ~= nil then
            status = M.pct_glyph(progress.Percentage)
        elseif progress.Error ~= nil then
            status = M.pct_glyph(progress.Error)
            color = "#F44336"
        end
    end

    return status, color
end

M.tab_title = function(tab, max_width, is_admin, has_progress, has_unseen_output)
    local process_name = M.get_process_name(tab.active_pane.foreground_process_name)
    local is_wsl = M.check_if_wsl(process_name)
    local inset = 4
    if is_admin then
        inset = inset + 2
    end
    if has_progress then
        inset = inset + 3
    end
    if has_unseen_output then
        inset = inset + 3
    end

    return M.set_title(process_name, tab.tab_title, tab.active_pane.title, max_width, is_wsl, inset)
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
M.push = function(bg, fg, attribute, text)
    table.insert(M.cells, { Background = { Color = bg } })
    table.insert(M.cells, { Foreground = { Color = fg } })
    table.insert(M.cells, { Attribute = attribute })
    table.insert(M.cells, { Text = text })
    table.insert(M.cells, "ResetAttributes")
end

M.setup = function()
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        M.cells = {}

        local bg, fg = M.tab_colors(tab, hover)
        local is_admin = M.check_if_admin(tab.active_pane.title)
        local progress, progress_color = M.progress(tab)
        local has_progress = progress ~= nil
        local has_unseen_output = false
        for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
                has_unseen_output = true
                break
            end
        end

        local title = M.tab_title(tab, max_width, is_admin, has_progress, has_unseen_output)

        -- Left semi-circle
        M.push(fg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_LEFT)

        -- Admin Icon
        if is_admin then
            M.push(bg, fg, { Intensity = "Bold" }, " " .. GLYPH_ADMIN)
        end

        -- Progress
        if has_progress then
            M.push(bg, progress_color or fg, { Intensity = "Bold" }, " " .. progress .. " ")
        end

        -- Title
        M.push(bg, fg, { Intensity = "Bold" }, " " .. title)

        -- Unseen output alert
        if has_unseen_output then
            M.push(bg, "#FF3B8B", { Intensity = "Bold" }, " " .. GLYPH_CIRCLE .. " ")
        end

        -- Right padding
        M.push(bg, fg, { Intensity = "Bold" }, " ")

        -- Right semi-circle
        M.push(fg, bg, { Intensity = "Bold" }, GLYPH_SEMI_CIRCLE_RIGHT)

        return M.cells
    end)
end

return M

-- local CMD_ICON = utf8.char(0xe62a)
-- local NU_ICON = utf8.char(0xe7a8)
-- local PS_ICON = utf8.char(0xe70f)
-- local ELV_ICON = utf8.char(0xfc6f)
-- local WSL_ICON = utf8.char(0xf83c)
-- local YORI_ICON = utf8.char(0xf1d4)
-- local NYA_ICON = utf8.char(0xf61a)
--
-- local VIM_ICON = utf8.char(0xe62b)
-- local PAGER_ICON = utf8.char(0xf718)
-- local FUZZY_ICON = utf8.char(0xf0b0)
-- local HOURGLASS_ICON = utf8.char(0xf252)
-- local SUNGLASS_ICON = utf8.char(0xf9df)
--
-- local PYTHON_ICON = utf8.char(0xf820)
-- local NODE_ICON = utf8.char(0xe74e)
-- local DENO_ICON = utf8.char(0xe628)
-- local LAMBDA_ICON = utf8.char(0xfb26)
--
-- local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
-- local SOLID_LEFT_MOST = utf8.char(0x2588)
-- local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)
-- local ADMIN_ICON = utf8.char(0xf49c)
