#!/bin/bash
#
# OrangeFox build vars for Xelex/Zinwa Q25
# Virtual A/B device with recovery in vendor_boot
#

# --- core: Virtual A/B + vendor_boot recovery ---
export FOX_VIRTUAL_AB_DEVICE=1
export OF_VANDR_DEVICE=1
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1

# --- screen: 720x720 square panel ---
export OF_SCREEN_H=720
export OF_STATUS_H=80
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_CLOCK_POS=1
export OF_ALLOW_DISABLE_NAVBAR=0

# --- features ---
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_ENABLE_APP_MANAGER=1
export FOX_DELETE_AROMAFM=1
export OF_FLASHLIGHT_ENABLE=0
export OF_USE_GREEN_LED=0
export OF_KEEP_DM_VERITY=1
export OF_PATCH_AVB20=1

# --- maintainer / version ---
export FOX_VERSION="R12.1_0"
export OF_MAINTAINER="self"
export TARGET_DEVICE_ALT="q20_v12_factory,q20_v1_factory"

# Backup list offered in the OF UI
export OF_QUICK_BACKUP_LIST="/boot;/vendor_boot;"

# NOTE: add_lunch_combo is obsolete; lunch combos come from COMMON_LUNCH_CHOICES
# in AndroidProducts.mk. Do not call add_lunch_combo here (it errors under bash -e).
