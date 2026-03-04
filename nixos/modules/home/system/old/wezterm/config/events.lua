local wezterm = require 'wezterm'
--local platform = require 'utils.platform'

local M = {}

M.setup = function()
    wezterm.on("gui-startup", function(cmd)
        local ratio = 0.8
        local screen = wezterm.gui.screens().active
        local width, height = screen.width * ratio, screen.height * ratio
        local window = wezterm.mux.spawn_window {
            position = {
                x = (screen.width - width) / 2,
                y = (screen.height - height) / 2,
                origin = 'ActiveScreen'
            }
        }
        window:window():gui_window():set_inner_size(width, height)
    end)
end

M.setup_title = function()
    local cached_title = ""
    ------------------------------------------
    -- local tmux_route = ""                --
    --  --
    -- local count = 0                      --
    --  --
    -- if platform.is_mac then              --
    --   tmux_route = "/usr/local/bin/tmux" --
    -- else                                 --
    --   tmux_route = "/usr/bin/tmux"       --
    -- end                                  --
    ------------------------------------------

    wezterm.on("format-window-title", function()
        return cached_title ~= "" and cached_title or "Terminal (/>w<)/ ..."
    end)

    ---------------------------------------------------------------------
    -- wezterm.on('update-status', function()                          --
    --   local success, stdout = wezterm.run_child_process {           --
    --     tmux_route,                                                 --
    --     "list-panes",                                               --
    --     "-F",                                                       --
    --     "#{?pane_active,#{pane_pid},}"                              --
    --   }                                                             --
    --  --
    --   if success then                                               --
    --     local pid = stdout:gsub("%s+", "")                          --
    --     if pid ~= "" then                                           --
    --       local ps_success, ps_stdout = wezterm.run_child_process { --
    --         '/usr/local/bin/foregroundsh',                          --
    --         pid                                                     --
    --       }                                                         --
    --       if ps_success then                                        --
    --         local cmd = ps_stdout                                   --
    --         :gsub("^%s+", "")                                       --
    --         :gsub("%s+$", "")                                       --
    --         :sub(6)                                                 --
    --         cached_title = "(/>w<)/ ... " .. cmd                    --
    --         return                                                  --
    --       end                                                       --
    --     end                                                         --
    --   end                                                           --
    --   cached_title = "(/>w<)/ ..."                                  --
    -- end)                                                            --
    ---------------------------------------------------------------------
end

return M
