//
//  WidgetSystemMedium.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 17.02.2024.
//

import Foundation
import SwiftUI

struct WidgetSystemMedium: View {
    let devices: [DeviceData]?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        DevicesGridView(devices: devices, columns: columns, showBrightnessPercent: true, itemPadding: 3.0, isGeometryReader: false)
    }
}
