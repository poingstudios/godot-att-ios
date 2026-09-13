// MIT License
//
// Copyright (c) 2026-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import AppTrackingTransparency
import Foundation
import GodotSwiftPlugin

public final class PoingGodotATT: GodotPlugin {
    public static let pluginName = "ATT"

    public static let signalRequestComplete = "request_tracking_authorization_complete"

    public init() {}

    public func registerMethods(in registry: GodotPluginRegistry) {
        registry.registerMethod(pluginName: Self.pluginName, methodName: "requestTrackingAuthorization") { [weak self] _ in
            self?.requestTrackingAuthorization()
            return nil
        }

        registry.registerMethod(pluginName: Self.pluginName, methodName: "getTrackingAuthorizationStatus") { [weak self] _ in
            return self?.getTrackingAuthorizationStatus() ?? 0
        }

        registry.registerSignal(pluginName: Self.pluginName, signalName: Self.signalRequestComplete)
    }

    public func requestTrackingAuthorization() {
        DispatchQueue.main.async {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    self?.emitSignal(Self.signalRequestComplete, args: [Int(status.rawValue)])
                }
            }
        }
    }

    public func getTrackingAuthorizationStatus() -> Int {
        return Int(ATTrackingManager.trackingAuthorizationStatus.rawValue)
    }
}

public typealias PGATT = PoingGodotATT

@_cdecl("godot_att_initialize")
public func godot_att_initialize() {
    let plugin = PoingGodotATT()
    GodotPluginRegistry.shared.registerPlugin(plugin)
}

@_cdecl("godot_att_deinitialize")
public func godot_att_deinitialize() {
}
