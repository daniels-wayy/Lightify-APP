//
//  DevicesData.swift
//  Runner
//
//  Created by Daniel on 17.02.2024.
//

import Foundation

struct DeviceData: Codable, Identifiable {
    let id = UUID()
    let currentPowerState: Bool
    let currentBrightness: Double
    let deviceTopic: String
    let colorHex: Int
    let iconPath: String?
}

struct DevicesLists: Codable {
    let smallWidget: [DeviceData]?
    let mediumWidget: [DeviceData]?
    let bigWidget: [DeviceData]?
    
    func isExist() -> Bool {
        return smallWidget != nil && mediumWidget != nil && bigWidget != nil
    }
}
