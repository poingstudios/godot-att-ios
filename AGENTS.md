# Godot ATT iOS — AGENTS.md

AI assistant context for the godot-att-ios repository. Read this before making changes.

---

## Project Overview

**Godot ATT iOS** is an official-grade Apple App Tracking Transparency (ATT) plugin for Godot 4.x on iOS, powered by the **Godot Swift Plugin** framework. It enables games and applications to request tracking authorization and query the authorization status via iOS native `AppTrackingTransparency.framework`.

- **Supported Platform:** iOS 14.0+
- **Primary Language:** Swift 5.9+ (Native Plugin) & GDScript (Godot Editor / Addon)
- **Framework Dependency:** `GodotSwiftPlugin`
- **Engine Support:** Godot 4.x

---

## Architecture & Directory Layout

```
godot-att-ios/
├── platforms/
│   ├── ios/                 # Swift package implementing GodotATTPlugin
│   │   ├── Package.swift    # SPM manifest depending on GodotSwiftPlugin
│   │   ├── Sources/
│   │   │   └── GodotATTPlugin/
│   │   │       └── GodotATTPlugin.swift # Native ATT implementation
│   │   ├── Tests/
│   │   │   └── GodotATTPluginTests/
│   │   │       └── GodotATTPluginTests.swift # Framework unit tests
│   │   └── scripts/
│   │       └── test_local.sh # Local test execution script
│   └── godot_editor/        # Godot 4.x testbed project & addon
│       ├── project.godot
│       ├── sample/
│       │   ├── example.gd   # Interactive sample script
│       │   └── example.tscn # Interactive sample scene
│       └── addons/
│           └── att/
│               ├── plugin.cfg # Addon metadata
│               ├── plugin.gd  # EditorPlugin entry point
│               ├── att.gd     # Public singleton API (Status enum, requests)
│               └── internal/  # Internal scripts (no class_name, preload only)
│                   └── export_plugin.gd # iOS export plugin (framework & plist)
└── AGENTS.md
```

---

## Key Files & Responsibilities

| File / Folder | Responsibility |
| :--- | :--- |
| `platforms/ios/Sources/GodotATTPlugin/GodotATTPlugin.swift` | Implements `GodotPlugin` protocol, calls `ATTrackingManager`, emits `request_tracking_authorization_complete` |
| `platforms/godot_editor/addons/att/att.gd` | Static public API (`class_name ATT`) wrapping `Engine.get_singleton("ATT")` with `Status` enum |
| `platforms/godot_editor/addons/att/internal/export_plugin.gd` | Configures `AppTrackingTransparency.framework`, `NSUserTrackingUsageDescription`, and embedded C++ init hooks |
| `platforms/godot_editor/sample/example.gd` | Sample demonstration UI for testing ATT authorization states |

---

## Build & Test Commands

### Build Static XCFramework
```bash
./scripts/build_local.sh
```

### Run Swift Unit Tests
```bash
./platforms/ios/scripts/test_local.sh
```

### Run GDScript Linter
```bash
gdlint platforms/godot_editor/addons/
```

---

## Coding Rules & Guidelines

1. **License Header:** Every source code file (`.swift`, `.gd`, `.sh`) must start with the Poing Studios MIT license header.
2. **GDScript Type Inference:** Always use `:=` instead of `=` for variable assignments.
3. **Internal Encapsulation:** The `internal/` directory inside `addons/att/` **must not** contain any script with `class_name`. All internal scripts must be loaded explicitly using `preload(...)`.
4. **Git Workflow:** Never commit directly unless explicitly instructed.
5. **Language:** All responses and code must be in English.
