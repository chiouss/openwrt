DEVICE_VARS += ZYXEL_MODEL_ID_0 ZYXEL_MODEL_ID_1 ZYXEL_MODEL_ID_2 \
	ZYXEL_MODEL_ID_3 ZYXEL_MODEL_ID_4

define Build/fit-inline-rootfs
	rm -f $@.dtb $@.kernel
	cp $@ $@.kernel
	cp $(word 2,$(1)) $@.dtb
	cp $@.kernel $@
	$(call Build/fit-its,$(word 1,$(1)) $@.dtb with-rootfs)
	$(call Build/fit-image,$(word 1,$(1)) $@.dtb with-rootfs)
	kernel_size="$$(stat -c%s $@.kernel)"; \
	rootfs_offset="$$(grep -oba hsqs $@ | \
		awk -F: -v limit="$$kernel_size" '$$1 >= limit {print $$1; exit}')"; \
	[ -n "$$rootfs_offset" ] || { echo "Failed to locate SquashFS in $@"; exit 1; }; \
	pad="$$(( (4096 - ($$rootfs_offset % 4096)) % 4096 ))"; \
	cp $(word 2,$(1)) $@.dtb; \
	dd if=/dev/zero bs=1 count="$$pad" >> $@.dtb 2>/dev/null; \
	cp $@.kernel $@; \
	$(call Build/fit-its,$(word 1,$(1)) $@.dtb with-rootfs)
	$(call Build/fit-image,$(word 1,$(1)) $@.dtb with-rootfs)
	kernel_size="$$(stat -c%s $@.kernel)"; \
	rootfs_offset="$$(grep -oba hsqs $@ | \
		awk -F: -v limit="$$kernel_size" '$$1 >= limit {print $$1; exit}')"; \
	[ "$$(( $$rootfs_offset % 4096 ))" -eq 0 ] || { echo "SquashFS is misaligned in $@"; exit 1; }; \
	rm -f $@.dtb $@.kernel
endef

define Build/zyxel-fit-ipq53xx
	$(TOPDIR)/scripts/mkits-zyxel-fit-filogic.sh \
		$@.its $@ "$(foreach i,0 1 2 3 4,$(or $(ZYXEL_MODEL_ID_$(i)),ff ff))"
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv $@.new $@
endef

define Device/zyxel_nwa50be
	$(call Device/FitImageLzma)
	$(call Device/UbiFit)
	DEVICE_VENDOR := Zyxel
	DEVICE_MODEL := NWA50BE
	DEVICE_ALT0_VENDOR := Zyxel
	DEVICE_ALT0_MODEL := NWA50BE PRO
	DEVICE_ALT1_VENDOR := Zyxel
	DEVICE_ALT1_MODEL := NWA90BE
	DEVICE_ALT2_VENDOR := Zyxel
	DEVICE_ALT2_MODEL := NWA90BE PRO
	DEVICE_DTS := ipq5332-zyxel-nwa50be
	DEVICE_DTS_CONFIG := config@mi01.3
	SOC := ipq5332
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	NAND_SIZE := 256m
	IMAGE_SIZE := 71680k
	IMAGES += factory.bin
	IMAGE/factory.bin := append-ubi | check-size $$$$(IMAGE_SIZE) | zyxel-fit-ipq53xx
	ZYXEL_MODEL_ID_0 := 94 e1
	ZYXEL_MODEL_ID_1 := 95 e1
	ZYXEL_MODEL_ID_2 := 96 e1
	ZYXEL_MODEL_ID_3 := 97 e1
	DEVICE_PACKAGES := kmod-ath12k ath12k-firmware-ipq5332-local \
		zyxel-bootconfig-ipq807x
endef
TARGET_DEVICES += zyxel_nwa50be
