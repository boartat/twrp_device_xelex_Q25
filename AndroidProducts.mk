PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/twrp_Q25.mk

# AOSP 14 lunch combos are 3-part: <product>-<release>-<variant>. Release = ap2a.
COMMON_LUNCH_CHOICES := \
    twrp_Q25-ap2a-eng \
    twrp_Q25-ap2a-userdebug \
    twrp_Q25-ap2a-user
