# Godot ATT iOS

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official-grade Apple **App Tracking Transparency (ATT)** plugin for **Godot 4.6+** on iOS, powered by [Godot Swift Plugin](https://github.com/poingstudios/godot-swift-plugin).

It enables games and applications to request tracking authorization and query authorization status via iOS native `AppTrackingTransparency.framework`.

---

## Requirements

- **Godot Engine**: 4.6+
- **iOS Target**: iOS 14.0+
- **Xcode**: 15.0+ (Swift 5.9+)
- **Architecture**: arm64 (Device) & arm64/x86_64 (Simulator)

---

## Features

- **Pure Swift**: Implemented using Apple's official `AppTrackingTransparency` framework.
- **Pure GDExtension**: Zero C++ bridge overhead via Godot Swift Plugin.
- **Auto Export Setup**: Automatically injects `NSUserTrackingUsageDescription`, links `AppTrackingTransparency.framework`, and adds `-ObjC` linker flag upon export.
- **Signals & Status Enum**: Idiomatic GDScript singleton API with typed `Status` enum.
- **Desktop Editor Safe**: Includes fallback mocks so desktop editor workflows run without crashes.

---

## Installation

1. Download or clone this repository.
2. Copy the `addons/att/` folder into your Godot project's `res://addons/` directory.
3. Open **Project -> Project Settings -> Plugins** and enable the **ATT** plugin.

---

## Usage

```gdscript
extends Control


func _ready() -> void:
	ATT.request_tracking_authorization_complete.connect(_on_att_complete)

	# Query status:
	var current_status := ATT.get_tracking_authorization_status()
	print("Current status: ", current_status)

	# Request permission:
	ATT.request_tracking_authorization()


func _on_att_complete(status: ATT.Status) -> void:
	match status:
		ATT.Status.AUTHORIZED:
			print("User allowed tracking")
		ATT.Status.DENIED:
			print("User denied tracking")
		ATT.Status.NOT_DETERMINED:
			print("User has not yet been asked")
		ATT.Status.RESTRICTED:
			print("Tracking is restricted (e.g., parental controls)")
```

### Authorization Statuses

| Enum Member | Raw Value | Meaning |
| :--- | :--- | :--- |
| `ATT.Status.NOT_DETERMINED` | `0` | Authorization has not yet been requested. |
| `ATT.Status.RESTRICTED` | `1` | Tracking is restricted (e.g. parental controls). |
| `ATT.Status.DENIED` | `2` | User denied authorization. |
| `ATT.Status.AUTHORIZED` | `3` | User granted authorization. |

---

## Testing Notes

> [!NOTE]
> On iOS, the native ATT dialog appears **only once per app installation**.
> To test the authorization prompt again, uninstall the app from your iOS device or simulator and reinstall it.

---

## Building from Source

To compile the native static XCFramework (`GodotATTPlugin.xcframework`):

```bash
./scripts/build_local.sh
```

To run unit tests:

```bash
./platforms/ios/scripts/test_local.sh
```

---

## License

MIT License. Copyright (c) 2026-present Poing Studios.
