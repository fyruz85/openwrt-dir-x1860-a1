#!/usr/bin/env bash
# Run from any directory: bash scripts/prepare-build.sh /path/to/clean/openwrt
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
src="${1:?Supply a clean OpenWrt checkout}"
cd "$src"
test "$(git rev-parse HEAD)" = 13dc286814c646a2f03dc27e5bf2a34206e0242d
test -z "$(git status --porcelain)"
cp "$root/port/mt7621_dlink_dir-x1860-a1.dts" target/linux/ramips/dts/
printf '\n' >> target/linux/ramips/image/mt7621.mk
cat "$root/port/device.mk" >> target/linux/ramips/image/mt7621.mk
python3 - <<'PY'
from pathlib import Path
p = Path('target/linux/ramips/mt7621/base-files/etc/board.d/02_network')
s = p.read_text()
needle = '\tcase $board in\n'
assert s.count(needle) >= 1, 'network configuration anchor changed'
s = s.replace(needle, needle + '\tdlink,dir-x1860-a1)\n\t\tucidef_set_interface_lan "lan1 lan2 lan3 lan4"\n\t\t;;\n', 1)
p.write_text(s)
PY
cat > feeds.conf <<'FEEDS'
src-git packages https://github.com/openwrt/packages.git^65b935cb5861c5a725c480fdd374f2e2d59ef848
src-git luci https://github.com/openwrt/luci.git^2f000b5e155f2526a5c64305254ef15b890987ea
FEEDS
./scripts/feeds update -a
./scripts/feeds install luci luci-proto-wireguard
cat > .config <<'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1=y
CONFIG_TARGET_ROOTFS_INITRAMFS=y
# CONFIG_TARGET_ROOTFS_SQUASHFS is not set
CONFIG_PACKAGE_kmod-wireguard=y
CONFIG_PACKAGE_wireguard-tools=y
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_luci-proto-wireguard=y
CONFIG_PACKAGE_dropbear=y
CONFIG_PACKAGE_dnsmasq=y
CONFIG_PACKAGE_firewall4=y
EOF
make defconfig
grep -qx 'CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1=y' .config
grep -qx 'CONFIG_TARGET_ROOTFS_INITRAMFS=y' .config
grep -qx 'CONFIG_PACKAGE_kmod-wireguard=y' .config
grep -qx 'CONFIG_PACKAGE_wireguard-tools=y' .config
for pkg in luci luci-proto-wireguard dropbear dnsmasq firewall4; do
  grep -qx "CONFIG_PACKAGE_${pkg}=y" .config
done
echo 'Prepared experimental source; not compiled or hardware validated.'
