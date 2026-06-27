#
# OrangeFox / TWRP product makefile for Xelex/Zinwa Q25
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Inherit from Q25 device.
$(call inherit-product, device/xelex/Q25/device.mk)

# Inherit common OrangeFox/TWRP config.
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := Q25
PRODUCT_NAME := twrp_Q25
PRODUCT_BRAND := Xelex
PRODUCT_MODEL := Zinwa Q25
PRODUCT_MANUFACTURER := Xelex

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=Q25 \
    PRODUCT_NAME=lineage_Q25 \
    BuildFingerprint=Xelex/lineage_Q25/Q25:16/BP4A.251205.006/e71a79462f:userdebug/release-keys
