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
  static public var title: LocalizedStringResource = "Increment Counter"

  @Parameter(title: "Method")
  var method: String

  public init() {
    method = "increment"
  }

  public init(method: String) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
    await HomeWidgetBackgroundWorker.run(
      url: URL(string: "homeWidgetCounter://\(method)"),
      appGroup: appGroup)

    return .result()
  }
}

