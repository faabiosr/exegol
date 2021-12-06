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
& $(join-path $(scoop prefix oh-my-posh) 'bin\oh-my-posh.exe') --init --shell pwsh --config ~/AppData/Local/OhMyPosh/exegol.json | Invoke-Expression
