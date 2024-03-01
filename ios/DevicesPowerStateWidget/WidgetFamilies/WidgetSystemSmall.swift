//
//  WidgetSystemSmall.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 17.02.2024.
//

import Foundation
import SwiftUI

struct WidgetSystemSmall: View {
    let devices: [DeviceData]?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        DevicesGridView(devices: devices, columns: columns, showBrightnessPercent: false, itemPadding: 1.0, isGeometryReader: true)
            .padding(-4.0)
    }
}
