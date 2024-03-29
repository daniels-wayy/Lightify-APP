//
//  DevicesPowerStateWidgetLiveActivity.swift
//  DevicesPowerStateWidget
//
//  Created by Daniel on 15.02.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DevicesPowerStateWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DevicesPowerStateWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DevicesPowerStateWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DevicesPowerStateWidgetAttributes {
    fileprivate static var preview: DevicesPowerStateWidgetAttributes {
        DevicesPowerStateWidgetAttributes(name: "World")
    }
}

extension DevicesPowerStateWidgetAttributes.ContentState {
    fileprivate static var smiley: DevicesPowerStateWidgetAttributes.ContentState {
        DevicesPowerStateWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DevicesPowerStateWidgetAttributes.ContentState {
         DevicesPowerStateWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DevicesPowerStateWidgetAttributes.preview) {
   DevicesPowerStateWidgetLiveActivity()
} contentStates: {
    DevicesPowerStateWidgetAttributes.ContentState.smiley
    DevicesPowerStateWidgetAttributes.ContentState.starEyes
}
