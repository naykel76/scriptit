# Scriptit

Shell scripts, aliases, and shortcuts to navigate faster and work smarter.

## Setup

**1. Clone the repo:**

```bash
git clone git@github.com:naykel76/scriptit.git ~/scriptit
```

**2. Configure your environment:**

```bash
cp ~/scriptit/.env.example ~/scriptit/.env
# Edit .env with your details
```

**3. Add to `~/.bashrc`:**

```bash
# scriptit entry point
if [ -f "$HOME/scriptit/bash.sh" ]; then
    source "$HOME/scriptit/bash.sh"
fi
```

**4. Reload:**

```bash
source ~/.bashrc
```

## WSL Setup

If using Windows Subsystem for Linux, you can either clone directly in WSL or
symlink to your Windows scriptit folder:

**Option A: Clone in WSL** (recommended)

```bash
# Clone directly in WSL
git clone git@github.com:naykel76/scriptit.git ~/scriptit
```

**Option B: Symlink to Windows folder**

```bash
# Create symlink to Windows scriptit
ln -s /mnt/c/Users/YOUR_USERNAME/scriptit ~/scriptit
```

Then follow steps 3-4 above in your WSL terminal to add to WSL's `~/.bashrc` and
reload.

## Optional: Bashrc Symlink

Create a symlink to quickly edit `.bashrc` from your scriptit folder:

> **Note:** On Windows, enable Developer Mode in Settings → Privacy & Security →
> For developers to create symlinks without admin privileges.

```bash
# PowerShell (requires admin if Developer Mode not enabled)
New-Item -ItemType SymbolicLink -Path $HOME\scriptit\bashrc-link -Target $HOME\.bashrc

# Bash (requires Developer Mode enabled on Windows)
ln -s ~/.bashrc ~/scriptit/bashrc-link
```

## Troubleshooting

**Line ending errors:**

If you see `command not found` or `unexpected end of file` errors, fix line
endings:

```bash
bash ~/scriptit/scripts/fix-line-endings.sh
```

This fixes line endings for all `.sh` and `.env` files in your scriptit
directory.
