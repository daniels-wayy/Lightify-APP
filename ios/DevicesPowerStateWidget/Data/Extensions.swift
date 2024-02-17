//
//  Extensions.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 17.02.2024.
//

import Foundation
import SwiftUI

// converts hex to color
@available(iOS 13, *)
extension Color {
    init(hex: Int) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}
