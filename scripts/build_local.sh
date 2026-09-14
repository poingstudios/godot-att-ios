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

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

on_error() {
    local exit_code="$1"
    local line_no="$2"
    echo -e "\n${RED}================================================================${NC}" >&2
    echo -e "${RED}[ERROR] build_local.sh failed at line ${line_no} (exit code ${exit_code})${NC}" >&2
    echo -e "${RED}================================================================${NC}\n" >&2
    exit "${exit_code}"
}
trap 'on_error $? $LINENO' ERR

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IOS_DIR="${ROOT_DIR}/platforms/ios"
BUILD_DIR="${IOS_DIR}/build"
DERIVED_DATA="${BUILD_DIR}/DerivedData"
ADDON_DIR="${ROOT_DIR}/platforms/godot_editor/addons/att"
BIN_DIR="${ADDON_DIR}/ios/bin"

show_help() {
    echo "Usage: ./scripts/build_local.sh [--clean]"
    echo ""
    echo "Options:"
    echo "  --clean   Remove build caches before compiling"
    echo "  --help    Show this help message"
}

CLEAN=false
for arg in "$@"; do
    if [ "${arg}" == "--help" ] || [ "${arg}" == "-h" ]; then
        show_help
        exit 0
    elif [ "${arg}" == "--clean" ]; then
        CLEAN=true
    fi
done

# Validate toolchain prerequisites
for tool in xcodebuild libtool xcrun; do
    if ! command -v "${tool}" &> /dev/null; then
        echo -e "${RED}[ERROR] Required tool '${tool}' is not installed or not in PATH.${NC}" >&2
        exit 1
    fi
done

if [ "$CLEAN" = true ]; then
    echo -e "${CYAN}==> Cleaning build directories...${NC}"
    rm -rf "${BUILD_DIR}"
    rm -rf "${BIN_DIR}"
fi

echo -e "${CYAN}==> Building Godot ATT Plugin (GDExtension Static XCFramework)...${NC}"
mkdir -p "${BUILD_DIR}"
mkdir -p "${BIN_DIR}"

cd "${IOS_DIR}"

# 1. Build Device Slice (arm64)
echo -e "${CYAN}>>> [1/5] Building iOS device slice (arm64)...${NC}"
xcodebuild build \
    -scheme GodotATTPlugin \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -derivedDataPath "${DERIVED_DATA}/device" \
    SKIP_INSTALL=NO \
    -quiet

# 2. Build Simulator Slice (universal arm64 + x86_64)
echo -e "${CYAN}>>> [2/5] Building iOS simulator slice (universal arm64 + x86_64)...${NC}"
xcodebuild build \
    -scheme GodotATTPlugin \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "${DERIVED_DATA}/sim" \
    SKIP_INSTALL=NO \
    -quiet

# 3. Assemble Static Libraries
echo -e "${CYAN}>>> [3/5] Packaging static libraries (.a)...${NC}"
DEVICE_PRODUCTS_DIR="${DERIVED_DATA}/device/Build/Products/Release-iphoneos"
if [ ! -d "${DEVICE_PRODUCTS_DIR}" ]; then
    DEVICE_PRODUCTS_DIR="${DERIVED_DATA}/device/Build/Products/Debug-iphoneos"
fi

SIM_PRODUCTS_DIR="${DERIVED_DATA}/sim/Build/Products/Release-iphonesimulator"
if [ ! -d "${SIM_PRODUCTS_DIR}" ]; then
    SIM_PRODUCTS_DIR="${DERIVED_DATA}/sim/Build/Products/Debug-iphonesimulator"
fi

if [ ! -d "${DEVICE_PRODUCTS_DIR}" ]; then
    echo -e "${RED}[ERROR] Device products directory not found: ${DEVICE_PRODUCTS_DIR}${NC}" >&2
    exit 1
fi

if [ ! -d "${SIM_PRODUCTS_DIR}" ]; then
    echo -e "${RED}[ERROR] Simulator products directory not found: ${SIM_PRODUCTS_DIR}${NC}" >&2
    exit 1
fi

DEVICE_LIB="${DEVICE_PRODUCTS_DIR}/libGodotATTPlugin.a"
SIM_LIB="${SIM_PRODUCTS_DIR}/libGodotATTPlugin.a"

if [ ! -f "${DEVICE_LIB}" ]; then
    echo -e "${RED}[ERROR] Device static library not found: ${DEVICE_LIB}${NC}" >&2
    exit 1
fi

if [ ! -f "${SIM_LIB}" ]; then
    echo -e "${RED}[ERROR] Simulator static library not found: ${SIM_LIB}${NC}" >&2
    exit 1
fi

# 4. Create XCFramework
echo -e "${CYAN}>>> [4/5] Assembling XCFramework...${NC}"
rm -rf "${BUILD_DIR}/GodotATTPlugin.xcframework"
xcodebuild -create-xcframework \
    -library "${DEVICE_LIB}" \
    -library "${SIM_LIB}" \
    -output "${BUILD_DIR}/GodotATTPlugin.xcframework"

# 5. Copy XCFramework into Addon distribution folder
echo -e "${CYAN}>>> [5/5] Deploying XCFramework to ${BIN_DIR}...${NC}"
rm -rf "${BIN_DIR}/GodotATTPlugin.xcframework"
cp -R "${BUILD_DIR}/GodotATTPlugin.xcframework" "${BIN_DIR}/GodotATTPlugin.xcframework"

if [ ! -d "${BIN_DIR}/GodotATTPlugin.xcframework" ]; then
    echo -e "${RED}[ERROR] Output XCFramework was not found at ${BIN_DIR}/GodotATTPlugin.xcframework!${NC}" >&2
    exit 1
fi

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}==> Build complete! Output ready at:${NC}"
echo -e "${GREEN}    ${BIN_DIR}/GodotATTPlugin.xcframework${NC}"
echo -e "${GREEN}================================================================${NC}\n"
