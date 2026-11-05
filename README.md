<h1 align="center">
  ~/.&nbsp;📂<br/>
  dotfiles<br/>
  <sub><sup>managed with <a href="https://www.chezmoi.io/">chezmoi</a></sup></sub>
</h1>

hey 👋 this is my setup on my mac. it's mostly neovim, tmux and ghostty, plus a bunch of claude code stuff i've been playing with lately. i tweak it pretty much every week so things move around a lot. if you find something you like just grab it.

## what's in here

**neovim** (`.config/nvim/`) is the bit i spend the most time on. i used lazyvim for ages and eventually ripped it out and rebuilt everything on the new built-in `vim.pack` in 0.12. everything lives under `lua/codex/`. catppuccin, blink.cmp, snacks, conform, mini.diff, and yes discord presence because why not. it works on windows too which surprised me a bit.

**tmux** (`.tmux.conf`) has the prefix on `C-a` because `C-b` is a stretch, vim keys for moving between panes and resurrect/continuum so i don't lose sessions on restart. `prefix + Enter` pops a claude code pane open on the right, which is honestly the thing i use most. that's handled by `.config/tmux/claude-toggle.sh`. you get one pane per directory, and when you hide it it keeps running in the background in a `_claude` session.

**ghostty** is catppuccin frappé with fira code, no titlebar, and a quick terminal on `cmd+b t`.

**zsh** is oh-my-zsh, starship, zoxide, fzf and way too many aliases. some of them i don't even remember adding.

**lazygit** uses delta for diffs. `ctrl+g` writes the commit message with claude, which is lazy but i love it.

then there's some random stuff:

- `.config/zed/` because i still open zed every now and then
- `.config/herdr/` from when i tried replacing tmux (didn't stick, yet)
- `.claude/` with my claude code settings, a `/commit` skill and a `/review` command
- `.local/bin/dots`, a tiny script i use to keep this repo in sync (more on that below)
- `Brewfile` with everything i've got installed through brew

## setting up a new mac

```sh
# brew + chezmoi
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# grab the dotfiles and apply them
chezmoi init --apply itzcodex24

# install everything from the Brewfile
brew bundle --file="$(chezmoi source-path)/Brewfile"

# tmux plugins (then prefix + I inside tmux)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

you'll need [oh-my-zsh](https://ohmyz.sh/) as well. neovim sorts its own plugins out the first time you open it.

careful though, `chezmoi apply` will overwrite your existing files. if you've already got your own setup run `chezmoi diff` first, or just copy the folder you want by hand.

## windows

i don't use windows much but sometimes i have to, so the stuff that actually works there (nvim, lazygit, starship, claude code) gets applied and the rest is skipped.

```powershell
winget install twpayne.chezmoi Neovim.Neovim JesseDuffield.lazygit Starship.Starship
chezmoi init --apply itzcodex24
```

the first run sets `XDG_CONFIG_HOME` to `%USERPROFILE%\.config` so nvim reads from `~\.config\nvim` like on mac. you'll need to open a new terminal after. `dots` doesn't work there since it's a shell script, so i just use chezmoi directly:

```powershell
chezmoi update                          # pull + apply
chezmoi re-add; chezmoi add ~/.config/nvim
chezmoi git -- add -A; chezmoi git -- commit -m "..."; chezmoi git -- push
```

## keeping it in sync

i just edit the real files like normal and when i'm happy with something:

```sh
dots status          # what's changed
dots push            # commit + push everything
dots push "feat(nvim): add oil.nvim"   # same but with a proper message
dots pull            # on the other machine
dots add ~/.config/foo   # track something new
```

`dots push` also picks up new files in my nvim and claude folders automatically and refreshes the Brewfile, so i don't forget stuff.

## what's not in here

anything private like my git identity, ssh config, work related stuff and anything with auth in it stays on my machine.
