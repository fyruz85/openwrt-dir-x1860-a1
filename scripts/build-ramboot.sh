#!/usr/bin/env bash
# Run as a non-root user in a disposable Linux build environment.
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
work="${1:-$here/build/openwrt}"
ref=13dc286814c646a2f03dc27e5bf2a34206e0242d
[[ $EUID -ne 0 ]] || { echo "Do not build as root"; exit 1; }
[[ ! -e "$work" ]] || { echo "Use a fresh work directory"; exit 1; }
mkdir -p "$work"
git -C "$work" init
git -C "$work" remote add origin https://github.com/openwrt/openwrt.git
git -C "$work" fetch --depth=1 origin "$ref"
git -C "$work" checkout --detach FETCH_HEAD
[[ "$(git -C "$work" rev-parse HEAD)" == "$ref" ]]
cd "$work"
install -m 0644 "$here/port/mt7621_dlink_dir-x1860-a1.dts" target/linux/ramips/dts/
cat "$here/port/device.mk" >> target/linux/ramips/image/mt7621.mk
python3 - <<'PY'
from pathlib import Path
p = Path('target/linux/ramips/mt7621/base-files/etc/board.d/02_network')
s = p.read_text()
anchor = 'case "$board" in'
assert anchor in s
s = s.replace(anchor, anchor + '\n\tdlink,dir-x1860-a1)\n\t\tucidef_set_interfaces_lan_wan "lan1 lan2 lan3 lan4" "wan"\n\t\t;;', 1)
p.write_text(s)
PY
# First milestone is kernel + Ethernet + WireGuard, no external feeds.
cat > .config <<'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1=y
CONFIG_TARGET_ROOTFS_INITRAMFS=y
# CONFIG_TARGET_ROOTFS_SQUASHFS is not set
# CONFIG_TARGET_ROOTFS_TARGZ is not set
CONFIG_PACKAGE_kmod-wireguard=y
CONFIG_PACKAGE_wireguard-tools=y
EOF
make defconfig
for k in CONFIG_TARGET_ramips_mt7621_DEVICE_dlink_dir-x1860-a1 CONFIG_TARGET_ROOTFS_INITRAMFS CONFIG_PACKAGE_kmod-wireguard CONFIG_PACKAGE_wireguard-tools; do
  grep -qx "$k=y" .config || { echo "Missing required setting: $k"; exit 1; }
done
make download -j4
make -j"${JOBS:-2}" V=s
out="$here/build/EXPERIMENTAL-NOT-FOR-FLASH"
mkdir -p "$out"
mapfile -t images < <(find bin/targets/ramips/mt7621 -maxdepth 1 -type f -name '*dlink_dir-x1860-a1*initramfs*bin')
[[ ${#images[@]} -eq 1 ]] || { echo "Expected one A1 initramfs image"; exit 1; }
if find bin/targets/ramips/mt7621 -maxdepth 1 -type f \( -name '*dlink_dir-x1860-a1*sysupgrade*' -o -name '*dlink_dir-x1860-a1*factory*' -o -name '*dlink_dir-x1860-a1*recovery*' \) | grep -q .; then
  echo "Unexpected persistent image; refusing artifact staging"; exit 1
fi
python3 - "${images[0]}" <<'PY'
import sys, struct
from pathlib import Path
b = Path(sys.argv[1]).read_bytes()
assert len(b) >= 40 and b[:4] == bytes.fromhex('d00dfeed'), 'Not a FIT image'
size = struct.unpack_from('>I', b, 4)[0]
assert 40 <= size <= len(b), 'Invalid FIT size'
PY
cp "${images[0]}" "$out/"
cp .config "$out/build.config"
git rev-parse HEAD > "$out/upstream-commit.txt"
(cd "$out" && sha256sum *.bin > SHA256SUMS)
echo "Compile candidate only. No verified boot method. Never flash."
