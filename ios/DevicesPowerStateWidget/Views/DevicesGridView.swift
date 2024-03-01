//
//  DevicesGridView.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 17.02.2024.
//

import Foundation
import SwiftUI

struct DevicesGridView: View {
    let devices: [DeviceData]?
    let columns: [GridItem]
    let showBrightnessPercent: Bool
    let itemPadding: Double
    let isGeometryReader: Bool
    
    var GridOfItems: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(devices!, id: \.id) { device in
                let intent = BackgroundIntent(method: device.deviceTopic)
                return DeviceGridItemView(
                    deviceData: device,
                    showBrightnessPercent: showBrightnessPercent,
                    intent: intent)
                .padding(.horizontal, 3.0)
                .padding(itemPadding)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (devices == nil) {
                Text("No devices found")
            } else {
                if (isGeometryReader) {
                    GeometryReader { geometry in
                        GridOfItems
                    }
                } else {
                    GridOfItems
                }
            }
        }
    }
}
