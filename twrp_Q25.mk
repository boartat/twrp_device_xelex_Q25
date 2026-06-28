#
# OrangeFox / TWRP product makefile for Xelex/Zinwa Q25
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from Q25 device.
$(call inherit-product, device/xelex/Q25/device.mk)

# Inherit common OrangeFox/TWRP config.
$(call inherit-product, vendor/twrp/config/common.mk)

# TWRP/OF recovery installs its libs (libtwrp*, libadbd, librecovery, ...) and
# init.recovery.*.rc into system/ and root/, which trips generic_system's artifact
# path requirement. In this AOSP 12 build, ANY non-empty enforcement value errors
# (the "relaxed" downgrade only exists in newer AOSP), so instead whitelist the
# offending path prefixes so the offending-file list becomes empty.
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    root/% \
    system/%

PRODUCT_DEVICE := Q25
PRODUCT_NAME := twrp_Q25
PRODUCT_BRAND := Xelex
PRODUCT_MODEL := Zinwa Q25
PRODUCT_MANUFACTURER := Xelex

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=Q25 \
    PRODUCT_NAME=lineage_Q25 \
    BuildFingerprint=Xelex/lineage_Q25/Q25:16/BP4A.251205.006/e71a79462f:userdebug/release-keys
