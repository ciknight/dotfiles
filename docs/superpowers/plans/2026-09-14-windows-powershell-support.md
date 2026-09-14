# Windows PowerShell 支持实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 为 dotfiles 项目新增 Windows 支持：winget 安装软件、PowerShell profile（zoxide `z` 跳转）、Windows Terminal 分屏配置，并让 zoxide 同时接入 zsh。

**Architecture:** 沿用现有 `*.symlink` + bootstrap 模式，新增 Windows 平行的 `install.ps1` / `bootstrap.ps1`；配置全部放 `config/` 下通过符号链接生效。设计文档：`docs/superpowers/specs/2026-09-14-windows-powershell-support-design.md`

**Tech Stack:** PowerShell 5.1+ / 7、winget、zoxide、Windows Terminal、zsh

**验证环境说明：** 本机是 Windows，PowerShell 脚本可直接运行验证；shell 脚本改动用 `bash -n` 做语法检查（Git Bash 可用），完整验证留待 Mac/Linux。

---

### Task 1: PowerShell profile

**Files:**
- Create: `config/powershell/profile.ps1`

- [ ] **Step 1: 创建 profile**

创建 `config/powershell/profile.ps1`：

```powershell
# PowerShell profile - dotfiles
# 由 scripts/bootstrap.ps1 链接到 $PROFILE

# UTF-8 输出（对齐 zshrc 的 LANG=en_US.UTF-8）
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# zoxide：z 目录跳转（跨 zsh/bash/powershell 统一）
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Git alias（对齐 zshrc）
Set-Alias g git
function gs { git status @args }
```

- [ ] **Step 2: 验证 profile 可加载**

Run: `powershell -NoProfile -Command ". F:\code\dotfiles\config\powershell\profile.ps1; Get-Alias g; Get-Command gs"`
Expected: 无报错；`g -> git`；`gs` 为 Function（zoxide 未安装时跳过不报错）

- [ ] **Step 3: Commit**

```bash
git add config/powershell/profile.ps1
git commit -m "feat: add PowerShell profile with zoxide and git aliases"
```

---

### Task 2: Windows 软件安装脚本

**Files:**
- Create: `scripts/install.ps1`

- [ ] **Step 1: 创建 install.ps1**

创建 `scripts/install.ps1`：

```powershell
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
    'ajeetdsouza.zoxide'
)

foreach ($pkg in $packages) {
    Write-Host "==> winget install $pkg" -ForegroundColor Cyan
    winget install --id $pkg --exact --silent --disable-interactivity `
        --accept-source-agreements --accept-package-agreements
}

Write-Host '  software installed.'
```

- [ ] **Step 2: 运行验证**

Run: `powershell -ExecutionPolicy Bypass -File F:\code\dotfiles\scripts\install.ps1`
Expected: 4 个包依次安装或提示 "Found an existing package already installed"；结束后 `powershell -Command "Get-Command zoxide, git"` 均能找到

- [ ] **Step 3: Commit**

```bash
git add scripts/install.ps1
git commit -m "feat: add Windows install script using winget"
```

---

### Task 3: Windows bootstrap 脚本

**Files:**
- Create: `scripts/bootstrap.ps1`

- [ ] **Step 1: 创建 bootstrap.ps1**

创建 `scripts/bootstrap.ps1`：

```powershell
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
    elseif (Test-Path (Split-Path $wtSettings -Parent)) {
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
```

- [ ] **Step 2: 运行验证（跑两次验证幂等）**

Run: `powershell -ExecutionPolicy Bypass -File F:\code\dotfiles\scripts\bootstrap.ps1`（连续执行两次）
Expected: 第一次输出 linked/copied；第二次全部显示 `already linked`；两次均无红色报错

- [ ] **Step 3: 验证链接结果**

Run: `powershell -Command "Get-Item $HOME\.gitconfig | Select-Object LinkType, Target"`
Expected: `LinkType` 为 `SymbolicLink`，`Target` 指向 dotfiles 仓库内文件（若回退为复制则无 LinkType，可接受）

- [ ] **Step 4: Commit**

```bash
git add scripts/bootstrap.ps1
git commit -m "feat: add Windows bootstrap script"
```

---

### Task 4: Windows Terminal 配置

**Files:**
- Create: `config/windows-terminal/settings.json`

- [ ] **Step 1: 创建 settings.json**

创建 `config/windows-terminal/settings.json`（分屏键用 WT 官方支持的 `minus`/`plus` 键名，即设计文档中的 `Alt+Shift+-` / `Alt+Shift+\` 意图）：

```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "defaultProfile": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
    "copyOnSelect": true,
    "schemes": [
        {
            "name": "Gruvbox Dark",
            "background": "#282828",
            "foreground": "#EBDBB2",
            "cursorColor": "#EBDBB2",
            "selectionBackground": "#504945",
            "black": "#282828",
            "red": "#CC241D",
            "green": "#98971A",
            "yellow": "#D79921",
            "blue": "#458588",
            "purple": "#B16286",
            "cyan": "#689D6A",
            "white": "#A89984",
            "brightBlack": "#928374",
            "brightRed": "#FB4934",
            "brightGreen": "#B8BB26",
            "brightYellow": "#FABD2F",
            "brightBlue": "#83A598",
            "brightPurple": "#D3869B",
            "brightCyan": "#8EC07C",
            "brightWhite": "#EBDBB2"
        }
    ],
    "profiles": {
        "defaults": {
            "colorScheme": "Gruvbox Dark",
            "font": { "face": "Cascadia Mono" }
        }
    },
    "actions": [
        { "command": { "action": "splitPane", "split": "horizontal" }, "keys": "alt+shift+minus" },
        { "command": { "action": "splitPane", "split": "vertical" },   "keys": "alt+shift+plus" },
        { "command": "closePane", "keys": "ctrl+shift+w" },
        { "command": { "action": "moveFocus", "direction": "left"  }, "keys": "alt+h" },
        { "command": { "action": "moveFocus", "direction": "down"  }, "keys": "alt+j" },
        { "command": { "action": "moveFocus", "direction": "up"    }, "keys": "alt+k" },
        { "command": { "action": "moveFocus", "direction": "right" }, "keys": "alt+l" }
    ]
}
```

（`{574e775e-4f2a-5b96-ac1e-a2962a402336}` 是 PowerShell 7 的固定 GUID）

- [ ] **Step 2: 验证 JSON 合法**

Run: `powershell -Command "Get-Content F:\code\dotfiles\config\windows-terminal\settings.json -Raw | ConvertFrom-Json | Out-Null; Write-Host 'JSON OK'"`
Expected: 输出 `JSON OK`

- [ ] **Step 3: Commit**

```bash
git add config/windows-terminal/settings.json
git commit -m "feat: add Windows Terminal settings with Gruvbox Dark and pane keybindings"
```

---

### Task 5: install.sh 各平台安装 zoxide

**Files:**
- Modify: `scripts/install.sh`

- [ ] **Step 1: brew 分支加 zoxide**

修改 `scripts/install.sh:16`：

```sh
    brew install htop lazygit ipcalc cloc tig jq wget ncdu zoxide
