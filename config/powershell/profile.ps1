# PowerShell profile - dotfiles
# 由 scripts/bootstrap.ps1 链接到 $PROFILE

# UTF-8 输出（对齐 zshrc 的 LANG=en_US.UTF-8）
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# zoxide：z 目录跳转（跨 zsh/bash/powershell 统一）
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# fzf：Ctrl+t 文件模糊选择，Ctrl+r 历史反向搜索（对齐 zsh 的 fzf 插件）
if ((Get-Command fzf -ErrorAction SilentlyContinue) -and (Get-Module -ListAvailable PSFzf)) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Git alias（对齐 zshrc / 旧本机 profile）
# gl/gcm/gci 与 PowerShell 内置别名冲突（优先级高于函数），需先移除
Remove-Item Alias:gl, Alias:gcm, Alias:gci -Force -ErrorAction SilentlyContinue
Set-Alias g git
function ga { git add @args }
function gaa { git add . }
function gst { git status @args }
function gs { git status @args }
function gco { git checkout @args }
function gbr { git branch @args }
function gci { git commit --verbose @args }
function gcm { git commit -m @args }
function gpl { git pull @args }
function gp { git push @args }
function gd { git diff @args }
function gds { git diff --staged @args }
function gdc { git diff --cached @args }
function gdt { git difftool --no-prompt @args }
function gsw { git switch @args }
function gl { git log --oneline @args }
function gls { git log --stat -n 5 @args }
function glg { git log --graph --oneline --all @args }
function glo { git log --oneline -n 15 @args }
function glast { git log -1 HEAD @args }
function gg1 { git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%cr)%C(reset) %C(white)%s%C(reset) %C(bold white)— %cn%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative @args }
function gg2 { git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%cD%C(reset) %C(bold green)(%cr)%C(reset)%C(bold yellow)%d%C(reset)%n'' %C(white)%s%C(reset) %C(bold white)— %cn%C(reset)' --abbrev-commit @args }
function gunstage { git reset HEAD -- @args }
function gamend { git commit --amend --verbose @args }
function gsetup { git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD` @args }

# conda（有 miniconda 才初始化，PS 5.1/7 通用）
if (Test-Path "F:\Program Files\miniconda3\Scripts\conda.exe") {
    (& "F:\Program Files\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Where-Object { $_ } | Invoke-Expression
}
