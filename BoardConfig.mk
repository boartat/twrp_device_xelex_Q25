#
# OrangeFox device tree for Xelex/Zinwa Q25 (MT6789)
# Recovery lives in vendor_boot (Virtual A/B, dynamic partitions, GKI, boot header v4)
# Prebuilt kernel/dtb/recovery-modules extracted from LineageOS BP4A.251205.006
#

DEVICE_PATH := device/xelex/Q25

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_BOARD_PLATFORM := mt6789
TARGET_BOOTLOADER_BOARD_NAME := q20_v12_factory
TARGET_NO_BOOTLOADER := true

# Assertions
TARGET_OTA_ASSERT_DEVICE := Q25,q20_v12_factory,q20_v1_factory

# Kernel (prebuilt, extracted from stock/LOS boot.img)
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb

BOARD_KERNEL_BASE := 0x3fff8000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x26f08000
BOARD_KERNEL_TAGS_OFFSET := 0x07c88000
BOARD_DTB_OFFSET := 0x07c88000

BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2

BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --board ""
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)

# GKI / recovery-in-vendor_boot
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

# Recovery rides in vendor_boot (not in boot). Do NOT set TARGET_NO_RECOVERY:=true —
# that disables building the recovery image entirely, leaving vendorbootimage with
# "no work to do". The recovery resources are moved into vendor_boot above.
BOARD_USES_RECOVERY_AS_BOOT :=

# Image sizes / partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_SUPER_PARTITION_SIZE := 9663676416
BOARD_USES_METADATA_PARTITION := true

# Dynamic partitions
BOARD_SUPER_PARTITION_GROUPS := mediatek_dynamic_partitions
BOARD_MEDIATEK_DYNAMIC_PARTITIONS_PARTITION_LIST := odm_dlkm product system system_ext vendor vendor_dlkm
BOARD_MEDIATEK_DYNAMIC_PARTITIONS_SIZE := 4827643904

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += boot vendor_boot dtbo system system_ext product vendor vendor_dlkm odm_dlkm vbmeta vbmeta_system vbmeta_vendor

# Filesystems
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Recovery kernel modules: BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES did NOT get
# the prebuilt .ko into the OF recovery fragment (verified: 0 modules in the built
# ramdisk). Instead the modules are shipped directly under recovery/root/lib/modules
# (the OF recovery rule copies recovery/root verbatim), matching the LineageOS layout
# that is known to drive this panel/touch. first_stage_init loads them via modules.load.

# Verified Boot (signed with testkey; bootloader is unlocked so AVB is non-enforcing)
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 1

# Metadata / crypto
BOARD_USES_METADATA_PARTITION := true

# ---------------------------------------------------------------------------
# TWRP / OrangeFox flags  (tune these during build iterations)
# ---------------------------------------------------------------------------
TW_DEVICE_VERSION := Q25-prebuilt-v1
# Required by OrangeFox (orangefox.mk errors if unset). Exact panel max is unknown
# (leds-mtk-disp); 255 is the common default and only affects the brightness slider.
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 150
# OrangeFox only ships the portrait_hdpi theme. This is a 720x720 SQUARE screen;
# the auto-selector (gui/soong/makevars.go -> determineTheme) maps square -> watch_mdpi,
# which OF does NOT ship -> theme failure. The selector reads TW_THEME from the soong
# "twrpVarsPlugin" namespace, so we pin it there directly (the build's auto-export of
# BoardConfig TW_* vars was not reaching soong: observed "TW_THEME: not set").
TW_THEME := portrait_hdpi
# The soong namespace injection that OrangeFox's theme selector actually reads is
# done with the canonical macro in device.mk (product config), not here.
# TARGET_SCREEN_WIDTH/HEIGHT intentionally omitted: square 720x720 breaks auto-select.
RECOVERY_SDCARD_ON_DATA := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_USE_TOOLBOX := true
TW_INCLUDE_FASTBOOTD := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_NTFS_3G := true
TW_NO_SCREEN_BLANK := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TARGET_USES_MKE2FS := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
# Far-future security patch silences AVB rollback nags. PLATFORM_VERSION is left
# at the OF 12.1 default on purpose (forcing 16.0.0 conflicts with the 12.1 base).
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := 2127-12-31
