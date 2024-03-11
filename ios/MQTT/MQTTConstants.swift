//
//  MQTTConstants.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 27.02.2024.
//

import Foundation

public struct MQTTConstants {
    private static let mqttHost: String = "broker.mqttdashboard.com"
    private static let mqttSubscibeTopic: String = "DSLY_App"
    private static let mqttPort: UInt16 = 1883
    private static let mqttKeepAlive: UInt16 = 25
    private static let mqttPackageHeader: String = "DSLY:"
    private static let mqttDevicePowerCommand: String = "PWR"
    
    public static func getMqttHost() -> String {
        return mqttHost
    }
    
    public static func getMqttSubscribeTopic() -> String {
        return mqttSubscibeTopic
    }
    
    public static func getMqttPort() -> UInt16 {
        return mqttPort
    }
    
    public static func getMqttKeepAlive() -> UInt16 {
        return mqttKeepAlive
    }
    
    public static func getMqttPackageHeader() -> String {
        return mqttPackageHeader
    }
    
    public static func getMqttDevicePowerCommand() -> String {
        return mqttDevicePowerCommand
    }
}
