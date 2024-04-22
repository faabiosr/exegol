<#
.SYNOPSIS
  Powershell Profile
.DESCRIPTION
  Part of https://github.com/faabiosr/exegol
.NOTES
  Author: Fabio Ribeiro - faabiosr@gmail.com
#>

# Aliases
Set-Alias vim "$(scoop prefix neovim)\bin\nvim.exe"
Set-Alias godoc "godoc -http='127.0.0.1:6060'"
Set-Alias ff "firefox"

# Functions

# Generates an uuid.
function UUID {
    [guid]::NewGuid().ToString()
}

# Generates an uuid and send to clipboard.
function UUIDP {
    [guid]::NewGuid().ToString() | Set-Clipboard
}

# Init oh-my-posh
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/exegol.json" | Invoke-Expression
