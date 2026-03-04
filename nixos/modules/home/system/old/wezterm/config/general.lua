local wezterm = require 'wezterm'
local gpu_adapters = require 'utils.gpu-adapter'
local platform = require 'utils.platform'
local tables = require 'utils.tables'

local gpu = {}
local fonts = {}

if platform.is_mac then
    gpu.front_end = 'WebGpu'
elseif platform.is_linux then
    gpu.enable_wayland = false
    gpu.prefer_egl = true
    gpu.front_end = 'OpenGL'
else
    gpu.front_end = 'OpenGL'
end

if platform.is_win then
    fonts.font = wezterm.font({
        family = 'JetBrainsMono Nerd Font Mono',
        weight = 'Medium',
    })
    fonts.window_frame = {
        inactive_titlebar_bg = "none",
        active_titlebar_bg = "none",
        font = wezterm.font({ family = "JetBrainsMono Nerd Font Mono", weight = "Bold" })
    }
else
    fonts.font = wezterm.font({
        family = 'JetBrainsMono Nerd Font',
        weight = 'Medium',
    })
    fonts.window_frame = {
        inactive_titlebar_bg = "none",
        active_titlebar_bg = "none",
        font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Bold" })
    }
end

if platform.is_mac then
    fonts.font_size = 14
else
    fonts.font_size = 10
end

return tables.merge({
    gpu,
    fonts,
    {
        automatically_reload_config = true,
        exit_behavior = 'CloseOnCleanExit',
        exit_behavior_messaging = 'Verbose',
        warn_about_missing_glyphs = false,
        scrollback_lines = 5000,
        status_update_interval = 200,
        check_for_updates = false,
        window_close_confirmation = 'NeverPrompt',

        audible_bell = "SystemBeep",
        visual_bell = {
            fade_in_function = "EaseOut",
            fade_in_duration_ms = 250,
            fade_out_function = "EaseIn",
            fade_out_duration_ms = 250,
            target = 'CursorColor'
        },

        animation_fps = 60,
        max_fps = 60,
        webgpu_force_fallback_adapter = false,
        webgpu_power_preference = "HighPerformance",
        webgpu_preferred_adapter = gpu_adapters:pick_best(),

        freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
        freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'

        hyperlink_rules = {
            { regex = '\\((\\w+://\\S+)\\)',                 format = '$1',       highlight = 1 },
            { regex = '\\[(\\w+://\\S+)\\]',                 format = '$1',       highlight = 1 },
            { regex = '\\{(\\w+://\\S+)\\}',                 format = '$1',       highlight = 1 },
            { regex = '<(\\w+://\\S+)>',                     format = '$1',       highlight = 1 },
            { regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)', format = '$1',       highlight = 1 },
            { regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',     format = 'mailto:$0' }
        }
    }
})
