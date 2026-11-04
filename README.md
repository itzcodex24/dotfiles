<h1 align="center">
  ~/.&nbsp;📂<br/>
  dotfiles<br/>
  <sub><sup>managed with <a href="https://www.chezmoi.io/">chezmoi</a></sup></sub>
</h1>

My macOS dev setup: Neovim, tmux, Ghostty, zsh, lazygit and Claude Code. Feel free to take whatever's useful.

## What's in here

| Path | What it is |
| --- | --- |
| `.config/nvim/` | Neovim 0.12+ config built on the native `vim.pack` manager (no LazyVim). It lives in `lua/codex/` and uses catppuccin, blink.cmp, treesitter, mini.diff, snacks, conform, Discord presence and a custom `codex` dashboard. It also runs on Windows. |
| `.tmux.conf` | `C-a` prefix, vim-style panes, catppuccin (frappe) theme, resurrect/continuum. `prefix + Enter` toggles a Claude pane. |
| `.config/tmux/claude-toggle.sh` | Opens a 35% Claude Code pane on the right, one per directory. Hidden panes keep running in a `_claude` session. |
| `.config/ghostty/config` | Catppuccin Frappé palette, Fira Code, hidden titlebar, quick terminal on `cmd+b t`. |
| `.zshrc` | oh-my-zsh + starship + zoxide + fzf and a lot of aliases. |
| `.config/starship.toml` | Prompt. |
| `.config/lazygit/config.yml` | delta pager. `C` runs commitizen; `ctrl+g` commits through Claude's `/commit` skill. |
| `.config/zed/` | Zed settings, keymap and tasks. |
| `.config/herdr/config.toml` | herdr config (an experiment at replacing tmux). |
| `.claude/settings.json` | Claude Code settings: plugins, hooks, theme, no commit attribution. |
| `.claude/skills/commit/` | `/commit` skill for conventional commits with a Jira key taken from the branch name. |
| `.claude/commands/review.md` | `/review <pr>`: runs a critic review and turns it into short, human-sounding PR comments. |
| `.local/bin/dots` | The helper script for keeping this repo in sync (see below). |
| `Brewfile` | Everything installed through Homebrew. |

## Install on a new machine

```sh
# 1. Homebrew + chezmoi
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# 2. pull and apply the dotfiles
chezmoi init --apply itzcodex24

# 3. install everything else
brew bundle --file="$(chezmoi source-path)/Brewfile"

# 4. tmux plugins (then prefix + I inside tmux)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

You'll also want [oh-my-zsh](https://ohmyz.sh/). Neovim installs its own plugins on first launch.

> Want just one piece? Copy the file you need, e.g. `.config/nvim/` → `~/.config/nvim/`.
> `chezmoi apply` **overwrites** the matching files in your home directory. Run `chezmoi diff` first if you're trying it on an existing setup.

## Windows

Only the cross-platform parts get applied: nvim, lazygit, starship and Claude Code. The Mac-only files are skipped.

```powershell
winget install twpayne.chezmoi Neovim.Neovim JesseDuffield.lazygit Starship.Starship
chezmoi init --apply itzcodex24
```

The first apply sets the user env var `XDG_CONFIG_HOME=%USERPROFILE%\.config`, so Neovim reads `~\.config\nvim` (not `%LOCALAPPDATA%\nvim`). Open a new terminal afterwards. `dots` is a shell script, so on Windows use chezmoi directly:

```powershell
chezmoi update                          # pull + apply
chezmoi re-add; chezmoi add ~/.config/nvim
chezmoi git -- add -A; chezmoi git -- commit -m "..."; chezmoi git -- push
```

## Keeping it in sync

Day to day I edit the real files (`~/.config/nvim/...`, `~/.tmux.conf`, ...) and run:

```sh
dots status          # what changed locally vs the repo
dots push            # capture changes, commit, push
dots push "feat(nvim): add oil.nvim"   # same, with a commit message
dots pull            # on another machine: pull + apply
dots add ~/.config/foo   # start tracking something new
```

`dots push` runs `chezmoi re-add`. It also picks up new files in `~/.config/nvim` and `~/.claude/{skills,commands}` and refreshes the `Brewfile`.

## Not in here

Anything private or machine-specific is left out on purpose: git identity and signing config, SSH config, work-specific Claude agents, MCP and auth configs, and the Claude skills that are synced from my org or vendored from other tools.
