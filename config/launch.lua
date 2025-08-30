local platform = require("utils.platform")

local options = {
    default_prog = {},
    launch_menu = {},
    -- default_gui_startup_args = { "connect", "unix" },
}

if platform.is_win then
    options.default_prog = { "pwsh", "-nologo" }
    options.launch_menu = {
        { label = " PowerShell", args = { "pwsh", "-nologo" } },
        { label = " Cmd", args = { "cmd" } },
    }
elseif platform.is_mac then
    options.default_prog = { "zsh", "--login" }
    options.launch_menu = {
        { label = " Zsh", args = { "zsh", "--login" } },
        { label = " Bash", args = { "bash", "--login" } },
    }
elseif platform.is_linux then
    options.default_prog = { "zsh", "--login" }
    options.launch_menu = {
        { label = " Zsh", args = { "zsh", "--login" } },
        { label = " Bash", args = { "bash", "--login" } },
    }
end

return options
