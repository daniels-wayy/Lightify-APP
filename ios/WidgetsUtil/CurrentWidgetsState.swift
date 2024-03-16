//
//  CurrentWidgetsState.swift
//  Runner
//
//  Created by Daniel on 15.03.2024.
//

import Foundation

class CurrentWidgetsState {
    static let shared = CurrentWidgetsState()
    
    public func hasData() -> Bool {
        let prefs = UserDefaults(suiteName: appGroup)
        let jsonString = prefs?.string(forKey: getKey)
        return jsonString != nil && !jsonString!.isEmpty
    }
    
    public func currentState() -> DevicesLists? {
        let prefs = UserDefaults(suiteName: appGroup)
        let jsonString = prefs?.string(forKey: getKey)
        let devicesLists = DevicesParser.parse(jsonString: jsonString)
        return devicesLists
    }
    
    public func updateState(updatedDevicesLists: DevicesLists) {
        let encodedDevices = DevicesParser.encode(devicesLists: updatedDevicesLists)
        if let encodedDevices = encodedDevices {
            let prefs = UserDefaults(suiteName: appGroup)
            prefs?.set(encodedDevices, forKey: getKey)
        } else {
            print("Encoded devices is null")
        }
    }
}
