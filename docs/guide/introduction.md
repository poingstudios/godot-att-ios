# Introduction

**Godot ATT iOS** is an official-grade Apple App Tracking Transparency (ATT) plugin for Godot Engine 4.6+ on iOS, developed by [Poing Studios](https://github.com/Poing-Studios).

## What is App Tracking Transparency (ATT)?

Starting in iOS 14.5, Apple requires applications to obtain explicit user permission before tracking them across apps and websites owned by other companies, primarily for advertising purposes (such as IDFA access for Google AdMob, Unity Ads, AppLovin, or Meta Audience Network).

## Why Use This Plugin?

- **Direct Native Framework Call**: Interfaces directly with Apple's `ATTrackingManager` via Swift.
- **Powered by Godot Swift Plugin**: Built using Poing Studios' pure Swift GDExtension framework, eliminating heavy C++ engine bindings.
- **Editor Export Automation**: Integrates an `EditorExportPlugin` that automatically injects required plist keys and Xcode frameworks when exporting for iOS.
- **Static XCFramework**: Packaged as a universal static XCFramework supporting both physical devices (`arm64`) and simulators (`arm64` and `x86_64`).

## Requirements

- **Godot Engine**: 4.6+
- **iOS Deployment Target**: iOS 14.0+
- **Xcode**: 15.0+ (Swift 5.9+)
- **Supported Architectures**: `arm64` (device) & `arm64`/`x86_64` (simulator)
