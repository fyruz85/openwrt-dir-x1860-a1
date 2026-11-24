# Experimental build and test gates

This branch contains a preliminary source-only candidate. It has not been compiled. Do not flash it or any resulting artifact. NAND and PCIe are disabled; only LAN is intended for first bring-up. GPIO, port numbering and load address still require validation.

The script prepares a clean checkout at upstream commit 13dc286814c646a2f03dc27e5bf2a34206e0242d. Install OpenWrt build dependencies on a Linux builder. Clone upstream, check out the pinned commit, then run:

    bash /path/to/port-repo/scripts/prepare-build.sh /path/to/openwrt
    cd /path/to/openwrt
    make download -j8
    make -j8 V=s

Build is not fully reproducible yet: feed revisions and builder environment must be locked before release. LuCI and radio support are deliberately omitted from the first candidate.

Validate generated FIT structure (dumpimage), DTB compatible string, disabled NAND/PCIe, kernel load/entry, compressed size, and RAM footprint. Confirm WireGuard packages and module ABI. Reject any factory/recovery/sysupgrade output. A build is not proof of bootloader acceptance.

## Physical gate

Before attempting to boot anything, confirm A1 emergency recovery UI (isolated wired PC, no WAN, back up config, no upload). Document its URL and screenshot without sensitive identifiers. A recovery interface alone does not establish a non-persistent boot method. If no safe RAM boot mechanism can be demonstrated without UART, stop. Do not use a recovery upload as a substitute.

Once verified RAM boot exists, use an isolated network, verify Ethernet link on each LAN port, inspect dmesg, and test a WireGuard interface in RAM. Do not connect to production or set credentials in source. Reboot to confirm stock remains intact.

Persistent storage, Wi-Fi calibration, MAC addresses, WAN, firmware packaging, recovery and rollback must be validated separately.
