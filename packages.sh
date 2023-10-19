#!/bin/bash
svn co https://github.com/kenzok8/openwrt-packages/trunk/adguardhome
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-adguardhome 
svn co https://github.com/jerrykuku/luci-theme-argon/branches/master ./luci-theme-argon
svn co https://github.com/xiaorouji/openwrt-passwall-packages/trunk
svn co https://github.com/xiaorouji/openwrt-passwall/trunk 
svn co https://github.com/kiddin9/openwrt-packages/trunk/luci-app-netdata
svn co https://github.com/chenmozhijin/luci-app-socat/trunk/luci-app-socat

rm -rf .svn
rm -rf ./*/.git
rm -rf ./*/.svn 
rm -f .gitattributes .gitignore
rm -rf .github
rm LICENSE
mv LICENSE.packages LICENSE
exit 0
