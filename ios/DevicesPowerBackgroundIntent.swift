//
//  DevicesPowerBackgroundIntent.swift
//  Runner
//
//  Created by Daniel on 17.02.2024.
//

import AppIntents
import Foundation
import home_widget

@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}

@available(iOS 17, *)
public struct BackgroundIntent: AppIntent {
    static public var title: LocalizedStringResource = "Change power state of the devices"
    
    @Parameter(title: "Method")
    var method: String
    
    public init() {
        method = "increment"
    }
    
    public init(method: String) {
        self.method = method
    }
    
    public func perform() async throws -> some IntentResult {
        try await Task.sleep(nanoseconds: 100 * 1_000_000)
        MQTTDevicePowerChanger().process(for: method)
        try await Task.sleep(nanoseconds: 800 * 1_000_000)
        return .result()
    }
}

