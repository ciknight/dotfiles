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

# rmux web-share 局域网一键分享
# 用法: rshare [-Session 名] [-Ttl 秒] [-Ip 手动指定IP]  启动
#       rshare -Stop                                 停止并清理
function rshare {
    param(
        [string]$Session = "share-$(Get-Date -Format 'HHmmss')",
        [int]$Ttl = 3600,
        [switch]$Stop,
        [string]$Ip   # 自动探测不准时手动指定局域网 IP
    )
    if ($Stop) {
        rmux web-share off 2>$null
        netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=9777 2>$null | Out-Null
        Remove-NetFirewallRule -DisplayName 'rmux web-share' -ErrorAction SilentlyContinue
        Write-Host '  已停止分享并清理端口转发/防火墙规则' -ForegroundColor Green
        return
    }

    # portproxy/防火墙需要管理员
    $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host '  需要管理员权限（portproxy/防火墙），请用管理员 PowerShell 运行' -ForegroundColor Red
        return
    }

    # 会话不存在则创建
    rmux has-session -t $Session 2>$null
    if ($LASTEXITCODE -ne 0) { rmux new-session -d -s $Session }

    # 启动分享并抓取链接/PIN
    $out = rmux web-share -t $Session --ttl $Ttl 2>&1 | Out-String
    $spectator = [regex]::Match($out, 'spectator (https://\S+)').Groups[1].Value
    $operator  = [regex]::Match($out, 'rmux:\s+(https://\S+)').Groups[1].Value
    $spPin = [regex]::Match($out, 'spectator pin (\d+)').Groups[1].Value
    $opPin = [regex]::Match($out, 'operator pin (\d+)').Groups[1].Value
    if (-not $spectator) { Write-Host $out -ForegroundColor Red; return }

    # daemon 监听端口（默认 9777）
    $port = [regex]::Match((rmux web-share config), ':(\d+)').Groups[1].Value
    if (-not $port) { $port = 9777 }

    # 端口转发 + 防火墙（幂等）
    netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$port 2>$null | Out-Null
    netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$port connectaddress=127.0.0.1 connectport=$port | Out-Null
    if (-not (Get-NetFirewallRule -DisplayName 'rmux web-share' -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName 'rmux web-share' -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow | Out-Null
    }

    # 探测局域网 IP：排除回环/APIPA/虚拟网卡（vEthernet = WSL/Hyper-V）
    if (-not $Ip) {
        $Ip = (Get-NetIPAddress -AddressFamily IPv4 |
            Where-Object {
                $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' -and
                $_.InterfaceAlias -notlike 'vEthernet*' -and $_.InterfaceAlias -notlike 'Loopback*'
            } | Select-Object -First 1).IPAddress
    }

    $endpoint = "ws://${Ip}:${port}/share"
    Write-Host ''
    Write-Host "  局域网 IP: $Ip  端口: $port  会话: $Session  有效期: $([TimeSpan]::FromSeconds($Ttl))" -ForegroundColor Cyan
    $spUrl = $spectator.Replace('#t=', "#e=$endpoint&t=")
    $opUrl = $operator.Replace('#t=', "#e=$endpoint&t=")
    Write-Host "  只读 spectator（PIN $spPin）:" -ForegroundColor Green
    Write-Host "    $spUrl"
    Write-Host "  读写 operator（PIN $opPin，勿外传）:" -ForegroundColor Yellow
    Write-Host "    $opUrl"
    Write-Host ''
    Write-Host '  停止: rshare -Stop' -ForegroundColor DarkGray
}
