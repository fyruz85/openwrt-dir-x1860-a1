# No-UART research closure — 2026-11-26

Reviewed existing owner firmware inspection in [board-evidence.md](board-evidence.md), recovery screenshot findings in [recovery-observation.md](recovery-observation.md), and [v0.6 notes](v0.6-wifi-candidate.md). These are prior offline inspection records, not a fresh binary extraction.

## Corroboration

The [A1 OEM boot log](https://openwrt.org/inbox/toh/d-link/dir-x1860_a1) agrees with the recorded stock FIT kernel version, load/entry address, DTB length and NAND partition geometry. It identifies Alpha WRGAX10, MT7915 and concurrent dual-band initialization. Driver flash offset zero has no established absolute base; the logged RAM pointer differences 0xe00 and 0xe10 describe vendor buffer layout, not verified on-flash offsets or upstream mt76 cell sizes. Exact vendor read implementation remains missing. The B1 [upstream commit](https://lists.infradead.org/pipermail/lede-commits/2025-October/027569.html) is not an A1 mapping reference.

## Boot entry

The A1 log identifies UART as U-Boot input and exposes a load-and-run menu item. It does not demonstrate how to invoke that item over Ethernet, nor its implementation or absence of writes. Stock failsafe instructions are serial-based. The owner recovery screenshot shows upload, not a RAM execution control. The [DAP-X1860 A1 TFTP test](https://lists.openwrt.org/pipermail/openwrt-devel/2023-January/040166.html) concerns a different product. No documented stock Ethernet diagnostic shell or nonpersistent boot entry was verified.

## GPL blocker and stopping condition

Searches for exact DIR-X1860 A1 / Alpha WRGAX10 GPL source did not establish a matching downloadable archive. The [official GPL portal](https://tsd.dlink.com.tw/GPL/) explicitly offers corresponding source on written request to GPLCODE@dlink.com; request exact hardware revision A1 and firmware builds 1.02B06 / 1.03B07, including applicable U-Boot, kernel and board-specific source. No request was sent. Public search exhaustion is not proof that the archive or an Ethernet boot mechanism does not exist. Resume only on new source, offline diagnostic evidence, or separately authorized hardware validation.

No runnable changes or new build warranted. Preserve existing RAM-only artifacts; no NAND/PCIe enablement, persistent image, release, main merge, live access or flashing.
