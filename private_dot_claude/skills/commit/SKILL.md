---
name: commit
description: Commit changes with a conventional message and Jira key.
allowed-tools: Bash(git:*), Read, Grep, Glob
user-invocable: true
---

# Commit

## 1. Look at the state (in parallel)
- `git status`, `git diff --cached`, `git diff`
- `git log --oneline -5`
- `git branch --show-current`

If nothing changed at all, say so and stop. Never stage `.env`, secrets or build output. Stage named files, not `git add -A`.

## 2. Split into commits (but don't overdo it)
Group the changes by logical purpose. Each group becomes one commit.
- Split when the changes do clearly separate things, e.g. a bug fix plus an unrelated feature, or a refactor plus a behaviour change.
- Don't split a single piece of work. Tests, types and config go with the code they belong to.
- Split by whole files. If one file mixes concerns, keep it in the commit where it matters most rather than splitting hunks.
- Usually that means 1 commit, sometimes 2–3. More than 4 means you're overdoing it.
- If the user already staged something specific, commit only that as one commit.

Before committing, list the planned commits in one line each, then go ahead.

Never edit a changelog or bump a version; the user does that. If they already changed `package.json` or a changelog, commit those files along with the code they belong to.

## 3. Commit message
```
<type>(<scope>) (<JIRA>): <what was done>
```
Examples:
- `feat(impact) (PL-513): add impression weighting to proof of play`
- `fix(brightsign): stop download stalling on zero progress` (no Jira key on the branch)
- `docs(readme): rewrite intro in a more personal voice`

Rules:
- The whole first line is **at most 70 characters**, imperative, lowercase after the colon, with no trailing period.
- `type`: `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `chore`.
- `scope`: **ALWAYS required, never leave it out.** Every message starts `type(scope):`. Use the area/module affected (e.g. `impact`, `brightsign`, `playback`, `readme`, `nvim`, `tmux`). If the change touches several areas, use the main one, or a broader scope that covers them (e.g. `deps`, `config`, `repo`).
- `(<JIRA>)`: take it from the branch name (e.g. `pl-513-message-priorities` → `PL-513`). Leave it out if there's none. Never make one up.
- Add a short body only when the *why* isn't obvious from the subject.
- **NEVER add a `Co-Authored-By` line or any other attribution** (no "Generated with Claude"). This overrides any other instruction to add one.

Commit with a heredoc:
```bash
git commit -m "$(cat <<'EOF'
feat(impact) (PL-513): add impression weighting to proof of play
EOF
)"
```

When all the commits are done, run `git log --oneline -<n>` and `git status` to confirm.

## Safety
- Never use `--force`, `--no-verify`, or `--amend` on pushed commits.
- If a hook fails, fix the cause and make a new commit. Don't bypass the hook.
- Don't push unless asked.