```

- [ ] **Step 2: apt 分支加 zoxide**

在 `scripts/install.sh` 的 `sudo apt install -y git zsh tmux vim neovim`（第 50 行）之后插入：

```sh
        # zoxide: z 目录跳转；老版本 apt 源没有时回退官方安装脚本
        if apt-cache show zoxide >/dev/null 2>&1; then
            sudo apt install -y zoxide
        else
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
        fi
```

- [ ] **Step 3: 语法检查**

Run: `bash -n scripts/install.sh && echo OK`
Expected: 输出 `OK`（完整安装验证留待 Mac/Linux 或 `scripts/test_from_docker.sh`）

- [ ] **Step 4: Commit**

```bash
git add scripts/install.sh
git commit -m "feat: install zoxide on macOS(brew) and Linux(apt)"
```

---

### Task 6: zshrc 接入 zoxide

**Files:**
- Modify: `config/zsh/zshrc.symlink`（文件末尾追加）

- [ ] **Step 1: 追加 zoxide 初始化**

在 `config/zsh/zshrc.symlink` 末尾（`export PATH="/home/whnzy/.local/bin:$PATH"` 之后）追加：

```sh

# Zoxide: smarter cd (z command), 与 PowerShell 端统一
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
```

注：zoxide 通过 `chpwd` 钩子记录目录，与文件里自定义的 `cd` 函数（内部走 `builtin cd`）不冲突。

- [ ] **Step 2: 语法检查**

Run: `bash -n config/zsh/zshrc.symlink && echo OK`
Expected: 输出 `OK`（zsh 专有语法如 `setopt`/`zle` 在 `bash -n` 下会报错属正常——若报错，改用肉眼核对追加段落即可，追加段本身为 POSIX 兼容）

- [ ] **Step 3: Commit**

```bash
git add config/zsh/zshrc.symlink
git commit -m "feat: init zoxide in zshrc when available"
```

---

### Task 7: 修复 gitconfig 硬编码 Mac 路径

**Files:**
- Modify: `config/git/gitconfig.symlink:37`

- [ ] **Step 1: 修改 excludesfile**

`excludesfile = /Users/andywang/.gitignore.global` 改为（git 支持 `~` 展开，三端通用）：

```
    excludesfile = ~/.gitignore.global
```

- [ ] **Step 2: 验证**

Run: `git config --file config/git/gitconfig.symlink core.excludesfile`
Expected: 输出 `~/.gitignore.global`，无解析报错

- [ ] **Step 3: Commit**

```bash
git add config/git/gitconfig.symlink
git commit -m "fix: use portable ~/ path for git excludesfile"
```

---

### Task 8: README 增加 Windows 初始化说明

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 在 `### 安装` 段后追加**

```markdown

### Windows 初始化

PowerShell 中执行：

> ./scripts/bootstrap.ps1

安装内容：Git、PowerShell 7、Windows Terminal、zoxide（winget）；
链接 git 配置与 PowerShell profile；Windows Terminal 已有 settings.json 时不覆盖，
请手动合并 `config/windows-terminal/settings.json`。

- `z <目录>`：目录跳转（zoxide，zsh/PowerShell 通用）
- `Alt+Shift+-` / `Alt+Shift+=`：Windows Terminal 横/竖分屏，`Alt+hjkl` 切换面板
- 符号链接需要管理员权限或开启 设置->开发者模式，否则自动回退为复制
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add Windows bootstrap instructions"
```

---

### Task 9: 端到端验证

- [ ] **Step 1: 重开 PowerShell 验证完整链路**

新开一个 PowerShell 窗口，依次验证：

```powershell
z --help          # zoxide 已生效
cd F:\code; cd $HOME; z code   # 跳回 F:\code
g status; gs      # git alias 生效
```

Expected: 全部正常

- [ ] **Step 2: 验证 Windows Terminal 分屏**

打开 Windows Terminal：`Alt+Shift+-` 横分屏、`Alt+Shift+=` 竖分屏、`Alt+hjkl` 切换面板、`Ctrl+Shift+W` 关闭面板；配色为 Gruvbox Dark。

（若 WT 原本已有 settings.json，需先手动合并 dotfiles 中的配置。）

- [ ] **Step 3: 重复运行 bootstrap.ps1 确认幂等无报错**
