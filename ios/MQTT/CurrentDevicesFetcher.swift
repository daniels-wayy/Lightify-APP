//
//  CurrentDevicesFetcher.swift
//  Runner
//
//  Created by Daniel on 14.03.2024.
//

import Foundation
import CocoaMQTT

class CurrentDevicesFetcher {
    static let shared = CurrentDevicesFetcher()
    
    private init() {}
    
    static private let remotes = [
        "DSLY_Kitchen_Workspace",
        "DSLY_Livingroom_TV",
        "DSLY_Bedroom_Bed_Lowerside",
        "DSLY_Office_Monitor",
        "DSLY_Office_Desk",
        "DSLY_Office_Mac_Monitor",
        "DSLY_Bedroom_Bed_Upperside",
        "DSLY_Livingroom_Piano",
        "DSLY_Bedroom_Closet",
//        "DSLY_Debug_Lightify",
    ]
    
    private func generateClientID() -> String {
        let uuid = UUID()
        return "DSLY_\(uuid.uuidString)"
    }
    
    private func subscribe() {
        let subscribeTopic = MQTTConstants.getMqttSubscribeTopic()
        mqtt.subscribe(subscribeTopic, qos: .qos0)
    }
    
    private func sendGetDevices() async throws {
        for remote in CurrentDevicesFetcher.remotes {
            sendGet(to: remote)
            try await Task.sleep(nanoseconds: 10 * 1_000_000)
        }
    }
    
    private func sendGet(to remote: String) {
        let formattedData = "\(MQTTConstants.getMqttPackageHeader())GET"
        mqtt.publish(remote, withString: formattedData, qos: .qos1)
    }
    
    private var mqtt: CocoaMQTT!
    private var expectedRemotesBuffer = CurrentDevicesFetcher.remotes
    private var receivedDevicesBuffer: [DeviceData] = []
    
    private func clearBuffers() {
        expectedRemotesBuffer = CurrentDevicesFetcher.remotes
        receivedDevicesBuffer = []
    }
    
    public func process(completion: @escaping (DevicesLists?) -> Void) {
        clearBuffers()
        
        if (mqtt != nil && mqtt!.connState == CocoaMQTTConnState.connected) {
            Task.init {
                try await self.sendGetDevices()
            }
        } else {
            connectToServer()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let devices = self.processResultDevices()
            completion(devices)
        }
    }
    
    private func connectToServer() {
        let clientID = generateClientID()
        mqtt = CocoaMQTT(clientID: clientID, host: MQTTConstants.getMqttHost(), port: MQTTConstants.getMqttPort())
        mqtt.keepAlive = MQTTConstants.getMqttKeepAlive()
        mqtt.didConnectAck = didConnectAck
        mqtt.didSubscribeTopics = didSubscribeTopics
        mqtt.didReceiveMessage = didReceiveMessage
        mqtt.connect()
    }
    
    private func didConnectAck(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            subscribe()
        }
    }
    
    private func didSubscribeTopics(_ mqtt: CocoaMQTT, success: NSDictionary, error: [String]) {
        if (mqtt.connState == CocoaMQTTConnState.connected) {
            Task.init {
                try await self.sendGetDevices()
            }
        }
    }
    
    private func didReceiveMessage(mqtt: CocoaMQTT, message: CocoaMQTTMessage, f: UInt16) {
        let msg = message.string
        if let msg = msg {
            let parsedDevice = DevicesParser.parseDevice(data: msg)
            if let parsedDevice = parsedDevice {
                appendDevice(device: parsedDevice)
            }
        }
    }
    
    private func appendDevice(device data: DeviceData) {
        if (expectedRemotesBuffer.contains { $0 == data.deviceTopic}) {
            expectedRemotesBuffer.removeAll { $0 == data.deviceTopic}
            receivedDevicesBuffer.append(data)
        }
    }
    
    private func processResultDevices() -> DevicesLists? {
        let currentWidgetsState = CurrentWidgetsState.shared.currentState()
        
        if let currentWidgetsState = currentWidgetsState {
            let smallWidget = currentWidgetsState.smallWidget ?? []
            let mediumWidget = currentWidgetsState.mediumWidget ?? []
            let bigWidget = currentWidgetsState.bigWidget ?? []
            
            var updatedSmallWidget = smallWidget
            var updatedMediumWidget = mediumWidget
            var updatedBigWidget = bigWidget
            
            for device in receivedDevicesBuffer {
                updatedSmallWidget = updatedSmallWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0 }
                updatedMediumWidget = updatedMediumWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0 }
                updatedBigWidget = updatedBigWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0  }
            }
            
            let updatedDevicesLists = DevicesLists(smallWidget: updatedSmallWidget, mediumWidget: updatedMediumWidget, bigWidget: updatedBigWidget)
            return updatedDevicesLists
        }
        
        return nil
    }
}
