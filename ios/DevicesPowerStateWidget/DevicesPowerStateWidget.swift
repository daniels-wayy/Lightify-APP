//
//  DevicesPowerStateWidget.swift
//  DevicesPowerStateWidget
//
//  Created by Daniel on 15.02.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), devices: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = generateEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        
        if (!CurrentWidgetsState.shared.hasData()) {
            let entry = SimpleEntry(date: currentDate, devices: nil)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } else {
            CurrentDevicesFetcher.shared.process { devices in
                if (devices != nil && devices!.isExist()) {
                    CurrentWidgetsState.shared.updateState(updatedDevicesLists: devices!)
                }
                
                let entry = (devices == nil || !devices!.isExist()) ? generateEntry() : SimpleEntry(date: currentDate, devices: devices)
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: widgetsUpdatePeriod, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
                return
            }
        }
    }
    
    private func generateEntry() -> SimpleEntry {
        let currentDate = Date()
        let devicesLists = CurrentWidgetsState.shared.currentState()
        return SimpleEntry(date: currentDate, devices: devicesLists)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let devices: DevicesLists?
}

struct DevicesPowerStateWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var body: some View {
        VStack {
            if (entry.devices == nil) {
                Text("Lights are missing.\nHop in the app.")
            } else {
                switch widgetFamily {
                case .systemSmall:
                    WidgetSystemSmall(devices: entry.devices!.smallWidget)
                case .systemMedium:
                    WidgetSystemMedium(devices: entry.devices!.mediumWidget)
                case .systemLarge:
                    WidgetSystemLarge(devices: entry.devices!.bigWidget)
                default:
                    WidgetSystemSmall(devices: entry.devices!.smallWidget)
                }
            }
        }
    }
}

@available(iOS 17.0, *)
struct DevicesPowerStateWidget: Widget {
    let kind: String = "DevicesPowerStateWidget"
    
    var body: some WidgetConfiguration {
      StaticConfiguration(kind: kind, provider: Provider()) { entry in
        if #available(iOS 17.0, *) {
            DevicesPowerStateWidgetEntryView(entry: entry)
            .containerBackground(.fill.tertiary, for: .widget)
        } else {
            DevicesPowerStateWidgetEntryView(entry: entry)
//            .padding()
            .background()
        }
      }
      .configurationDisplayName("Power")
      .description("Manage the power status of your luminaires.")
      .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    DevicesPowerStateWidget()
} timeline: {
//    let deviceEntity = DeviceData(currentPowerState: true, currentBrightness: 0.5, deviceTopic: "test", colorHex: 0, iconPath: "")
//    let deviceEntity2 = DeviceData(currentPowerState: true, currentBrightness: 0.5, deviceTopic: "test", colorHex: 0, iconPath: "")
//    let deviceEntity3 = DeviceData(currentPowerState: true, currentBrightness: 0.5, deviceTopic: "test", colorHex: 0, iconPath: "")
//    let deviceEntity4 = DeviceData(currentPowerState: true, currentBrightness: 0.5, deviceTopic: "test", colorHex: 0, iconPath: "")
//    let deviceEntity5 = DeviceData(currentPowerState: true, currentBrightness: 0.5, deviceTopic: "test", colorHex: 0, iconPath: "")
//    let devices = DevicesLists(smallWidget: [deviceEntity, deviceEntity2, deviceEntity3], mediumWidget: [deviceEntity, deviceEntity2, deviceEntity3, deviceEntity], bigWidget: [deviceEntity, deviceEntity2, deviceEntity3, deviceEntity4, deviceEntity5, deviceEntity, deviceEntity])
    SimpleEntry(date: .now, devices: nil)
}
