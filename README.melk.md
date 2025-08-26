### Melk's Omarchy Manual

This is my personal guide for using and maintaining my Omarchy fork.

### Goals
- **Stable personal config** that is easy to reapply on any machine
- **Clean upstream rebases** with minimal conflicts
- **Idempotent migrations** so setup is repeatable and safe

### Branches and remotes
- `master` tracks upstream; personal work lives on `melk`.
```bash
git remote add upstream <upstream-omarchy-url>
git fetch upstream
# keep local master equal to upstream
git checkout master && git reset --hard upstream/master
# personal branch
git checkout -b melk
```

### Where I put changes
- **Generated vs source**: treat `config/` as generated output. I edit sources under `default/`, `themes/`, and `migrations/` then refresh.
- **Themes**: add/edit under `themes/<name>/`. Switch with:
```bash
bin/omarchy-theme-set <theme>
```
- **Launchers**: `.desktop` files under `applications/`. Then:
```bash
bin/omarchy-refresh-applications
```
- **Personal scripts**: prefix with `bin/melk-*` to avoid upstream conflicts.
- **Packages**: keep personal additions in `install/config/packages.melk.sh` (sourced by `install/packages.sh` or via a tiny include I maintain).

### Day-to-day workflow
1) Edit source files (`default/*`, `themes/*`, `bin/melk-*`, `migrations/*`).
2) Refresh live config (pick the ones I changed):
```bash
bin/omarchy-refresh-config
bin/omarchy-refresh-waybar
bin/omarchy-refresh-hyprland
bin/omarchy-refresh-hypridle
bin/omarchy-refresh-hyprlock
bin/omarchy-refresh-hyprsunset
bin/omarchy-refresh-walker
bin/omarchy-refresh-swayosd
```
3) Restart services if needed:
```bash
bin/omarchy-restart-waybar
bin/omarchy-restart-hypridle
bin/omarchy-restart-swayosd
```
4) Run migrations if I added/changed them:
```bash
bin/omarchy-migrate
```

### Migrations: how I structure them
- Create with:
```bash
bin/omarchy-dev-add-migration "short-title"
```
- Make each migration idempotent and host-aware. Use `bin/omarchy-state` and `hostnamectl` to branch by machine.
- Keep secrets out of the repo; read from `~/.config/omarchy/secrets.env` (git-ignored) if needed.

### Host- and profile-specific config
- Use simple host gating in migrations, e.g.:
```bash
HOST="$(hostname)"
case "$HOST" in
  melk-laptop)   # laptop-specific steps
    ;;
  melk-desktop)  # desktop-specific steps
    ;;
  *)             # defaults
    ;;

esac
```
- Prefer feature flags via `omarchy-state` so behavior is explicit and discoverable.

### Themes and look
- Work inside `themes/<name>/` (CSS, PNG/JPG, `.theme`, tool configs).
- Apply and cycle:
```bash
bin/omarchy-theme-set <name>
bin/omarchy-theme-next
bin/omarchy-theme-update
```

### Onboarding a new machine
```bash
# after cloning my fork
./install.sh
bin/omarchy-cmd-first-run
bin/omarchy-migrate
bin/omarchy-theme-set <my-default-theme>
# refresh key components
bin/omarchy-refresh-config && bin/omarchy-restart-waybar
```

### Upgrading with upstream
```bash
git fetch upstream
# keep personal branch up to date
git checkout melk
git rebase upstream/master
# resolve conflicts (mostly in default/, themes/, migrations/)
bin/omarchy-migrate
# push and update local wrapper
bin/omarchy-update-git
```

### Conventions I follow
- Never hand-edit `config/`; always edit sources and refresh.
- Prefix personal stuff with `melk-` (files, scripts, commits), e.g., "melk: adjust waybar padding".
- Migrations must be safe to re-run and should exit non-zero on real failure.

### Secrets
- Keep secrets outside the repo: `~/.config/omarchy/secrets.env`.
- If needed, use `age`/`git-crypt` and a small bootstrap in a migration to decrypt on setup.

### Routine maintenance
```bash
# Omarchy and system updates
bin/omarchy-update
bin/omarchy-update-system-pkgs
# Quick status helpers
bin/omarchy-update-available
bin/omarchy-version
```

### My customizations
- **Browser**: Google Chrome (installed via migration `1756239768.sh`) replaces default Chromium
- **Cloud storage**: pCloud Drive (installed via migration `1756241229.sh`)
- **Password manager**: KeePass (installed via migration `1756241598.sh`)
- Personal scripts prefixed with `melk-*`

### Troubleshooting quick notes
- Component not updating? Re-run the specific `bin/omarchy-refresh-*` and check logs.
- Waybar weirdness? Restart it and check for CSS errors.
- Post-rebase config drift? Re-apply theme and rerun migrations.

---
I keep this file as the single source of truth for my workflow. If something changes, I update it here first.
