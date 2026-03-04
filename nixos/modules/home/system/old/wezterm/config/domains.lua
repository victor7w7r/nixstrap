return {
    ssh_domains = {
        {
            name = 'wsl.ssh',
            remote_address = 'localhost',
            multiplexing = 'None',
            default_prog = { 'zsh', '-l' },
            assume_shell = 'Posix'
        }
    },

    unix_domains = {},
}
