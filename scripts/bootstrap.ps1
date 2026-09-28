#Requires -Version 5.1
<#
.SYNOPSIS
    Windows 初始化入口，对应 scripts/bootstrap.sh。
    可重复运行（幂等）。
#>
$ErrorActionPreference = 'Stop'

$DotfilesRoot = Split-Path -Parent $PSScriptRoot

function Write-Info([string]$Msg) { Write-Host "==> $Msg" -ForegroundColor Cyan }
function Write-Ok([string]$Msg)   { Write-Host "    $Msg" -ForegroundColor Green }

function Link-File([string]$Source, [string]$Target) {
    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            Write-Ok "already linked: $Target"
            return
        }
        $backup = "$Target.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Write-Info "backup: $Target -> $backup"
        Move-Item $Target $backup
    }
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force -ErrorAction Stop | Out-Null
        Write-Ok "linked: $Target -> $Source"
    }
    catch {
        Write-Host "    symlink 失败（需要管理员权限或开启 设置->开发者模式），改为复制" -ForegroundColor Yellow
        Copy-Item $Source $Target
        Write-Ok "copied: $Target"
    }
}

function Install-Software {
    Write-Info 'install software'
    & (Join-Path $PSScriptRoot 'install.ps1')
    Write-Ok 'software'
}

function Setup-Workspace {
    $workspace = Join-Path $HOME 'workspace'
    if (-not (Test-Path $workspace)) {
        Write-Info 'setup workspace'
        New-Item -ItemType Directory -Path $workspace | Out-Null
        Write-Ok 'workspace'
    }
}

function Setup-GitConfig {
    $local = Join-Path $DotfilesRoot 'config\git\gitconfig.local.symlink'
    if (-not (Test-Path $local)) {
        Write-Info 'setup gitconfig'
        $name  = Read-Host '  - What is your github author name?'
        $email = Read-Host '  - What is your github author email?'
        $content = (Get-Content "$local.example" -Raw) `
            -replace 'AUTHORNAME', $name `
            -replace 'AUTHOREMAIL', $email `
            -replace 'GIT_CREDENTIAL_HELPER', 'manager'
        # 写 UTF-8 无 BOM，兼容 git config 解析
        [System.IO.File]::WriteAllText($local, $content)
        Write-Ok 'gitconfig'
    }
}

function Install-Dotfiles {
    Write-Info 'installing dotfiles'

    # git 配置
    Link-File "$DotfilesRoot\config\git\gitconfig.symlink"        "$HOME\.gitconfig"
    Link-File "$DotfilesRoot\config\git\gitconfig.local.symlink"  "$HOME\.gitconfig.local"
    Link-File "$DotfilesRoot\config\git\gitignore.global.symlink" "$HOME\.gitignore.global"
    Link-File "$DotfilesRoot\config\git\gitmessage.symlink"       "$HOME\.gitmessage"

    # PowerShell profile：PS 5.1 与 PS 7 两个路径都链接
    $profileSrc = Join-Path $DotfilesRoot 'config\powershell\profile.ps1'
    foreach ($profileDir in @("$HOME\Documents\WindowsPowerShell", "$HOME\Documents\PowerShell")) {
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        Link-File $profileSrc (Join-Path $profileDir 'Microsoft.PowerShell_profile.ps1')
    }

    # Windows Terminal：已有 settings.json 时不覆盖，提示手动合并
    $wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettings) {
        Write-Host "    Windows Terminal settings.json 已存在，请手动合并 config\windows-terminal\settings.json" -ForegroundColor Yellow
    }
    else {
        $wtDir = Split-Path $wtSettings -Parent
        if (-not (Test-Path $wtDir)) {
            New-Item -ItemType Directory -Path $wtDir -Force | Out-Null
        }
        Link-File (Join-Path $DotfilesRoot 'config\windows-terminal\settings.json') $wtSettings
    }

    Write-Ok 'dotfiles'
}

Install-Software
Setup-Workspace
Setup-GitConfig
Install-Dotfiles

Write-Host ''
Write-Host '  All installed! 请重开 PowerShell 窗口使配置生效。'
