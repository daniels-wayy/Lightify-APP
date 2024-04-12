//
//  DevicesParser.swift
//  Runner
//
//  Created by Daniel on 17.02.2024.
//

import Foundation

class DevicesParser {
    public static func encode(devicesLists: DevicesLists?) -> String? {
        if (devicesLists != nil && devicesLists!.isExist()) {
            let encoder = JSONEncoder()

            do {
                // Encode the object into JSON data
                let jsonData = try encoder.encode(devicesLists!)
                
                // Convert the JSON data to a string
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                }
            } catch {
                print("Error encoding object: \(error)")
            }
        }
        
        return nil
    }
    
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
            return devicesLists
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return nil
    }
    
    public static func parseDevice(data: String) -> DeviceData? {
        let truncated = String(data.dropFirst((MQTTConstants.getMqttPackageHeader() + MQTTConstants.getGetResponseHeader()).count))
        let splitted = truncated.split(separator: ",")
        
        if (splitted.isEmpty) {
            return nil
        }
        
        let powerState = (Int(splitted[1]) ?? 0) == 1
        let brightness = (Int(splitted[2]) ?? 0)
        let doubleBrightness = (Double(brightness) / 255)
        
        let colorHue = (Int(splitted[3]) ?? 0);
        let colorSat = (Int(splitted[4]) ?? 255);
        let colorVal = (Int(splitted[5]) ?? 255);
        
        let colorHueFloat: Float = Float(mapHueTo360(hueVal: colorHue))
        let colorSatFloat: Float = Float(colorSat) / 255
        let colorValFloat: Float = Float(colorVal) / 255
        
        let hsvColor = HSV.init(h: colorHueFloat, s: colorSatFloat, v: colorValFloat)
        let rgbColor = HSV.rgb(hsv: hsvColor)
        let hexColor = rgbColor.toHex()
        
        let deviceTopic = String(splitted[0])
        
//        print("deviceTopic: \(deviceTopic) - \(powerState.description) / \(doubleBrightness.description) / \(hexColor.description)")
        
        return DeviceData(currentPowerState: powerState, currentBrightness: doubleBrightness, deviceTopic: deviceTopic, colorHex: hexColor, iconPath: nil)
    }
}
