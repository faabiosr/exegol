<#
.SYNOPSIS
  Link script
.DESCRIPTION
  Part of https://github.com/faabiosr/exegol
.NOTES
  Author: Fabio Ribeiro - faabiosr@gmail.com
#>

param(
    [switch]$undo
)

$files = @(
    '.config\nvim\init.vim',
    'AppData\Local\OhMyPosh\exegol.json',
    'AppData\Local\PS\profile.ps1',
    'scoop\apps\windows-terminal\current\settings\settings.json'
)

$script ="$PSScriptRoot"
$homeDir = "$script\home"

if ($undo) {
    Write-Host "unlinking files"
    foreach ($file in $files) {
        Write-Host "=> $file"
        if (Test-Path "$HOME\$file") {
            Remove-Item -Path "$HOME\$file"
        }
    }

    # Remove profile link.
    Remove-Item -Path $profile

    return
}

Write-Host "linking files"
foreach ($file in $files) {
    Write-Host "=> $file"
    New-Item -ItemType Directory -Path (Split-Path -Path "$HOME\$file") -Force | Out-Null
    New-Item -ItemType SymbolicLink -Path "$HOME\$file" -Target "$homeDir\$file" -Force | Out-Null
}

# Setup profile
if (!(Test-Path $profile)) {
    ". $HOME\AppData\Local\PS\profile.ps1" | Out-File $profile -Force
}
