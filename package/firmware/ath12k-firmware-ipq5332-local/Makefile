#
# LOCAL: not for upstream.
#
# IPQ5332 ath12k firmware taken from the Zyxel QSDK (WLAN.WBE.1.4-01734,
# IPQ5332-only "5332.wlanfw.eval" build), QCN9274 firmware from the Zyxel
# QSDK (WLAN.WBE.1.4-01734, qcn9224 images of the NWA110BE/WBE510D Wi-Fi
# firmware image) and Zyxel board data (NWA50BE from the TIP wlan-ap tree,
# NWA110BE from the Zyxel QSDK). None of it is publicly redistributable.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ath12k-firmware-ipq5332-local
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

RSTRIP:=:
STRIP:=:

define Package/ath12k-local-default
  SECTION:=firmware
  CATEGORY:=Firmware
  DEPENDS:=@TARGET_qualcommbe_ipq53xx
endef

define Package/ath12k-firmware-ipq5332-local
$(Package/ath12k-local-default)
  TITLE:=IPQ5332 ath12k firmware (local)
endef

define Package/ath12k-firmware-qcn9274-local
$(Package/ath12k-local-default)
  TITLE:=QCN9274 ath12k firmware (local)
  CONFLICTS:=ath12k-firmware-qcn9274
endef

define Package/ath12k-board-zyxel_nwa50be
$(Package/ath12k-local-default)
  TITLE:=Zyxel NWA50BE ath12k board data (local)
endef

define Package/ath12k-board-zyxel_nwa110be
$(Package/ath12k-local-default)
  TITLE:=Zyxel NWA110BE ath12k board data (local)
endef

# The QCN9274 images are packed into firmware-2.bin, which carries the
# firmware feature flags ath12k needs (see mkfw2.py).
define Build/Compile
	$(STAGING_DIR_HOST)/bin/python3 ./mkfw2.py \
		./files/qcn9274/amss.bin ./files/qcn9274/amss_dualmac.bin \
		./files/qcn9274/m3.bin $(SOURCE_DATE_EPOCH) \
		$(PKG_BUILD_DIR)/firmware-2.bin.qcn9274
endef

IPQ5332_DIR:=/lib/firmware/ath12k/IPQ5332/hw1.0
QCN9274_DIR:=/lib/firmware/ath12k/QCN9274/hw2.0

define Package/ath12k-firmware-ipq5332-local/install
	$(INSTALL_DIR) $(1)$(IPQ5332_DIR)
	$(INSTALL_DATA) ./files/q6_fw0.* ./files/q6_fw1.* ./files/iu_fw.* \
		$(1)$(IPQ5332_DIR)/
	# ath12k requests the UserPD images as .mbn; the MDT loader then
	# replaces the last three characters to find the .bNN segments.
	$(LN) q6_fw1.mdt $(1)$(IPQ5332_DIR)/q6_fw1.mbn
	$(LN) iu_fw.mdt $(1)$(IPQ5332_DIR)/iu_fw.mbn
endef

define Package/ath12k-firmware-qcn9274-local/install
	$(INSTALL_DIR) $(1)$(QCN9274_DIR)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/firmware-2.bin.qcn9274 \
		$(1)$(QCN9274_DIR)/firmware-2.bin
endef

define Package/ath12k-board-zyxel_nwa50be/install
	$(INSTALL_DIR) $(1)$(IPQ5332_DIR)
	$(INSTALL_DATA) ./files/board-2.bin.zyxel_nwa50be \
		$(1)$(IPQ5332_DIR)/board-2.bin
endef

define Package/ath12k-board-zyxel_nwa110be/install
	$(INSTALL_DIR) $(1)$(IPQ5332_DIR) $(1)$(QCN9274_DIR)
	$(INSTALL_DATA) ./files/board-2.bin.zyxel_nwa110be \
		$(1)$(IPQ5332_DIR)/board-2.bin
	# no board-2.bin for the QCN9274, ath12k falls back to board.bin
	$(INSTALL_DATA) ./files/board.bin.zyxel_nwa110be.qcn9274 \
		$(1)$(QCN9274_DIR)/board.bin
endef

$(eval $(call BuildPackage,ath12k-firmware-ipq5332-local))
$(eval $(call BuildPackage,ath12k-firmware-qcn9274-local))
$(eval $(call BuildPackage,ath12k-board-zyxel_nwa50be))
$(eval $(call BuildPackage,ath12k-board-zyxel_nwa110be))
