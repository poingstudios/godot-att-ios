# Building from Source

Learn how to compile the native static XCFramework from the Swift source code.

---

## Prerequisites

- **macOS** with **Xcode 15+** installed
- **Xcode Command Line Tools** (`xcode-select --install`)
- Standard tools: `libtool`, `xcrun`, `xcodebuild`

---

## Automated Local Build Script

Run the automated build script located in the repository root:

```bash
./scripts/build_local.sh
```

### Build Steps Performed by the Script:

1. **Compiles Device Slice**: Builds `arm64` slice for physical iOS devices.
2. **Compiles Simulator Slice**: Builds universal `arm64` + `x86_64` slice for iOS Simulators.
3. **Packages Static Libraries**: Combines object files for `GodotATTPlugin` and `GodotSwiftPlugin` via `libtool`.
4. **Assembles XCFramework**: Runs `xcodebuild -create-xcframework`.
5. **Deploys Artifact**: Copies `GodotATTPlugin.xcframework` directly into:
   ```
   platforms/godot_editor/addons/att/ios/bin/GodotATTPlugin.xcframework
   ```

---

## Running Native Swift Tests

To execute the unit test suite against the Swift package:

```bash
./platforms/ios/scripts/test_local.sh
```
