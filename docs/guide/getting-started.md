# Quickstart & Installation

Follow these steps to integrate ATT authorization into your Godot iOS project.

## 1. Installation

1. Download the latest release from the [Releases](https://github.com/Poing-Studios/godot-att-ios/releases) page or clone the repository.
2. Copy the `addons/att/` folder into your Godot project's `res://addons/` directory:

```
res://
└── addons/
    └── att/
        ├── att.gd               # Public static API (class_name ATT)
        ├── att.gdextension      # GDExtension configuration
        ├── plugin.cfg
        ├── plugin.gd
        ├── internal/
        └── ios/bin/
            └── GodotATTPlugin.xcframework
```

## 2. Enable the Plugin

1. Open your project in Godot.
2. Navigate to **Project -> Project Settings -> Plugins**.
3. Locate **ATT** and check **Enable**.

## 3. Configure Permission Description

Apple requires an explanation displayed inside the tracking permission dialog.

In your Godot project:
1. Open **Project -> Project Settings**.
2. Enable **Advanced Settings** (top right toggle).
3. Search for or add:
   - Key: `plugins/att/ios/user_tracking_usage_description`
   - Type: `String`
   - Value: `"Your data will be used to deliver personalized ads and a tailored gaming experience."`

> [!TIP]
> If not configured manually, the plugin provides a default generic tracking message during export, but App Store reviewers recommend providing a custom, clear description explaining your app's actual use.
