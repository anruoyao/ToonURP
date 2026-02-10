<#
.SYNOPSIS
    ToonURP 一键安装脚本

.DESCRIPTION
    自动安装 ToonURP、修改过的 URP 及其所有依赖
    适用于 Unity 2022.3 项目

.EXAMPLE
    .\INSTALL_TOONURP.ps1

.NOTES
    Author: anruoyao
    Version: 1.0
    Date: 2025-02-10
#>

# 确保脚本以 UTF-8 编码运行
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Green
Write-Host "ToonURP 一键安装脚本" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# 检查当前目录
$CurrentDir = Get-Location
$PackagesDir = Join-Path -Path $CurrentDir -ChildPath "Packages"

if (-not (Test-Path -Path $PackagesDir -PathType Container)) {
    Write-Host "错误：当前目录不是 Unity 项目目录，未找到 Packages 文件夹" -ForegroundColor Red
    Write-Host "请在 Unity 项目根目录运行此脚本" -ForegroundColor Yellow
    Pause
    exit 1
}

Write-Host "当前 Unity 项目：$CurrentDir" -ForegroundColor Cyan
Write-Host "安装目录：$PackagesDir" -ForegroundColor Cyan

# 检查 git 是否可用
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Host "错误：未找到 git 命令，请先安装 Git" -ForegroundColor Red
    Write-Host "推荐安装 Git for Windows：https://git-scm.com/download/win" -ForegroundColor Yellow
    Pause
    exit 1
}

# 检查 git-lfs 是否可用
if (-not (Get-Command "git-lfs" -ErrorAction SilentlyContinue)) {
    Write-Host "警告：未找到 git-lfs 命令，可能无法拉取大文件" -ForegroundColor Yellow
    Write-Host "建议安装 Git LFS：https://git-lfs.com/" -ForegroundColor Yellow
}

Write-Host "" -ForegroundColor White
Write-Host "开始安装..." -ForegroundColor White
Write-Host "" -ForegroundColor White

# 步骤 1：克隆修改过的 URP
Write-Host "步骤 1：克隆修改过的 URP" -ForegroundColor Green
$URPPath = Join-Path -Path $PackagesDir -ChildPath "URP-Package"
if (Test-Path -Path $URPPath) {
    Write-Host "URP-Package 已存在，跳过克隆" -ForegroundColor Cyan
} else {
    try {
        Set-Location -Path $PackagesDir
        Write-Host "正在克隆 URP-Package..." -ForegroundColor Yellow
        git clone -b toon-urp https://github.com/anruoyao/URP-Package.git
        Write-Host "✓ URP-Package 克隆成功" -ForegroundColor Green
    } catch {
        Write-Host "✗ URP-Package 克隆失败：$($_.Exception.Message)" -ForegroundColor Red
        Pause
        exit 1
    }
}

# 步骤 2：克隆 URP 配置包
Write-Host "" -ForegroundColor White
Write-Host "步骤 2：克隆 URP 配置包" -ForegroundColor Green
$URPConfigPath = Join-Path -Path $PackagesDir -ChildPath "URP-Config-Package"
if (Test-Path -Path $URPConfigPath) {
    Write-Host "URP-Config-Package 已存在，跳过克隆" -ForegroundColor Cyan
} else {
    try {
        Set-Location -Path $PackagesDir
        Write-Host "正在克隆 URP-Config-Package..." -ForegroundColor Yellow
        git clone https://github.com/anruoyao/URP-Config-Package.git
        Write-Host "✓ URP-Config-Package 克隆成功" -ForegroundColor Green
    } catch {
        Write-Host "✗ URP-Config-Package 克隆失败：$($_.Exception.Message)" -ForegroundColor Red
        Pause
        exit 1
    }
}

# 步骤 3：克隆 ToonURP 主包
Write-Host "" -ForegroundColor White
Write-Host "步骤 3：克隆 ToonURP 主包" -ForegroundColor Green
$ToonURPPath = Join-Path -Path $PackagesDir -ChildPath "ToonURP"
if (Test-Path -Path $ToonURPPath) {
    Write-Host "ToonURP 已存在，跳过克隆" -ForegroundColor Cyan
} else {
    try {
        Set-Location -Path $PackagesDir
        Write-Host "正在克隆 ToonURP..." -ForegroundColor Yellow
        git clone https://github.com/anruoyao/ToonURP.git
        Write-Host "✓ ToonURP 克隆成功" -ForegroundColor Green
    } catch {
        Write-Host "✗ ToonURP 克隆失败：$($_.Exception.Message)" -ForegroundColor Red
        Pause
        exit 1
    }
}

