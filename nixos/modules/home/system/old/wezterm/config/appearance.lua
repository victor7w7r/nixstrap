local colors = require 'utils.catppuccin'
local platform = require 'utils.platform'
local tables = require 'utils.tables'

local os = {}

if platform.is_mac then
    os.window_decorations = "RESIZE|TITLE|MACOS_FORCE_DISABLE_SHADOW"
    os.window_padding = { left = 9, right = 9, top = 12, bottom = 0 }
    os.macos_window_background_blur = 10
    os.window_background_opacity = 0.7
    os.native_macos_fullscreen_mode = true
elseif platform.is_win then
    os.window_decorations = "RESIZE|TITLE"
    os.window_padding = { left = 12, right = 12, top = 0, bottom = 4 }
    os.window_background_opacity = 0
    os.win32_system_backdrop = "Tabbed"
else
    os.window_decorations = "RESIZE|TITLE|INTEGRATED_BUTTONS"
    os.integrated_title_buttons = { "Close", "Hide", "Maximize" }
    os.integrated_title_button_alignment = "Left"
    os.window_background_opacity = 0.7
    os.window_padding = { left = 12, right = 12, top = 10, bottom = 0 }
end

return tables.merge({
    os,
    {
        colors = colors,
        inactive_pane_hsb = { saturation = 0.9, brightness = 0.7 },

        default_cursor_style = 'BlinkingBar',
        cursor_blink_rate = 500,
        hide_mouse_cursor_when_typing = false,
        force_reverse_video_cursor = true,

        text_blink_ease_in = "EaseIn",
        text_blink_ease_out = "EaseOut",
        text_blink_rapid_ease_in = "Linear",
        text_blink_rapid_ease_out = "Linear",
        text_blink_rate = 500,
        text_blink_rate_rapid = 250,

        command_palette_rows = 15,
        command_palette_font_size = 15,
        command_palette_bg_color = '#0b031f',
        command_palette_fg_color = '#eba0ac',

        enable_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        show_new_tab_button_in_tab_bar = false,
        tab_bar_at_bottom = true,
        tab_max_width = 26,
        use_fancy_tab_bar = false,
    }
})
