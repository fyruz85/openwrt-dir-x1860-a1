# Experimental profile: no factory, recovery, or sysupgrade image.
define Device/dlink_dir-x1860-a1
  DEVICE_VENDOR := D-Link
  DEVICE_MODEL := DIR-X1860
  DEVICE_VARIANT := A1 (experimental RAM only)
  DEVICE_DTS := mt7621_dlink_dir-x1860-a1
  DEVICE_PACKAGES := kmod-wireguard wireguard-tools -uboot-envtools
  KERNEL_LOADADDR := 0x82000000
  KERNEL_INITRAMFS := kernel-bin | relocate-kernel $(loadaddr-y) | lzma | \
	fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  IMAGES :=
endef
TARGET_DEVICES += dlink_dir-x1860-a1
