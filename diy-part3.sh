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

# -----------------------------
# 一、修改默认 IP
# -----------------------------
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# -----------------------------
# 二、修改机器名称
# -----------------------------
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# -----------------------------
# 三、在概览页面显示编译日期和构建者信息
# -----------------------------
sed -i "s/%D %V/%D %V | Build by Blacknesswing | Compiled on $(date '+%Y-%m-%d') |/g" \
    package/base-files/files/usr/lib/os-release

# -----------------------------
# 四、(可选) 修改内核版本
# -----------------------------
# sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' target/linux/x86/Makefile
# sed -i 's/KERNEL_TESTING_PATCHVER:=5.10/KERNEL_TESTING_PATCHVER:=5.10/g' target/linux/rockchip/Makefile

# -----------------------------
# 五、智能修复 x86 型号显示
# -----------------------------
# 原理：
#   系统启动时会读取 /sys/class/dmi/id/product_name 来识别型号
#   如果读取到 "Default string" 或空值，说明 BIOS 没提供型号信息
#   这时才写入固定的型号名，否则保留原始识别结果

cat <<'EOF' > package/base-files/files/etc/init.d/fix-x86-model
#!/bin/sh /etc/rc.common
# 启动脚本：仅在型号识别失败时设置固定名称
START=11

boot() {
    model="$(cat /sys/class/dmi/id/product_name 2>/dev/null)"
    if [ -z "$model" ] || echo "$model" | grep -qi "default string"; then
        mkdir -p /tmp/sysinfo
        echo "X86 Router" > /tmp/sysinfo/model
        logger -t fix-x86-model "BIOS 未提供主板信息，型号已设为 X86 Router"
    else
        logger -t fix-x86-model "检测到主板型号: $model，保持原样"
    fi
}
EOF

chmod +x package/base-files/files/etc/init.d/fix-x86-model

# ============================================
# 修复 libdouble-conversion 的 CMake 兼容性问题
# ============================================
echo ">>> 修复 libdouble-conversion 的 CMake 3.5 兼容性问题..."
sed -i '/CMAKE_OPTIONS/s/$/\nCMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5/' \
  feeds/packages/libs/libdouble-conversion/Makefile || \
echo 'CMAKE_OPTIONS += -DCMAKE_POLICY_VERSION_MINIMUM=3.5' >> feeds/packages/libs/libdouble-conversion/Makefile


