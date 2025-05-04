#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
 sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# 修改机器名称
 sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 将构建日期添加到概览页面
 # sed -i 's/%D %V/%D %V | Build by Blacknesswing |/g' package/base-files/files/usr/lib/os-release
 # sed -i "s/%C/($(date +"%Y-%m-%d"))/g" package/base-files/files/usr/lib/os-release
 sed -i "s/%D %V/%D %V | Build by Blacknesswing | Compiled on $(date '+%Y-%m-%d') |/g" package/base-files/files/usr/lib/os-release



#修改版本内核（下面两行代码前面有#为源码默认最新5.4内核,没#为4.19内核,默认修改X86的，其他机型L大源码那里target/linux查看，对应修改下面的路径就好）
# sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' target/linux/x86/Makefile  #修改内核版本
# sed -i 's/KERNEL_TESTING_PATCHVER:=5.10/KERNEL_TESTING_PATCHVER:=5.10/g' target/linux/rockchip/Makefile  #修改内核版本
