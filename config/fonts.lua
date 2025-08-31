local wezterm = require("wezterm")
local platform = require("utils.platform")

-- ref: https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono
local font = "JetBrains Maple Mono"
local font_size = 12

if platform.is_mac then
    font_size = 16
end

return {
    font = wezterm.font(font),
    -- cell_width = 0.83,
    font_size = font_size,

    -- ref: https://wezterm.org/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
    freetype_load_target = "Normal", ---@type "Normal"|"Light"|"Mono"|"HorizontalLcd"
    freetype_render_target = "Normal", ---@type "Normal"|"Light"|"Mono"|"HorizontalLcd"
}
