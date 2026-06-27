#
# Device makefile for Xelex/Zinwa Q25 (recovery build)
# Kept intentionally minimal — only things present in the OrangeFox minimal source.
# Vendor-specific HALs (bootctrl.mt6789, etc.) are NOT referenced here because they
# are not part of the OF source; A/B is handled by OrangeFox + FOX_VIRTUAL_AB_DEVICE.
#

LOCAL_PATH := device/xelex/Q25

# Soong namespace
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Virtual A/B snapshot daemon in the recovery ramdisk
PRODUCT_PACKAGES += \
    snapuserd \
    snapuserd.recovery

# Sideload / OTA helpers
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Recovery USB-gadget bringup (MUSB controller) — from stock recovery init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt6789.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6789.rc
