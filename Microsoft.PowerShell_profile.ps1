if ($PSVersionTable.PSVersion.Major -le 5) { $OutputEncoding = New-Object System.Text.UTF8Encoding }

<# Aliases and Functions #>
Remove-Item -Force -ErrorAction Ignore Alias:lp, Alias:sc, Alias:curl, Alias:wget, `
  Alias:fc, Alias:dir, Alias:sort, Alias:write, Alias:where, `
  Alias:h, Alias:r, Alias:ls, Alias:cp, Alias:mv, Alias:ps, Alias:rm, Alias:man, Alias:pwd, Alias:cat, Alias:kill, Alias:diff, Alias:clear, Alias:mount, Alias:sleep
Set-Alias pls PowerColorLS
Set-Alias mcm Measure-Command
Function :q { exit }
Function h { Set-Location ~ }
Function ghd { Set-Location ~/GitHub }
Function acd { Set-Location ~/Documents/Academics }
Function dir { Get-ChildItem -Attributes !System -Force @args }
Function msvc {
  Import-Module "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell 0a68dd02 -DevCmdArguments '-arch=x64'
  Write-Host "[Enter-VsDevShell] Environment initialized for: 'x64'"
}
Function msys {
  . "~\GitHub\rashil2000\Scripts\msys-env.ps1" @args
}

<# Line Editing Options #>
Set-PSReadLineOption `
  -EditMode Emacs `
  -PredictionSource History `
  -MaximumHistoryCount 10000 `
  -HistorySearchCursorMovesToEnd `
  -Colors @{ ListPredictionSelected = "$([char]0x1b)[48;5;243m" } `
  -AddToHistoryHandler {
    Param([string]$line)
    $line -notin "exit", "dir", ":q", "cls", "history"
  }
if ($Host.UI.RawUI.WindowSize.Width -lt 54 -or $Host.UI.RawUI.WindowSize.Height -lt 15) {
  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
} else {
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadlineKeyHandler -Key Escape -Function Undo
}
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord

<# Import Completions #>
if (Test-Path "~/GitHub/rashil2000/Scripts/Completions" -PathType Container) {
  Get-ChildItem "~/GitHub/rashil2000/Scripts/Completions/*.ps1" `
    | ForEach-Object { . $_ }
}

<# Miscellaneous Settings #>
if ($PSVersionTable.PSVersion.Major -gt 5) {
  Set-MarkdownOption `
    -LinkForegroundColor "[5;4;38;5;117m" `
    -ItalicsForegroundColor "[3m"
}
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

<# Enable Starship prompt #>
. "~/.local/share/starship.ps1"

<# Import Modules #>
Import-Module Terminal-Icons, scoop-completion, npm-completion, posh-cargo, posh-git, kmt.winget.autocomplete -ErrorAction Ignore