# 步骤 4：拉取 Git LFS 文件
Write-Host "" -ForegroundColor White
Write-Host "步骤 4：拉取大文件（Git LFS）" -ForegroundColor Green
if (Test-Path -Path $ToonURPPath) {
    try {
        Set-Location -Path $ToonURPPath
        Write-Host "正在拉取大文件..." -ForegroundColor Yellow
        git lfs pull
        Write-Host "✓ 大文件拉取成功" -ForegroundColor Green
    } catch {
        Write-Host "警告：大文件拉取失败（可能不需要 LFS）：$($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# 步骤 5：初始化子模块（LWGUI）
Write-Host "" -ForegroundColor White
Write-Host "步骤 5：初始化 LWGUI 子模块" -ForegroundColor Green
if (Test-Path -Path $ToonURPPath) {
    try {
        Set-Location -Path $ToonURPPath
        Write-Host "正在初始化子模块..." -ForegroundColor Yellow
        git submodule update --init --recursive
        Write-Host "✓ 子模块初始化成功" -ForegroundColor Green
    } catch {
        Write-Host "✗ 子模块初始化失败，尝试手动处理..." -ForegroundColor Red
        
        # 手动处理 LWGUI 子模块
        $LWGUIPath = Join-Path -Path $ToonURPPath -ChildPath "LWGUI"
        if (-not (Test-Path -Path $LWGUIPath)) {
            Write-Host "正在手动克隆 LWGUI..." -ForegroundColor Yellow
            git clone https://github.com/anruoyao/LWGUI.git $LWGUIPath
            if (Test-Path -Path $LWGUIPath) {
                Set-Location -Path $LWGUIPath
                git checkout hanitized
                Write-Host "✓ LWGUI 手动克隆成功" -ForegroundColor Green
            } else {
                Write-Host "✗ LWGUI 手动克隆失败" -ForegroundColor Red
            }
        }
    }
}

# 步骤 6：验证安装
Write-Host "" -ForegroundColor White
Write-Host "步骤 6：验证安装" -ForegroundColor Green
Set-Location -Path $CurrentDir

$RequiredDirs = @(
    "Packages/URP-Package",
    "Packages/URP-Config-Package",
    "Packages/ToonURP",
    "Packages/ToonURP/LWGUI"
)

$AllGood = $true
foreach ($Dir in $RequiredDirs) {
    $FullPath = Join-Path -Path $CurrentDir -ChildPath $Dir
    if (Test-Path -Path $FullPath) {
        Write-Host "✓ $Dir 存在" -ForegroundColor Green
    } else {
        Write-Host "✗ $Dir 不存在" -ForegroundColor Red
        $AllGood = $false
    }
}

Write-Host "" -ForegroundColor White
if ($AllGood) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "🎉 ToonURP 安装成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "下一步：" -ForegroundColor Cyan
    Write-Host "1. 打开 Unity 项目" -ForegroundColor Cyan
    Write-Host "2. 等待 Unity 编译完成" -ForegroundColor Cyan
    Write-Host "3. 配置 URP：" -ForegroundColor Cyan
    Write-Host "   - Edit > Project Settings > Graphics" -ForegroundColor Cyan
    Write-Host "   - 将 Scriptable Render Pipeline Settings" -ForegroundColor Cyan
    Write-Host "     设置为 Packages/ToonURP/Setting/URP-HighFidelity.asset" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor White
    Write-Host "4. 开始使用 ToonURP：" -ForegroundColor Cyan
    Write-Host "   - 创建材质：Create > Material" -ForegroundColor Cyan
    Write-Host "   - 选择 Shader：ToonURP/ToonStandard" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor White
    Write-Host "5. 语言设置：" -ForegroundColor Cyan
    Write-Host "   - Window > LWGUI > Localization Settings" -ForegroundColor Cyan
    Write-Host "   - 选择中文或英文界面" -ForegroundColor Cyan
    Write-Host "" -ForegroundColor White
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "⚠️  安装不完全，部分组件缺失" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "请检查上述错误信息并手动处理缺失的组件" -ForegroundColor Yellow
}

Write-Host "" -ForegroundColor White
Write-Host "按任意键退出..." -ForegroundColor Cyan
Pause
