local platform = require 'utils.platform'
local tables = require 'utils.tables'

local options = {}
local default_prog = {}
local os_menu = {}

if platform.is_win then
    default_prog = { 'ucrt64.cmd', '-defterm', ' -no-start', '-shell', 'zsh', '-use-full-path' }
    os_menu = {
        { label = 'PowerShell',     args = { 'pwsh', '-NoLogo' } },
        { label = 'Command Prompt', args = { 'cmd' } },
        { label = 'Msys2',          args = { 'ucrt64.cmd', '-defterm', ' -no-start', '-shell', 'zsh', '-use-full-path' } },
    }
elseif platform.is_mac then
    default_prog = { '/usr/local/bin/zsh', '-l' }
elseif platform.is_linux then
    default_prog = { '/bin/zsh', '-l' }
end

options.default_prog = default_prog
options.launch_menu = tables.merge({
    os_menu,
})

return options
