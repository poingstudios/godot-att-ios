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

import XCTest
import GodotSwiftPlugin
@testable import GodotATTPlugin

final class GodotATTPluginTests: XCTestCase {
    override func setUp() {
        super.setUp()
        GodotPluginRegistry.shared.reset()
    }

    func testPluginRegistration() {
        let plugin = PoingGodotATT()
        GodotPluginRegistry.shared.registerPlugin(plugin)

        XCTAssertEqual(GodotPluginRegistry.shared.getPluginNames(), ["ATT"])

        let methods = GodotPluginRegistry.shared.getMethods(for: "ATT")
        XCTAssertTrue(methods.contains("request_tracking_authorization"))
        XCTAssertTrue(methods.contains("requestTrackingAuthorization"))
        XCTAssertTrue(methods.contains("get_tracking_authorization_status"))
        XCTAssertTrue(methods.contains("getTrackingAuthorizationStatus"))

        let signals = GodotPluginRegistry.shared.getSignals(for: "ATT")
        XCTAssertTrue(signals.contains("request_tracking_authorization_complete"))
    }

    func testGetTrackingAuthorizationStatusWithSnakeCase() {
        let plugin = PoingGodotATT()
        GodotPluginRegistry.shared.registerPlugin(plugin)

        let status = GodotPluginRegistry.shared.callMethod(
            pluginName: "ATT",
            methodName: "get_tracking_authorization_status"
        ) as? Int

        XCTAssertNotNil(status)
        XCTAssertTrue((0...3).contains(status!))
    }

    func testRequestTrackingAuthorizationEmitsSignal() {
        let plugin = PoingGodotATT()
        GodotPluginRegistry.shared.registerPlugin(plugin)

        let expectation = expectation(description: "request_tracking_authorization_complete emitted")

        GodotPluginRegistry.shared.onSignalEmitted = { pluginName, signalName, args in
            if pluginName == "ATT" && signalName == "request_tracking_authorization_complete" {
                if let status = args.first as? Int {
                    XCTAssertTrue((0...3).contains(status))
                    expectation.fulfill()
                }
            }
        }

        _ = GodotPluginRegistry.shared.callMethod(
            pluginName: "ATT",
            methodName: "request_tracking_authorization"
        )

        wait(for: [expectation], timeout: 3.0)
    }
}
