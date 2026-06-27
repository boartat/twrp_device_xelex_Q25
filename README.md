# OrangeFox device tree — Xelex/Zinwa Q25 (MT6789)

Recovery-in-`vendor_boot`, Virtual A/B, dynamic partitions, GKI, boot header v4.
Prebuilt kernel / dtb / recovery kernel-modules were extracted from the matched
LineageOS `BP4A.251205.006` images, so the recovery driver set is known-good for
this exact device.

## Build (GitHub Actions)
1. Push this repo to GitHub.
2. Actions tab → **Build OrangeFox (Q25)** → Run workflow.
3. Download `vendor_boot.img` from the run's artifacts.

Manifest branch: `12.1`. Build target: `vendorbootimage`. Output: `vendor_boot.img`.

## Flash (DO THIS CAREFULLY — bootloader must be unlocked)

> Back up the current vendor_boot FIRST. On this device the simplest restore image
> is the stock LineageOS `vendor_boot.img` you already have — keep it handy.

```
# 1. enter bootloader/fastboot
fastboot devices

# 2. flash the freshly built OrangeFox vendor_boot
fastboot flash vendor_boot vendor_boot.img

# 3. boot directly into recovery to test (do not let it boot system yet)
fastboot reboot recovery
```

If the screen is black / no touch → DO NOT flash anything else. Reboot to
bootloader and restore the stock vendor_boot:
```
fastboot flash vendor_boot <stock-lineage-vendor_boot.img>
```

## GSI + LiteGapps (after OrangeFox boots and touch works)
```
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot reboot fastboot
fastboot flash system system.img            # Android GSI (raw)
fastboot reboot recovery                     # OrangeFox
adb sideload LiteGapps-*.zip
fastboot reboot
```

## Notes / known tuning points
- Screen is 720x720 square; the portrait theme may not fill the panel perfectly.
  `adb sideload` works regardless of UI layout.
- `prebuilt/Image.gz`, `prebuilt/dtb/q25.dtb`, `prebuilt/modules/*.ko` are tied to
  LineageOS BP4A.251205.006. If you update the base, re-extract them.
