# A1 board evidence — 2026-11-24

All three owner-supplied stock firmware archives were inspected offline. Original images unchanged. Published A1 decryption notes were used to read the FIT container. No vendor payload or keys are included here.

| Stock BIN | Bytes | SHA-256 |
|---|---:|---|
| DIRX1860A1_FW102B06.bin | 15860000 | 950988e72c32b9a2a36e909ca825d91cb44a35ea32993b8f380bd4e7361d1e47 |
| DIRX1860A1_FW103B07.bin | 15335712 | 8023fe5a4e0728201ff3a625ea3be475e8263f3d833cdae5ae6bc53e8dd5196f |
| DIRX1860A1_FW110WWB09_Beta20220107.bin | 15991072 | 8384cdab8cddbee6c299cbfcc2db2978bbc68446227624790534543f0dbe8b01 |

All three decrypt to FIT magic d00dfeed at offset 0; SquashFS magic at 0x340000. FIT kernel: MIPS Linux 4.4.198, LZMA, load/entry 0x81001000. Embedded DTB is identical (11406 bytes, SHA-256 7fbe7cf8965397854464cf45a02c2c1f3c395f2f0dda7adf1ce41e8eb0663fa4). Stock DT identifies generic mediatek,mt7621-rfb-ax-nand. Board-specific runtime changes remain possible.

## NAND layout (from DTB, not live flash)

| Label | Start | Size |
|---|---:|---:|
| Bootloader | 0x0000000 | 0x80000 |
| Config | 0x0080000 | 0x80000 |
| Factory | 0x0100000 | 0x80000 |
| firmware | 0x0180000 | 0x2b00000 |
| firmware2 | 0x2c80000 | 0x2b00000 |
| Devdata | 0x5780000 | 0x800000 |
| User_data | 0x5f80000 | 0x2000000 |

Do not assume either firmware slot is inactive or writable. Stock filesystem offset is not a modern OpenWrt kernel size limit. Bad block mapping, slot selection, bootloader verification and recovery format are unverified.

## GPIO and Ethernet

Active-low GPIOs: reset 6, WPS 18, internet_ok 16, internet_fail 14, power_ok 13, power_fail 15; PCIe reset 19. Vendor switch portmap llllw, GMAC0 TRGMII, GMAC1 RGMII connected to PHY4. Physical order of LAN ports remains unverified; candidate labels logical only. No Wi-Fi EEPROM offset or MAC derivation is assumed. PCIe and NAND disabled in initial RAM-only candidate.

## Upstream comparison

Pinned reference: https://github.com/openwrt/openwrt/commit/13dc286814c646a2f03dc27e5bf2a34206e0242d (B1 support). B1 has three LAN ports, different GPIOs and different NAND layout. Do not reuse its factory/recovery/sysupgrade images.

Other sources:
- https://openwrt.org/inbox/toh/d-link/dir-x1860_a1
- https://lists.infradead.org/pipermail/lede-commits/2025-October/027569.html

## Remaining gates

1. Confirm recovery UI on actual A1 and identify stock recovery image format; no upload.
2. Identify a truly non-persistent RAM boot method. Web recovery upload is not a RAM boot method unless demonstrated.
3. Build and validate candidate FIT and boot memory placement. Inspect bootloader limits; do not assume B1 load address works.
4. Boot RAM-only with isolated LAN, confirm CPU, Ethernet and logs.
5. Verify live NAND layout, ECC/bad-block handling, calibration data and MAC derivation before enabling flash or Wi-Fi.
6. Only after verified backups/recovery, design persistent installation and rollback. Never overwrite bootloader or factory data.
