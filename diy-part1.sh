#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
#添加订阅源
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2" >> "feeds.conf.default"
# mihomo
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git" >> "feeds.conf.default"

# mosdns
echo "src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;v5" >> "feeds.conf.default"
# 删除 OpenWrt 官方的 golang（防止版本不兼容）
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 确保 ImmortalWrt 里没有自带的 v2ray-geodata
rm -rf feeds/packages/net/v2ray-geodata

# 删除源码自带的 mosdns 和 v2ray-geodata（如果存在）
find package/ -name "*mosdns*" | xargs rm -rf
find package/ -name "*v2ray-geodata*" | xargs rm -rf

# 克隆最新版 mosdns 和 v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
