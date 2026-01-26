# scriptit

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

**5. (Optional) Create bashrc symlink for easy editing:**

> **Note:** On Windows, enable Developer Mode in Settings → Privacy & Security → For developers to create symlinks without admin privileges.

```bash
# PowerShell (requires admin if Developer Mode not enabled)
New-Item -ItemType SymbolicLink -Path $HOME\scriptit\bashrc-link -Target $HOME\.bashrc

# Bash (requires Developer Mode enabled on Windows)
ln -s ~/.bashrc ~/scriptit/bashrc-link
```
