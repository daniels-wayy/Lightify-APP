//
//  MQTTDevicesBackgroundUpdate.swift
//  Runner
//
//  Created by Daniel on 03.03.2024.
//

import Foundation
import BackgroundTasks
import WidgetKit
import CocoaMQTT

@available(iOS 17.0, *)
public class MQTTDevicesBackgroundUpdate: Operation {
    private var mqtt: CocoaMQTT!
    
    static private let remotes = [
        "DSLY_Kitchen_Workspace",
        "DSLY_Livingroom_TV",
        "DSLY_Bedroom_Bed",
        "DSLY_Bedroom_Monitor",
        "DSLY_Office_Desk",
        "DSLY_Bedroom_Bed_Upperside",
        "DSLY_Livingroom_Piano",
        "DSLY_Bedroom_Closet",
    ]
    
    private var expectedRemotesBuffer = MQTTDevicesBackgroundUpdate.remotes
    private var receivedDevicesBuffer: [DeviceData] = []
    
    func finish() {
        if !isCancelled {
            self.willChangeValue(forKey: "isFinished")
            self.willChangeValue(forKey: "isExecuting")
            self._isExecuting = false
            self._isFinished = true
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    private var _isExecuting: Bool = false
    override public var isExecuting: Bool {
        return _isExecuting
    }
    
    private var _isFinished: Bool = false
    override public var isFinished: Bool {
        return _isFinished
    }
    
    override public func main() {
        processBackgroudUpdate()
    }
    
    private func generateClientID() -> String {
        let uuid = UUID()
        return "DSLY_\(uuid.uuidString)"
    }
    
    private func subscribe() {
        let subscribeTopic = MQTTConstants.getMqttSubscribeTopic()
        mqtt.subscribe(subscribeTopic, qos: .qos0)
    }
    
    public func processBackgroudUpdate() {
        connectToMQTT()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            print("receivedDevicesBuffer: \(self.receivedDevicesBuffer.count.description)/\(MQTTDevicesBackgroundUpdate.remotes.count.description)")
            
            if (!self.receivedDevicesBuffer.isEmpty) {
                self.updateDevices()
            }
            
            self.mqtt.disconnect()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.finish()
            }
        }
    }
    
    private func connectToMQTT() {
        let clientID = generateClientID()
        mqtt = CocoaMQTT(clientID: clientID, host: MQTTConstants.getMqttHost(), port: MQTTConstants.getMqttPort())
        mqtt.keepAlive = MQTTConstants.getMqttKeepAlive()
        mqtt.didConnectAck = didConnectAck
        mqtt.didSubscribeTopics = didSubscribeTopics
        mqtt.didReceiveMessage = didReceiveMessage
        mqtt.didDisconnect = didDisconnectWithError
        mqtt.connect()
    }
    
    private func didConnectAck(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("MQTT Connected!")
            subscribe()
        } else {
            print("Failed to connect to MQTT server")
        }
    }
    
    private func didDisconnectWithError(_ mqtt: CocoaMQTT, didDisconnectWithError error: Error?) {
        if let error = error {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected successfully")
        }
    }
    
    private func didSubscribeTopics(_ mqtt: CocoaMQTT, success: NSDictionary, error: [String]) {
        if (mqtt.connState == CocoaMQTTConnState.connected) {
            Task.init {
                try await self.getDevices()
            }
        }
    }
    
    private func didReceiveMessage(mqtt: CocoaMQTT, message: CocoaMQTTMessage, f: UInt16) {
        let msg = message.string
        if let msg = msg {
            let parsedDevice = DevicesParser.parseDevice(data: msg)
            if let parsedDevice = parsedDevice {
                processDevice(device: parsedDevice)
            }
        }
    }
    
    private func processDevice(device data: DeviceData) {
        if (expectedRemotesBuffer.contains { $0 == data.deviceTopic}) {
            expectedRemotesBuffer.removeAll { $0 == data.deviceTopic}
            receivedDevicesBuffer.append(data)
//            print("Device \(data.deviceTopic) has been added!")
        }
    }
    
    private func getDevices() async throws {
        for remote in MQTTDevicesBackgroundUpdate.remotes {
            sendGet(to: remote)
            try await Task.sleep(nanoseconds: 50 * 1_000_000)
        }
    }
    
    private func sendGet(to remote: String) {
        let formattedData = "\(MQTTConstants.getMqttPackageHeader())GET"
        mqtt.publish(remote, withString: formattedData, qos: .qos1)
    }
    
    private func updateDevices() {
        let currentWidgetsState = getCurrentWidgetsState()
        
        if let currentWidgetsState = currentWidgetsState {
            
            let smallWidget = currentWidgetsState.smallWidget ?? []
            let mediumWidget = currentWidgetsState.mediumWidget ?? []
            let bigWidget = currentWidgetsState.bigWidget ?? []
            
            var updatedSmallWidget = smallWidget
            var updatedMediumWidget = mediumWidget
            var updatedBigWidget = bigWidget
            
//            print("SmallWidget Before: \(smallWidget.map { $0.currentPowerState })")
//            print("MediumWidget Before: \(mediumWidget.map { $0.currentPowerState })")
            
            for device in receivedDevicesBuffer {
                updatedSmallWidget = updatedSmallWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0 }
                updatedMediumWidget = updatedMediumWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0 }
                updatedBigWidget = updatedBigWidget.map { $0.deviceTopic == device.deviceTopic ? device.copyWith(iconPath: $0.iconPath) : $0  }
            }
            
//            print("SmallWidget After: \(updatedSmallWidget.map { $0.currentPowerState })")
//            print("MediumWidget After: \(updatedMediumWidget.map { $0.currentPowerState })")
            
            let updatedDevicesLists = DevicesLists(smallWidget: updatedSmallWidget, mediumWidget: updatedMediumWidget, bigWidget: updatedBigWidget)
            
            saveUpdatedWidgetsState(updatedDevicesLists: updatedDevicesLists)
        }
    }
    
    private func getCurrentWidgetsState() -> DevicesLists? {
        let prefs = UserDefaults(suiteName: appGroup)
        let jsonString = prefs?.string(forKey: getKey)
        let devicesLists = DevicesParser.parse(jsonString: jsonString)
        return devicesLists
    }
    
    private func saveUpdatedWidgetsState(updatedDevicesLists: DevicesLists) {
        let encodedDevices = DevicesParser.encode(devicesLists: updatedDevicesLists)
        if let encodedDevices = encodedDevices {
            let prefs = UserDefaults(suiteName: appGroup)
            prefs?.set(encodedDevices, forKey: getKey)
            WidgetCenter.shared.reloadTimelines(ofKind: devicesPowerStateWidgetName)
        } else {
            print("Encoded devices is null")
        }
    }
}
