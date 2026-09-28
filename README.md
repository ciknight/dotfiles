# Dotfiles

welcome to my dotfile

### 生成ssh key
if [ ! -f ~/.ssh/id_rsa ] ; then
    ssh-keygen -t rsa -b 4096 -C "andy@example.com"
fi

### 安装

> ./scripts/bootstrap.sh

### Windows 初始化

PowerShell 中执行：

> ./scripts/bootstrap.ps1

新机器需先装 git 再克隆仓库（鸡生蛋问题）：

```powershell
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
git clone git@github.com:ciknight/dotfiles F:\code\dotfiles
```

然后 PowerShell 中执行：

> ./scripts/bootstrap.ps1

安装内容（优先 winget）：Git、PowerShell 7、Windows Terminal、zoxide、Neovim、
lazygit、fzf（+ PSFzf 模块）、ripgrep；
链接 git 配置与 PowerShell profile（PS 5.1/7 两个路径）；Windows Terminal 已有
settings.json 时不覆盖，请手动合并 `config/windows-terminal/settings.json`。

- `z <目录>`：目录跳转（zoxide，zsh/PowerShell 通用）
- `Ctrl+t` / `Ctrl+r`：fzf 文件选择 / 历史反向搜索（PSFzf，对齐 zsh）
- `g` / `gs`：git / git status 别名
- `Alt+Shift+-` / `Alt+Shift+=`：Windows Terminal 横/竖分屏，`Alt+hjkl` 切换面板
- 符号链接需要管理员权限或开启 设置->开发者模式，否则自动回退为复制

### Test your zsh speed

```
\time zsh -i -c exit
```

### Clean `/usr/local/bin`

```shell
cd /usr/local/bin/
rm flake8 black mypy isort
```

### Upgrade neovim virtualenv

```shell
pip freeze | awk -F '=' '{print $1}' | xargs pip install --upgrade
```

### Enable vscode key-repeat(长按hjkl)

https://github.com/VSCodeVim/Vim#vscodevim-settings

Run in shell

> defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

### TODO
