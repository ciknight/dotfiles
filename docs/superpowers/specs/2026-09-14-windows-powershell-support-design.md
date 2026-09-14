# Windows PowerShell 支持设计：zoxide + Windows Terminal

日期：2026-09-14

## 背景与目标

现有 dotfiles 项目只支持 Mac（brew）和 Linux（apt/yum），采用 `*.symlink` + `scripts/bootstrap.sh` 的初始化模式。zsh 通过 oh-my-zsh 的 `z` 插件实现目录跳转，tmux 配置为 `config/tmux.conf.symlink`。

目标：新增 Windows 支持，要求：

- PowerShell 上有与 `z` 一致的目录跳转体验
- Windows 上不使用 tmux（无原生版本），用 Windows Terminal 分屏替代
- Windows 侧统一用 winget 作为包管理器（Linux/Mac 维持 brew/apt，后续逐步统一）
- 配置跨平台共享，方案保持简单

## 技术选型

- **zoxide**：`z` 的现代化重写（Rust），同时支持 PowerShell / zsh / bash，三端统一 `z` 命令。zsh 侧保留 oh-my-zsh `z` 插件不冲突，装了 zoxide 则优先用 zoxide。
- **winget**：Windows 11 自带，无需额外安装，命令幂等（已安装则跳过）。
- **Windows Terminal**：自带分屏/标签能力，通过自定义快捷键模拟 tmux 面板操作。

## 新增文件

### `scripts/install.ps1` — Windows 软件安装

用 winget 安装以下包（幂等）：

- `Git.Git`
- `Microsoft.PowerShell`（PowerShell 7）
- `Microsoft.WindowsTerminal`
- `ajeetdsouza.zoxide`

若 winget 不存在，提示升级系统后退出。

### `scripts/bootstrap.ps1` — Windows 初始化入口

对应 `bootstrap.sh` 的 Windows 版本，步骤：

1. 调用 `install.ps1`
2. 创建 `~/workspace`（若不存在）
3. 生成 `config/git/gitconfig.local.symlink`：复用现有 `.example` 模板，交互询问 GitHub 用户名/邮箱，credential helper 用 `manager`
4. 链接配置文件（见下）

### `config/powershell/profile.ps1` — PowerShell 配置

链接到 `$PROFILE`（PS 5.1 和 PS 7 均生效，bootstrap 中两个 profile 路径都链接）。内容：

- `zoxide init powershell`（存在才执行）
- 与 zshrc 对齐的少量核心 alias：`g`（git）、`gs`（git status）
- UTF-8 输出编码设置（对齐 zshrc 的 `LANG=en_US.UTF-8` 意图）

### `config/windows-terminal/settings.json` — WT 配置

- 分屏快捷键：`Alt+Shift+-` 横向分屏、`Alt+Shift+\` 纵向分屏、`Ctrl+Shift+W` 关闭面板
- Gruvbox Dark 配色（对齐 `config/iterm2/Gruvbox Dark.itermcolors`）

WT 已有 settings.json 时**不覆盖**，提示备份后手动合并。

## 现有文件改动

### `scripts/install.sh`

- brew 分支加 `zoxide`
- apt 分支加 `zoxide`（apt 源没有时回退官方安装脚本 `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`）

### `config/zsh/zshrc.symlink`

末尾追加（存在才启用，不影响未安装机器）：

```sh
if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
```

## 链接策略（Windows）

`bootstrap.ps1` 链接以下配置：

| 源 | 目标 |
|---|---|
| `config/powershell/profile.ps1` | `$PROFILE`（PS5.1 与 PS7 两个路径） |
| `config/git/gitconfig.symlink` 等现有 `*.symlink` | `$HOME/.<name>`（仅对 Windows 有意义的：gitconfig） |

Windows 创建 symlink 需要管理员权限或开发者模式：先试 `New-Item -ItemType SymbolicLink`，失败则提示开启"开发者模式"并回退为复制文件。

## 错误处理

- winget 不存在 → 提示升级 Windows / 安装 App Installer，退出
- symlink 权限不足 → 提示开开发者模式，回退复制
- WT settings.json 已存在 → 跳过并提示手动合并，不覆盖

## 验证

跑完 `bootstrap.ps1` 后开新 PowerShell 窗口：

1. `z <目录>` 能跳转（先 cd 几次积累数据）
2. `g`、`gs` alias 生效
3. Windows Terminal 分屏快捷键可用
4. `bootstrap.ps1` 可重复运行不报错（幂等）

## 明确不做（YAGNI）

- Windows 上不装 tmux、不搞 WSL
- 不改 `bin/` 下的 shell 脚本（Windows 不可用，不链接）
- 不迁移 nvim/python 等到 Windows（后续按需再加）
