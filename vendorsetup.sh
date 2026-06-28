#!/bin/bash
#
# TWRP build vars for Xelex/Zinwa Q25 (Virtual A/B, recovery in vendor_boot).
#
# Under plain TWRP (minimal-manifest twrp-14.1) the recovery is configured entirely
# through BOARD_*/TW_* in BoardConfig.mk and the product makefiles — there are no
# FOX_*/OF_* variables to set here (those were OrangeFox-only and are ignored by TWRP).
#
# vendor_boot recovery + Virtual A/B are driven by, in BoardConfig.mk:
#   BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
#   BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
#   BOARD_USES_GENERIC_KERNEL_IMAGE := true
# and A/B via AB_OTA_UPDATER / AB_OTA_PARTITIONS.
#
# Lunch combos come from COMMON_LUNCH_CHOICES in AndroidProducts.mk; do NOT call
# add_lunch_combo here (obsolete, and it errors under bash -e).
