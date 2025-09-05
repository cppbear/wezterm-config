local platform = require("utils.platform")

-- ref: https://github.com/wezterm/wezterm/pull/7095
local window_decorations = platform.is_win and "INTEGRATED_BUTTONS|RESIZE" or "TITLE|RESIZE"
local window_background_opacity = platform.is_linux and 1 or 0.7

return {
    front_end = "WebGpu",
    webgpu_power_preference = "HighPerformance",
    prefer_egl = true,

    -- color scheme
    color_scheme = "Campbell (Gogh)",

    -- background
    -- If below not working in Windows,try method in https://github.com/wezterm/wezterm/issues/4145#issuecomment-2976018801
    window_background_opacity = window_background_opacity,
    win32_system_backdrop = "Acrylic",
    macos_window_background_blur = 70,

    -- scrollbar
    enable_scroll_bar = true,
    min_scroll_bar_height = "3cell",
    colors = {
        scrollbar_thumb = "#34354D",
    },

    -- tab bar
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = true,
    tab_max_width = 30,
    show_tab_index_in_tab_bar = true,
    switch_to_last_active_tab_when_closing_tab = true,

    -- cursor
    animation_fps = 1,
    default_cursor_style = "BlinkingBar",
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    cursor_blink_rate = 500,

    -- window
    adjust_window_size_when_changing_font_size = false,
    window_decorations = window_decorations,
    -- window_padding = {
    --     left = 5,
    --     right = 10,
    --     top = 12,
    --     bottom = 7,
    -- },
    window_frame = {
        active_titlebar_bg = "#0F2536",
        inactive_titlebar_bg = "#0F2536",
    },
    inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
