PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

remove_oem_ubi_volume() {
	local oem_volume_name="$1"
	local oem_ubivol
	local mtdnum
	local ubidev

	mtdnum=$(find_mtd_index "$CI_UBIPART")
	if [ ! "$mtdnum" ]; then
		return
	fi

	ubidev=$(nand_find_ubi "$CI_UBIPART")
	if [ ! "$ubidev" ]; then
		ubiattach --mtdn="$mtdnum"
		ubidev=$(nand_find_ubi "$CI_UBIPART")
	fi

	if [ "$ubidev" ]; then
		oem_ubivol=$(nand_find_volume "$ubidev" "$oem_volume_name")
		[ "$oem_ubivol" ] && ubirmvol "/dev/$ubidev" --name="$oem_volume_name"
	fi
}

platform_check_image() {
	return 0
}

platform_do_upgrade() {
	case "$(board_name)" in
	zyxel,nwa110be|\
	zyxel,nwa50be)
		# Zyxel U-Boot always passes ubi.mtd=rootfs, so OpenWrt
		# can only run from image0. The zyxel-bootconfig preinit
		# hook keeps image0 selected in 0:bootconfig{,1}.
		CI_UBIPART="rootfs"
		remove_oem_ubi_volume ubi_rootfs
		remove_oem_ubi_volume wifi_fw
		nand_do_upgrade "$1"
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}
