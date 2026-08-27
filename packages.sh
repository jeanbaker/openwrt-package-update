#!/bin/bash

# 遇到错误立即退出（可选，保证可靠性）
set -e

# 定义通用函数：用于高效拉取 GitHub 仓库中的指定子目录 (替代已失效的 svn co)
merge_package() {
    local repo_url=$1
    local branch=$2
    local pkg_path=$3
    local local_dir_name=$(basename "$pkg_path")

    echo "==> Pulling $pkg_path from $repo_url ($branch)..."
    
    # 建立临时目录进行稀疏检出
    rm -rf tmp_pkg
    git clone --depth=1 --single-branch -b "$branch" --filter=blob:none --sparse "$repo_url" tmp_pkg
    cd tmp_pkg
    git sparse-checkout set "$pkg_path"
    cd ..

    # 移动源码到当前packages根目录
    rm -rf "$local_dir_name"
    mv tmp_pkg/"$pkg_path" ./
    rm -rf tmp_pkg
}
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-netdata"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-smartdns"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-socat"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "smartdns"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "netdata"
echo "==> Cloning argon..."
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon

# 5. 统一深度清理版本控制残留，保持 OpenWrt package 目录干净
echo "==> Cleaning up metadata..."
find . -type d -name ".git" -exec rm -rf {} +
find . -type d -name ".svn" -exec rm -rf {} +
find . -type d -name ".github" -exec rm -rf {} +
find . -type f -name ".gitignore" -exec rm -rf {} +
find . -type f -name ".gitattributes" -exec rm -rf {} +

echo "==> Packages updated successfully!"
exit 0
