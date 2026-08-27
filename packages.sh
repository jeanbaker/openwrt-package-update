#!/bin/bash
set -e

# 通用函数：替代已失效的 svn co，只拉取目标仓库中的某一个指定子文件夹
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


#清理所有 Git 版本控制元数据，保持包目录干净
echo "==> Cleaning up metadata from subpackages..."

# ⚠️ 关键修正：添加 -mindepth 2，防止把 target_repo 本身的 .git 删掉！
find . -mindepth 2 -type d -name ".git" -exec rm -rf {} +
find . -type d -name ".svn" -exec rm -rf {} +
find . -type d -name ".github" -exec rm -rf {} +
find . -type f -name ".gitignore" -exec rm -rf {} +
find . -type f -name ".gitattributes" -exec rm -rf {} +

echo "==> Packages updated successfully!"
exit 0
