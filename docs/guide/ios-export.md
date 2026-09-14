# iOS Export Configuration

The ATT plugin includes an internal `EditorExportPlugin` that automatically configures your exported Xcode project.

---

## What the Export Plugin Configures Automatically

When you export your Godot project for iOS (`Project -> Export -> iOS`), the plugin automatically performs the following tasks:

1. **Links Native Framework**:
   - Adds `AppTrackingTransparency.framework` to your exported Xcode project's linked frameworks.

2. **Sets Plist Usage Description**:
   - Injects the `NSUserTrackingUsageDescription` key into the generated `Info.plist`.
   - The value is read from your project settings (`plugins/att/ios/user_tracking_usage_description`).

3. **Adds Linker Flags**:
   - Injects `-ObjC` into the Xcode target's `OTHER_LDFLAGS` to ensure Objective-C runtime classes and symbols are retained by the static linker.

---

## Verifying in the Export Preset

In Godot's Export window (**Project -> Export -> iOS**):
1. In the **Architectures** section, select `arm64` (and `arm64 Simulator` if testing on Mac Apple Silicon simulators).
2. Ensure the **GDExtension** tag `ios` is active.
3. Export the project to generate your `.xcodeproj`.
