#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2026-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IOS_DIR="${ROOT_DIR}/platforms/ios"
BUILD_DIR="${IOS_DIR}/build"
DERIVED_DATA="${BUILD_DIR}/DerivedData"
ADDON_DIR="${ROOT_DIR}/platforms/godot_editor/addons/att"
BIN_DIR="${ADDON_DIR}/ios/bin"
CORE_PLUGIN_DIR="${ROOT_DIR}/../godot-swift-plugin"
SWIFT_BRIDGE_LIB_DEVICE="${CORE_PLUGIN_DIR}/Sources/GodotSwiftPlugin/Bridge/lib/libGodotSwiftBridge_device.a"
SWIFT_BRIDGE_LIB_SIM="${CORE_PLUGIN_DIR}/Sources/GodotSwiftPlugin/Bridge/lib/libGodotSwiftBridge_sim.a"

show_help() {
    echo "Usage: ./scripts/build_local.sh [ios] [--clean]"
    echo ""
    echo "Options:"
    echo "  ios       Build GodotATTPlugin.xcframework for iOS (device + simulator)"
    echo "  --clean   Remove build caches before compiling"
    echo "  --help    Show this help message"
}

TARGET_PLATFORM="${1:-ios}"
if [ "${TARGET_PLATFORM}" == "--help" ] || [ "${TARGET_PLATFORM}" == "-h" ]; then
    show_help
    exit 0
fi

CLEAN=false
for arg in "$@"; do
    if [ "$arg" == "--clean" ]; then
        CLEAN=true
    fi
done

if [ "$CLEAN" = true ]; then
    echo "==> Cleaning build directories..."
    rm -rf "${BUILD_DIR}"
    rm -rf "${BIN_DIR}"
fi

echo "==> Building Godot ATT Plugin (Static XCFramework)..."
mkdir -p "${BUILD_DIR}"
mkdir -p "${BIN_DIR}"

cd "${IOS_DIR}"

# 1. Build Device Slice (arm64)
echo ">>> Archiving iOS device slice (arm64)..."
xcodebuild archive \
    -scheme GodotATTPlugin \
    -destination "generic/platform=iOS" \
    -archivePath "${BUILD_DIR}/ios_device.xcarchive" \
    -derivedDataPath "${DERIVED_DATA}/device" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# 2. Build Simulator Slice (arm64 + x86_64)
echo ">>> Building iOS simulator slice (universal arm64 + x86_64)..."
xcodebuild build \
    -scheme GodotATTPlugin \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "${DERIVED_DATA}/sim" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    -quiet

# 3. Assemble Framework Bundles
echo ">>> Packaging static framework bundles..."
DEVICE_OBJS_DIR="$(find "${BUILD_DIR}/ios_device.xcarchive/Products" -type d -name "Objects" | head -n 1)"
SIM_PRODUCTS_DIR="${DERIVED_DATA}/sim/Build/Products/Release-iphonesimulator"
if [ ! -d "${SIM_PRODUCTS_DIR}" ]; then
    SIM_PRODUCTS_DIR="${DERIVED_DATA}/sim/Build/Products/Debug-iphonesimulator"
fi

DEVICE_FW="${BUILD_DIR}/frameworks/device/GodotATTPlugin.framework"
SIM_FW="${BUILD_DIR}/frameworks/sim/GodotATTPlugin.framework"

rm -rf "${BUILD_DIR}/frameworks"
mkdir -p "${DEVICE_FW}/Modules" "${SIM_FW}/Modules"

# Create static binaries inside framework bundles (including precompiled bridge)
libtool -static -o "${DEVICE_FW}/GodotATTPlugin" \
    "${DEVICE_OBJS_DIR}/GodotATTPlugin.o" \
    "${DEVICE_OBJS_DIR}/GodotSwiftPlugin.o" \
    "${SWIFT_BRIDGE_LIB_DEVICE}"

libtool -static -o "${SIM_FW}/GodotATTPlugin" \
    "${SIM_PRODUCTS_DIR}/GodotATTPlugin.o" \
    "${SIM_PRODUCTS_DIR}/GodotSwiftPlugin.o" \
    "${SWIFT_BRIDGE_LIB_SIM}"

# Copy Swift module interfaces
DEVICE_SWIFTMODULE="$(find "${DERIVED_DATA}/device" -type d -name "GodotATTPlugin.swiftmodule" | head -n 1)"
SIM_SWIFTMODULE="$(find "${DERIVED_DATA}/sim" -type d -name "GodotATTPlugin.swiftmodule" | head -n 1)"

if [ -d "${DEVICE_SWIFTMODULE}" ]; then
    cp -R "${DEVICE_SWIFTMODULE}" "${DEVICE_FW}/Modules/"
fi
if [ -d "${SIM_SWIFTMODULE}" ]; then
    cp -R "${SIM_SWIFTMODULE}" "${SIM_FW}/Modules/"
fi

# Generate Info.plist for framework bundles
create_framework_plist() {
    local target_plist="$1"
    cat << 'EOF' > "${target_plist}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>GodotATTPlugin</string>
    <key>CFBundleIdentifier</key>
    <string>com.poingstudios.godotattplugin</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>GodotATTPlugin</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF
}

create_framework_plist "${DEVICE_FW}/Info.plist"
create_framework_plist "${SIM_FW}/Info.plist"

# 4. Create XCFramework
echo ">>> Assembling XCFramework..."
rm -rf "${BUILD_DIR}/GodotATTPlugin.xcframework"
xcodebuild -create-xcframework \
    -framework "${DEVICE_FW}" \
    -framework "${SIM_FW}" \
    -output "${BUILD_DIR}/GodotATTPlugin.xcframework"

# 5. Copy XCFramework into Addon distribution folder
echo ">>> Deploying XCFramework to ${BIN_DIR}..."
rm -rf "${BIN_DIR}/GodotATTPlugin.xcframework"
cp -R "${BUILD_DIR}/GodotATTPlugin.xcframework" "${BIN_DIR}/GodotATTPlugin.xcframework"

echo "==> Build complete! Output ready at: ${BIN_DIR}/GodotATTPlugin.xcframework"
