//
//  DevicesPowerStateWidgetBundle.swift
//  DevicesPowerStateWidget
//
//  Created by Daniel on 15.02.2024.
//

import WidgetKit
import SwiftUI

@main
struct DevicesPowerStateWidgetBundle: WidgetBundle {
    var body: some Widget {
        DevicesPowerStateWidget()
        DevicesPowerStateWidgetLiveActivity()
    }
}
