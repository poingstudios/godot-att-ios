---
layout: home

hero:
  name: "Godot ATT iOS"
  text: "App Tracking Transparency for Godot"
  tagline: "Official-grade Apple ATT plugin for Godot 4.6+ on iOS. Powered by Godot Swift Plugin with zero C++ overhead."
  image:
    src: /icon.svg
    alt: Godot ATT iOS
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: API Reference
      link: /guide/usage
    - theme: alt
      text: View on GitHub
      link: https://github.com/Poing-Studios/godot-att-ios

features:
  - icon: 🛡️
    title: Apple ATT Native
    details: Query authorization status and request tracking permission directly via iOS native AppTrackingTransparency.framework.
  - icon: ⚡
    title: Pure Swift & GDExtension
    details: Zero C++ bridge overhead. Powered by Godot Swift Plugin for fast compiles and clean architecture.
  - icon: 🛠️
    title: Automated iOS Export
    details: Automatically configures AppTrackingTransparency.framework, NSUserTrackingUsageDescription, and -ObjC linker flags upon Godot iOS export.
  - icon: 💻
    title: Desktop Safe Mocks
    details: Ships with built-in desktop mocks so running and testing scenes in the Godot Editor on macOS, Linux, and Windows works seamlessly.
---
