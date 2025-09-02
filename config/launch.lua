local wezterm = require("wezterm")
local platform = require("utils.platform")
local nf = wezterm.nerdfonts

local options = {
    default_prog = {},
    launch_menu = {},
    -- default_gui_startup_args = { "connect", "unix" },
}

local GLYPH_WINDOWS = nf.fa_windows --[[  ]]
local GLYPH_LINUX = nf.cod_terminal_linux --[[  ]]
local GLYPH_MAC = nf.fa_apple --[[  ]]

if platform.is_win then
    options.default_prog = { "pwsh", "-nologo" }
    options.launch_menu = {
        { label = GLYPH_WINDOWS .. " PowerShell", args = { "pwsh", "-nologo" } },
        { label = GLYPH_WINDOWS .. " Cmd",        args = { "cmd" } },
    }
elseif platform.is_linux then
    options.default_prog = { "zsh", "--login" }
    options.launch_menu = {
        { label = GLYPH_LINUX .. " Zsh",  args = { "zsh", "--login" } },
        { label = GLYPH_LINUX .. " Bash", args = { "bash", "--login" } },
    }
elseif platform.is_mac then
    options.default_prog = { "zsh", "--login" }
    options.launch_menu = {
        { label = GLYPH_MAC .. " Zsh",  args = { "zsh", "--login" } },
        { label = GLYPH_MAC .. " Bash", args = { "bash", "--login" } },
    }
end

return options
