//
//  DevicesParser.swift
//  Runner
//
//  Created by Daniel on 17.02.2024.
//

import Foundation

class DevicesParser {
    public static func parse(jsonString: String?) -> DevicesLists? {
        if (jsonString == nil || jsonString!.isEmpty) {
            return nil
        }
        
        guard let jsonData = jsonString!.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data")
        }
        
        let decoder = JSONDecoder()
        
        do {
            // Decode JSON data into DevicesList
            let devicesLists = try decoder.decode(DevicesLists.self, from: jsonData)
            
            print("WidgetParser parseWidgets()")
            print("smallWidgetCount: \(String(describing: devicesLists.smallWidget?.count))")
            print("mediumWidgetCount: \(String(describing: devicesLists.mediumWidget?.count))")
            print("bigWidgetCount: \(String(describing: devicesLists.bigWidget?.count))")
            
            return devicesLists
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return nil
    }
    
}
