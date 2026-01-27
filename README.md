# Scriptit

Shell scripts, aliases, and shortcuts to navigate faster and work smarter.

## Quick Start

### 1. Clone the Repository

```bash
git clone git@github.com:naykel76/scriptit.git ~/scriptit
```

### 2. Configure Environment Variables

```bash
cp ~/scriptit/.env.example ~/scriptit/.env
# Edit .env with your personal details
```

### 3. Add Scriptit to Your Shell

Add the following to your `~/.bashrc`:

**First, set your BASE path** (choose based on your environment):

```bash
# Linux / Git Bash
export BASE="$HOME/sites/"

# WSL
export BASE="/mnt/c/Users/YOUR_USERNAME/sites"
```

> **Important:** `$BASE` points to where YOUR projects live. Scriptit itself
> always lives at `$HOME/scriptit` - all scriptit scripts, aliases, and the
> entry point use `$HOME/scriptit`, NOT `$BASE/scriptit`.

**Then, source the scriptit entry point:**

```bash
if [ -f "$HOME/scriptit/bash.sh" ]; then
    source "$HOME/scriptit/bash.sh"
fi
```

### 4. Reload Your Shell

```bash
source ~/.bashrc
```

## WSL-Specific Setup

If you're using Windows Subsystem for Linux, choose one of these options:

### Option A: Clone Directly in WSL (Recommended)

```bash
git clone git@github.com:naykel76/scriptit.git ~/scriptit
```

Then follow steps 2-4 above in your WSL terminal.

### Option B: Symlink to Windows Folder

```bash
# Create symlink to existing Windows scriptit folder
ln -s /mnt/c/Users/YOUR_USERNAME/scriptit ~/scriptit
```

Then follow steps 2-4 above in your WSL terminal.

## Optional Configuration

### Quick Bashrc Editing

Create a symlink to edit `.bashrc` directly from your scriptit folder:

**Windows (PowerShell):**

```powershell
# Requires admin privileges OR Developer Mode enabled
New-Item -ItemType SymbolicLink -Path $HOME\scriptit\bashrc-link -Target $HOME\.bashrc
```

**Linux / Git Bash:**

```bash
ln -s ~/.bashrc ~/scriptit/bashrc-link
```

> **Windows Note:** Enable Developer Mode (Settings → Privacy & Security → For
> Developers) to create symlinks without admin privileges.

## Troubleshooting

### Line Ending Issues

If you encounter `command not found` or `unexpected end of file` errors, fix
line endings:

```bash
bash ~/scriptit/scripts/fix-line-endings.sh
```

This converts CRLF to LF for all `.sh` and `.env` files in your scriptit
directory.

### Common Issues

- **Scripts not found:** Ensure `$BASE` is set correctly and `bash.sh` is being
  sourced in your `~/.bashrc`
- **Permission denied:** Make scripts executable with `chmod +x
  ~/scriptit/scripts/*.sh`
- **Path issues in WSL:** Double-check your Windows username in the `$BASE` path
