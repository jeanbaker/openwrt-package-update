#!/bin/bash
set -e

echo "Executing packages.sh in: $(pwd)"

# 通用函数：只拉取远程仓库中的某一个指定子文件夹
merge_package() {
    local repo_url=$1
    local branch=$2
    local pkg_path=$3
    local local_dir_name=$(basename "$pkg_path")

    echo "==> Pulling $pkg_path from $repo_url ($branch)..."
    
    rm -rf tmp_pkg
    git clone --depth=1 --single-branch -b "$branch" --filter=blob:none --sparse "$repo_url" tmp_pkg
    cd tmp_pkg
    git sparse-checkout set "$pkg_path"
    cd ..

    # 清除旧的同名文件夹并覆写
    rm -rf "./$local_dir_name"
    mv tmp_pkg/"$pkg_path" ./
    rm -rf tmp_pkg
}

# 1. 单包拉取 (使用 merge_package)
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-netdata"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-smartdns"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "luci-app-socat"
merge_package "https://github.com/sbwml/luci-app-mosdns.git" "main" "luci-app-mosdns"
merge_package "https://github.com/sbwml/luci-app-mosdns.git" "main" "mosdns"
merge_package "https://github.com/sbwml/luci-app-mosdns.git" "main" "geo2txt"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "smartdns"
merge_package "https://github.com/kiddin9/op-packages.git" "main" "netdata"
merge_package "https://github.com/Openwrt-Passwall/openwrt-passwall.git" "main" "luci-app-passwall"

# 2. 完整仓库克隆 (克隆前必须先 rm -rf 删除旧文件夹，防止报错)
echo "==> Cloning argon..."
rm -rf luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git luci-theme-argon

# 3. 清理子包中的 Git 元数据 (-mindepth 2 确保不误删 target_repo 本身的 .git)
echo "==> Cleaning up metadata from subpackages..."
find . -mindepth 2 -type d -name ".git" -exec rm -rf {} +
find . -type d -name ".svn" -exec rm -rf {} +
find . -type d -name ".github" -exec rm -rf {} +
find . -type f -name ".gitignore" -exec rm -rf {} +
find . -type f -name ".gitattributes" -exec rm -rf {} +

echo "==> Packages updated successfully!"
exit 0
