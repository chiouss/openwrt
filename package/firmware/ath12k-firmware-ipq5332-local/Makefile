#
# LOCAL: not for upstream.
#
# IPQ5332 ath12k firmware taken from the Zyxel QSDK (WLAN.WBE.1.4-01734,
# IPQ5332-only "5332.wlanfw.eval" build) and the Zyxel NWA50BE board data
# from the TIP wlan-ap tree. Neither is publicly redistributable.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ath12k-firmware-ipq5332-local
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

RSTRIP:=:
STRIP:=:

define Package/ath12k-firmware-ipq5332-local
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=IPQ5332 ath12k firmware and Zyxel NWA50BE board data (local)
  DEPENDS:=@TARGET_qualcommbe_ipq53xx
endef

define Build/Compile
endef

FW_DIR:=/lib/firmware/ath12k/IPQ5332/hw1.0

define Package/ath12k-firmware-ipq5332-local/install
	$(INSTALL_DIR) $(1)$(FW_DIR)
	$(INSTALL_DATA) ./files/q6_fw0.* ./files/q6_fw1.* ./files/iu_fw.* \
		$(1)$(FW_DIR)/
	# ath12k requests the UserPD images as .mbn; the MDT loader then
	# replaces the last three characters to find the .bNN segments.
	$(LN) q6_fw1.mdt $(1)$(FW_DIR)/q6_fw1.mbn
	$(LN) iu_fw.mdt $(1)$(FW_DIR)/iu_fw.mbn
	$(INSTALL_DATA) ./files/board-2.bin.zyxel_nwa50be \
		$(1)$(FW_DIR)/board-2.bin
endef

$(eval $(call BuildPackage,ath12k-firmware-ipq5332-local))
