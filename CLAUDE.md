# CLAUDE.md

## Windows 软件安装

- 安装软件时**优先使用 winget**(`scripts/install.ps1` 统一走 winget)
- winget 仓库没有该包时,才使用其他方式(PowerShell Gallery `Install-Module`、官方安装脚本、手动下载等)
- 新增软件须同步加入 `scripts/install.ps1` 的 `$packages` 列表,保持本机与脚本一致
