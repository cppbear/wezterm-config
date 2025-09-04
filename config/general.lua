return {
    -- behaviours
    automatically_reload_config = true,
    check_for_updates = false,
    exit_behavior = "CloseOnCleanExit", -- if the shell program exited with a successful status
    status_update_interval = 1000,

    -- scrollbar
    scrollback_lines = 9000,

    -- ref: https://github.com/wezterm/wezterm/issues/6645#issuecomment-3117072387
    enable_wayland = false,

    -- debug
    -- debug_key_events = true,
}
