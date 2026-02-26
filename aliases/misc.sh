#!/usr/bin/env bash

# =============================================================================
# SERVER
# =============================================================================

alias server="powershell.exe /c 'C:\laragon\laragon.exe'"

# =============================================================================
# PROJECT SHORTCUTS
# Opens VS Code and starts opencode in the project directory
# =============================================================================

fol() { cdfol && cfol && opencode; }
fold() { cdfold && cfold && opencode; }
gotime()  { cdgt && cgt && opencode; }
jtb() { cdjtb && cjtb && opencode; }
nk() { cdnk && cnk && opencode; }
scriptit() { cdscriptit && cscriptit && opencode; }