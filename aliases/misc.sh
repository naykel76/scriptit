#!/usr/bin/env bash

# =============================================================================
# SERVER
# =============================================================================

alias server="powershell.exe /c 'C:\laragon\laragon.exe'"

# =============================================================================
# PROJECT SHORTCUTS
# Opens VS Code and starts opencode in the project directory
# =============================================================================

_opencode() {
    if command -v opencode &>/dev/null; then
        opencode
    else
        echo "Warning: opencode is not installed or not in PATH"
    fi
}

fol() { cdfol && cfol && _opencode; }
fold() { cdfold && cfold && _opencode; }
gotime()  { cdgt && cgt && _opencode; }
jtb() { cdjtb && cjtb && _opencode; }
nk() { cdnk && cnk && _opencode; }
scriptit() { cdscriptit && cscriptit && _opencode; }