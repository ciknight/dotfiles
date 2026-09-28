#Requires -Version 5.1
<#
.SYNOPSIS
    Windows 软件安装，对应 scripts/install.sh 的 Windows 分支。
    统一使用 winget，幂等：已安装的包会被跳过。
#>
$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host 'winget 不存在。请从 Microsoft Store 安装 "App Installer" 或升级 Windows。' -ForegroundColor Red
    exit 1
}

$packages = @(
    'Git.Git',
    'Microsoft.PowerShell',
    'Microsoft.WindowsTerminal',
    'ajeetdsouza.zoxide',
    'Neovim.Neovim',      # gitconfig editor = 'nvim'
    'JesseDuffield.lazygit',
    'junegunn.fzf',
    'BurntSushi.ripgrep.MSVC'  # rg，替代 ag（the_silver_searcher 上游停更）
)

$failed = @()
foreach ($pkg in $packages) {
    Write-Host "==> winget install $pkg" -ForegroundColor Cyan
    winget install --id $pkg --exact --silent --disable-interactivity `
        --accept-source-agreements --accept-package-agreements
    # winget 是原生 exe，ErrorActionPreference='Stop' 拦不住非零退出码，需手动检查。
    # "已安装"的退出码随版本不同，不可靠；用 winget list 二次确认是否真的没装上。
    if ($LASTEXITCODE -ne 0) {
        winget list --id $pkg --exact --disable-interactivity *> $null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    already installed: $pkg" -ForegroundColor Yellow
        }
        else {
            $failed += $pkg
        }
    }
}

if ($failed.Count -gt 0) {
    Write-Host "  以下软件安装失败: $($failed -join ', ')" -ForegroundColor Red
    exit 1
}

# PSFzf 模块（profile.ps1 的 fzf 集成依赖，winget 装不到）
if (-not (Get-Module -ListAvailable PSFzf)) {
    Write-Host '==> Install-Module PSFzf' -ForegroundColor Cyan
    Install-Module PSFzf -Scope CurrentUser -Force
}

Write-Host '  software installed.'
