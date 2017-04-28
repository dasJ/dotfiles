# dotfiles

These are my dotfiles, committed for everybody (and me).

Feel free to use them as template for your own dotfiles, but remember: **Those are my dotfiles. Be creative yourself. You don't want my crap, you want your own.**

Note to self:
`.zshenv` → [`.zprofile` if login] → [`.zshrc` if interactive] → [`.zlogin` if login] → [session] → [`.zlogout` sometimes]`

## Installation
	git clone --recursive https://github.com/dasJ/dotfiles.git ~/.dotfiles
	~/.dotfiles/install.sh

## Directories

- `bin/` - Helper scripts, not supposed to be added to $PATH
- `gpg/` - GPG configuration
- `local/` - Local configuration, excluded from git
- `misc/` - Single configuration files
- `systemd/` - systemd user units
- `tmux/` - tmux configuration and plugin manager
- `util/` - git smudge and clean filters for this repo
- `vim/` - vim configuration and plugin manager
- `x11/` - Configuration for graphical tools
- `zsh/` - zsh configuration and plugin manager

## systemd user units

```
+------------------+ +-----------------+
|                  | |                 |
| graphical.target | | headless.target |
|                  | |                 |
+--------+---------+ +--------------+--+
         |                          |
         |   +--------------+       |
         |   |              |       |
         +-->| basic.target |<------+
             |              |
             +------+-------+
                    |
         +----------+
         v
+-------------------+
|                   |
| ssh-agent.service |
|                   |
+-------------------+
```
