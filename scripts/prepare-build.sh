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
needle = '\tcase "$board" in\n'
assert needle in s, 'network configuration anchor changed'
s = s.replace(needle, needle + '\tdlink,dir-x1860-a1)\n\t\tucidef_set_interface_lan "lan1 lan2 lan3 lan4"\n\t\t;;\n', 1)
p.write_text(s)
PY
cat > .config <<'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1=y
CONFIG_TARGET_ROOTFS_INITRAMFS=y
# CONFIG_TARGET_ROOTFS_SQUASHFS is not set
CONFIG_PACKAGE_kmod-wireguard=y
CONFIG_PACKAGE_wireguard-tools=y
EOF
make defconfig
grep -qx 'CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1=y' .config
grep -qx 'CONFIG_TARGET_ROOTFS_INITRAMFS=y' .config
grep -qx 'CONFIG_PACKAGE_kmod-wireguard=y' .config
grep -qx 'CONFIG_PACKAGE_wireguard-tools=y' .config
echo 'Prepared experimental source; not compiled or hardware validated.'
