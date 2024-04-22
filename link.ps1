<#
.SYNOPSIS
  Link all exegol files.
.DESCRIPTION
  Part of https://github.com/faabiosr/exegol
.NOTES
  Author: Fabio Ribeiro - faabiosr@gmail.com
#>

#Requires -RunAsAdministrator

param(
	[Parameter(Mandatory = $false, HelpMessage = "Link action")]
	[switch]
	$Undo
)

$Script = "$PSScriptRoot"
$HomeDir = "$script\home"

$excluded = @(".bash*", ".tmux.*")
$Files = Get-ChildItem -Path "$HomeDir" -Attributes !Directory -Recurse -Name -Exclude $excluded

function Link {
	Write-Host "linking files"

	$Files | ForEach-Object {
		Write-Host "=> $_"
		$Target = $(Join-Path $HomeDir $_)
		$Path = $(Join-Path $HOME $_)
		New-Item -ItemType Directory -Path $(Split-Path -Path $Path) -Force | Out-Null
		New-Item -ItemType SymbolicLink -Target $Target -Path $Path -Force | Out-Null
	}
}

function Unlink {
	Write-Host "unlinking files"

	$Files | ForEach-Object {
		Write-Host "=> $_"
		$Path = $(Join-Path $HOME $_)

		if (Test-Path $Path) {
			Remove-Item -Path $Path
		}
	}	
}

($Undo) ? (Unlink) : (Link)
