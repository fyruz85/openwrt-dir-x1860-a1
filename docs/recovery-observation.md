# A1 recovery observation

2026-11-24: Device owner confirms the emergency recovery page is accessible on their DIR-X1860 A1. This is an owner-reported observation, not a verified successful recovery or RAM boot. URL, page controls, bootloader version, accepted file format and ability to restore stock remain unverified.

Upstream B1 instructions use the recovery UI to install a persistent recovery image; this is not evidence of a RAM-only boot option on A1. Reference: https://lists.infradead.org/pipermail/lede-commits/2025-October/027569.html

Next: obtain a screenshot of the A1 recovery page (no firmware upload). Investigate a non-persistent boot path. Do not upload an experimental image or a different hardware revision's image. Compile and validate the RAM-only candidate independently of this gate.
