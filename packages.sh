#!/bin/bash
svn co https://github.com/kiddin9/kwrt-packages/trunk/adguardhome
svn co https://github.com/kiddin9/kwrt-packages/trunk/luci-app-adguardhome 
svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk ./
rm -rf .svn
svn co https://github.com/xiaorouji/openwrt-passwall/trunk ./
svn co https://github.com/kiddin9/kwrt-packages/trunk/luci-app-netdata
svn co https://github.com/kiddin9/kwrt-packages/trunk/r8125
svn co https://github.com/kiddin9/kwrt-packages/trunk/r8168
git clone https://github.com/chenmozhijin/luci-app-socat ./luci-app-socat
git clone https://github.com/jerrykuku/luci-theme-argon ./luci-theme-argon

rm -rf .svn
rm -rf ./*/.git
rm -rf ./*/.svn 
rm -f .gitattributes .gitignore
rm -rf .github

exit 0
