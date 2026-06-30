#
# Device makefile for Xelex/Zinwa Q25 (recovery build)
# Kept intentionally minimal — only things present in the OrangeFox minimal source.
# Vendor-specific HALs (bootctrl.mt6789, etc.) are NOT referenced here because they
# are not part of the OF source; A/B is handled by OrangeFox + FOX_VIRTUAL_AB_DEVICE.
#

LOCAL_PATH := device/xelex/Q25

# Soong namespace
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# --- Recovery theme ---------------------------------------------------------
# OrangeFox's theme selector lives in soong (gui/soong/makevars.go ->
# determineTheme) and reads TW_THEME from the "twrpVarsPlugin" soong namespace.
# On this build that namespace comes up empty (theme error "TW_THEME: not set"),
# so register and populate it explicitly here with the canonical product-config
# macros. OF ships only the portrait_hdpi theme, and this is a 720x720 square
# screen whose resolution would otherwise auto-map to the (missing) watch_mdpi.
$(call add_soong_config_namespace,twrpVarsPlugin)
# 720x720 SQUARE panel -> use TWRP's square 'watch_mdpi' theme (portrait_hdpi 1080x1920
# stretched onto the square panel rendered garbage and SIGSEGV'd at main-page render;
# diagnosed live via adb on the merge image). watch_mdpi is square -> uniform upscale.
$(call add_soong_config_var_value,twrpVarsPlugin,TW_THEME,watch_mdpi)

# Recovery pixel format ALSO reaches libminuitwrp via the same twrpVarsPlugin soong
# namespace: minuitwrp/libminuitwrp_defaults.go does
#   strings.Replace(getMakeVars(ctx,"TARGET_RECOVERY_PIXEL_FORMAT"),"\"","",-1)
#   switch { case "BGRA_8888": cflags += "-DRECOVERY_BGRA" ... }
# and getMakeVars reads ctx.Config().VendorConfig("twrpVarsPlugin"). Setting it only as
# a BoardConfig make var (as we did) leaves IsSet()=false -> "" -> no -DRECOVERY_BGRA ->
# minui falls back to RGBA (runtime log showed ARGB/RGBA) -> wrong format vs this BGRA
# panel -> memcpy SIGSEGV at first page render + colour glitch. Register it here so the
# soong plugin actually receives BGRA_8888 (quotes are stripped by the .go, so unquoted).
$(call add_soong_config_var_value,twrpVarsPlugin,TARGET_RECOVERY_PIXEL_FORMAT,BGRA_8888)

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# --- Recovery rootfs base -------------------------------------------------
# Root cause of the bootloop: with vendor_boot recovery (no standalone recovery.img,
# INSTALLED_RECOVERYIMAGE_TARGET was empty) BUILDING_RECOVERY_IMAGE was effectively off,
# so the recovery program + base rootfs (init, sh, toybox) were never built — only 53
# files landed in recovery/root, no system/bin/recovery, no init -> bootloop.
# Force the recovery image build on so the full recovery rootfs gets pulled, and also
# request the recovery program explicitly as belt-and-suspenders.
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_PACKAGES += recovery

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

# cgroup task profiles: the recovery ramdisk packaging rule (twrp_ramdisk-timestamp)
# copies $(TARGET_OUT)/etc/task_profiles.json into recovery/root, but in a recovery-only
# build that module isn't staged -> "cp: task_profiles.json: No such file" at 99%.
# Force-build it (and cgroups.json) so it lands in system/etc for the copy.
PRODUCT_PACKAGES += \
    task_profiles.json \
    cgroups.json

# Recovery USB-gadget bringup (MUSB controller) — from stock recovery init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt6789.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt6789.rc
