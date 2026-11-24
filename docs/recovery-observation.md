# A1 recovery observation

2026-11-24: Device owner confirms the emergency recovery page is accessible on their DIR-X1860 A1. This is an owner-reported observation, not a verified successful recovery or RAM boot. URL, page controls, bootloader version, accepted file format and ability to restore stock remain unverified.

Upstream B1 instructions use the recovery UI to install a persistent recovery image; this is not evidence of a RAM-only boot option on A1. Reference: https://lists.infradead.org/pipermail/lede-commits/2025-October/027569.html

Next: obtain a screenshot of the A1 recovery page (no firmware upload). Investigate a non-persistent boot path. Do not upload an experimental image or a different hardware revision's image. Compile and validate the RAM-only candidate independently of this gate.

Owner follow-up: the A1 recovery UI looks the same as the B1. Treat it as a persistent upload interface, not a proven RAM boot route. This does not establish accepted A1 image format, flash write bounds, or stock restoration capability. Upstream B1 recovery recipe uses an 8 MiB kernel region and UBI; A1 stock rootfs offset is 0x340000, so the B1 layout cannot be copied without validation. See https://git.openwrt.org/openwrt/openwrt/tree/target/linux/ramips/image/mt7621.mk and https://openwrt.org/inbox/toh/d-link/dir-x1860_a1.

No further physical action is requested until compilation and source audit are complete. A stock recovery test, if later undertaken, must use the exact hardware/region-compatible original firmware and may reset settings; it is not a guarantee of recovery from every failure.

## Screenshot confirmation

Owner supplied a screenshot on 2026-11-24 showing HTTP 192.168.0.1, heading 'D-Link Router Recovery Mode', file chooser and Upload button, and a warning that an unsuitable image may prevent boot. No visible RAM boot control. This confirms the interface is reachable, but does not demonstrate successful stock restoration, accepted image format, flash write bounds or safe experimental installation. No firmware was uploaded in this observation.
