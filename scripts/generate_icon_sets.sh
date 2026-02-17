#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 The Khatu Family Trust
# -----------------------------------------------------------------------------
# File: scripts/generate_icon_sets.sh
# File Version: 1.2.0
# Framework : Core App Tech Utilities (Catu) Framework
# Author: Neil Khatu
# -----------------------------------------------------------------------------

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_ICON="$ROOT_DIR/assets/Catu.png"

if [[ ! -f "$SOURCE_ICON" ]]; then
  echo "Source icon not found: $SOURCE_ICON"
  exit 1
fi

if ! command -v sips >/dev/null 2>&1; then
  echo "Missing required tool: sips"
  exit 1
fi

resize_icon() {
  local size="$1"
  local output="$2"

  mkdir -p "$(dirname "$output")"
  sips -z "$size" "$size" "$SOURCE_ICON" --out "$output" >/dev/null
}

generate_android_set() {
  local root="$1"
  while read -r dpi size; do
    resize_icon "$size" "$root/mipmap-$dpi/ic_launcher.png"
    resize_icon "$size" "$root/mipmap-$dpi/ic_launcher_round.png"
  done <<'ICON_SIZES'
mdpi 48
hdpi 72
xhdpi 96
xxhdpi 144
xxxhdpi 192
ICON_SIZES
}

generate_ios_icon_files() {
  local root="$1"

  find "$root" -maxdepth 1 -type f -name '*.png' -delete

  while read -r filename size; do
    resize_icon "$size" "$root/$filename"
  done <<'ICON_FILES'
icon_20@1x.png 20
icon_20@2x.png 40
icon_20@3x.png 60
icon_29@1x.png 29
icon_29@2x.png 58
icon_29@3x.png 87
icon_40@1x.png 40
icon_40@2x.png 80
icon_40@3x.png 120
icon_60@2x.png 120
icon_60@3x.png 180
icon_76@1x.png 76
icon_76@2x.png 152
icon_83.5@2x.png 167
icon_1024@1x.png 1024
ICON_FILES
}

generate_ios_xcode_icon_files() {
  local root="$1"

  while read -r filename size; do
    resize_icon "$size" "$root/$filename"
  done <<'ICON_FILES'
Icon-App-20x20@1x.png 20
Icon-App-20x20@2x.png 40
Icon-App-20x20@3x.png 60
Icon-App-29x29@1x.png 29
Icon-App-29x29@2x.png 58
Icon-App-29x29@3x.png 87
Icon-App-40x40@1x.png 40
Icon-App-40x40@2x.png 80
Icon-App-40x40@3x.png 120
Icon-App-60x60@2x.png 120
Icon-App-60x60@3x.png 180
Icon-App-76x76@1x.png 76
Icon-App-76x76@2x.png 152
Icon-App-83.5x83.5@2x.png 167
Icon-App-1024x1024@1x.png 1024
ICON_FILES
}

ANDROID_TARGETS=(
  "$ROOT_DIR/assets/icons/android"
  "$ROOT_DIR/catu_full_ios_android_icon_pack/Android_mipmap"
  "$ROOT_DIR/example/android/app/src/main/res"
)

IOS_TARGETS=(
  "$ROOT_DIR/assets/icons/ios/AppIcon.appiconset"
  "$ROOT_DIR/catu_full_ios_android_icon_pack/iOS_AppIcon.appiconset"
  "$ROOT_DIR/example/ios/Runner/Assets.xcassets/AppIcon.appiconset"
)

for target in "${ANDROID_TARGETS[@]}"; do
  generate_android_set "$target"
  echo "Generated Android icons: $target"
done

for target in "${IOS_TARGETS[@]}"; do
  generate_ios_icon_files "$target"
  echo "Generated iOS icons: $target"
done

generate_ios_xcode_icon_files "$ROOT_DIR/example/ios/Runner/Assets.xcassets/AppIcon.appiconset"
echo "Generated iOS Xcode-prefixed icons in example app set"

echo "Icon generation complete. Source: $SOURCE_ICON"
