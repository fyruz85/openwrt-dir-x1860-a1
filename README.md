# OpenWrt for D-Link DIR-X1860 A1

Experimental community port for the D-Link DIR-X1860 **hardware revision A1**, with native WireGuard support as the primary objective.

**Status: research only. No bootable or flashable image has been validated. Do not flash B1 or R1 images onto A1 hardware.**

## Goals

- Native OpenWrt on the MT7621 platform.
- Gigabit Ethernet, SSH, LuCI, firewall and WireGuard.
- Wi-Fi 6 on both bands, preserving per-device calibration and MAC addresses.
- Reproducible source builds using a pinned upstream OpenWrt revision.
- A documented installation and recovery procedure.

## Development milestones

- [ ] Verify A1 stock image headers, device tree, board identifiers, NAND partitions, bootloader constraints and regulatory data.
- [ ] Compare A1 hardware with upstream DIR-X1860 B1 support; record differences with primary sources.
- [ ] Confirm stock emergency recovery access and its limitations.
- [ ] Develop A1 device tree, target profile and network defaults on an experimental branch.
- [ ] Compile an initramfs test image; inspect size, format, DTB and hashes.
- [ ] Establish a verified non-persistent boot method before testing on hardware.
- [ ] Test Ethernet, SSH, WireGuard, Wi-Fi and board peripherals.
- [ ] Verify a safe persistent installation and rollback procedure before producing installable images.

## References

- [Upstream OpenWrt source](https://github.com/openwrt/openwrt)
- [OpenWrt A1 hardware investigation](https://openwrt.org/inbox/toh/d-link/dir-x1860_a1)
- [D-Link firmware downloads](https://downloads.dlink.com.sg/dir-x1860/)

## Safety and distribution

This public repository is for original porting code, documentation and reproducible build instructions. Do not commit vendor firmware binaries, extracted proprietary files, per-device flash dumps, passwords, keys or calibration data. Keep original firmware and configuration backups offline. Preserve the bootloader, factory/calibration and device-specific partitions. Emergency web recovery is not assumed to recover all failures.

Hardware validation is required; successful compilation alone does not prove a firmware is safe to install.
