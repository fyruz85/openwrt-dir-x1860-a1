# A1 hardware evidence

2026-11-24: Three owner-provided stock firmware archives were inspected offline. No router was accessed or modified. AES decryption followed the public 2021 DIR-X1860 firmware research by musashino_205 (memo205.hatenablog.jp). The decrypted images start with FDT/FIT magic, and both kernel and DTB CRC32 and SHA-1 hashes were independently verified for every image. These hashes validate internal integrity, not vendor authenticity.

| Image | Encrypted SHA-256 | FIT size (bytes) |
|---|---|---:|
| DIRX1860A1_FW102B06.bin | 950988e72c32b9a2a36e909ca825d91cb44a35ea32993b8f380bd4e7361d1e47 | 3376140 |
| DIRX1860A1_FW103B07.bin | 8023fe5a4e0728201ff3a625ea3be475e8263f3d833cdae5ae6bc53e8dd5196f | 3376452 |
| DIRX1860A1_FW110WWB09_Beta20220107.bin | 8384cdab8cddbee6c299cbfcc2db2978bbc68446227624790534543f0dbe8b01 | 3377784 |

All three have identical embedded DTBs (11406 bytes, SHA256 7fbe7cf8965397854464cf45a02c2c1f3c395f2f0dda7adf1ce41e8eb0663fa4). FIT kernel description Linux 4.4.198, MIPS, LZMA, load/entry 0x81001000. SquashFS begins at image offset 0x340000. DTB compatible mediatek,mt7621-rfb-ax-nand and mediatek,mt7621-soc.

## Flash map from stock DTB

| Name | Start | Length |
|---|---:|---:|
| Bootloader | 0x0 | 0x80000 |
| Config | 0x80000 | 0x80000 |
| Factory | 0x100000 | 0x80000 |
| firmware | 0x180000 | 0x2b00000 |
| firmware2 | 0x2c80000 | 0x2b00000 |
| Devdata | 0x5780000 | 0x800000 |
| User_data | 0x5f80000 | 0x2000000 |

Ends at 0x7f80000, leaving 0x80000 unaccounted for. Stock kernel/rootfs boundary is 0x4c0000. Never treat the B1 layout as interchangeable; its kernel starts at 0x1c0000. Preserve both firmware slots, bootloader and all device-specific partitions.

## GPIO from stock DTB

All active low: reset 6, WPS 18, internet_ok 16, internet_fail 14, power_ok 13, power_fail 15. Stock PCIe reset GPIO 19. SoC pinmux stock GPIO groups i2c, uart3, jtag, wdt; modern binding names need verification. Stock button codes reset 0x198 (KEY_RESTART), WPS 0x211.

## Network

Stock MT7530 switch portmap llllw: four LAN ports 0–3, WAN PHY 4. GMAC0 TRGMII fixed gigabit link, GMAC1 RGMII linked to PHY 4; switch CPU links 5 RGMII and 6 TRGMII. Physical port order remains unknown. A1 and B1 GPIO assignments are different. A1 Wi-Fi boot logs show MT7915 family, but PCIe slot, EEPROM/precal offsets and per-device MAC derivation still need confirmation. Do not enable Wi-Fi until verified.

## First build constraints

Use an A1-only RAM-boot research profile. Disable NAND and PCIe initially; no persistent image, no factory installer, no upgrade support. Start with Ethernet and WireGuard. Confirm bootloader non-persistent loading and recovery independently. Stock load address is evidence, not a guarantee of safe modern kernel loading. Do not upload initramfs to the firmware upgrade/recovery web UI.

## References

- https://openwrt.org/inbox/toh/d-link/dir-x1860_a1
- https://github.com/openwrt/openwrt/commit/13dc286814c646a2f03dc27e5bf2a34206e0242d
- https://lists.infradead.org/pipermail/lede-commits/2025-October/027569.html

Only original factual notes are committed; no vendor binaries, extracted DTBs or device-specific data.
