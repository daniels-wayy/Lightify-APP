//
//  MQTTDevicePowerChanger.swift
//  Runner
//
//  Created by Daniel on 27.02.2024.
//

import Foundation
import CocoaMQTT
import WidgetKit

@available(iOS 17.0, *)
public class MQTTDevicePowerChanger {
    private var sendRemote: String!
    private var mqtt: CocoaMQTT!
    
    private func generateClientID() -> String {
        let uuid = UUID()
        return "DSLY_\(uuid.uuidString)"
    }
    
    private func subscribe() {
        let subscribeTopic = MQTTConstants.getMqttSubscribeTopic()
        mqtt.subscribe(subscribeTopic, qos: .qos0)
    }
    
    public func process(for remote: String) {
        sendRemote = remote
        
        let clientID = generateClientID()
        mqtt = CocoaMQTT(clientID: clientID, host: MQTTConstants.getMqttHost(), port: MQTTConstants.getMqttPort())
        mqtt.keepAlive = MQTTConstants.getMqttKeepAlive()
        
        mqtt.didConnectAck = didConnectAck
        mqtt.didPublishMessage = didPublishMessage
        
        mqtt.didSubscribeTopics = { mqtt, success, error in
            if (mqtt.connState == CocoaMQTTConnState.connected) {
                self.onConnectionEstablished(for: self.sendRemote)
            }
        }
        
        mqtt.connect()
    }
    
    private func onConnectionEstablished(for remote: String) {
        processDeviceChangeFromWidget(for: remote)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mqtt.disconnect()
        }
    }
    
    private func processDeviceChangeFromWidget(for remote: String) {
        
        let currentWidgetsState = getCurrentWidgetsState()
        
        if let currentWidgetsState = currentWidgetsState {
            
            let smallWidget = currentWidgetsState.smallWidget ?? []
            let mediumWidget = currentWidgetsState.mediumWidget ?? []
            let bigWidget = currentWidgetsState.bigWidget ?? []
            
            var desiredDevice: DeviceData?
            
            desiredDevice = smallWidget.first(where: { device in
                device.deviceTopic == remote
            })
            
            if (desiredDevice == nil) {
                desiredDevice = mediumWidget.first(where: { device in
                    device.deviceTopic == remote
                })
            }
            
            if (desiredDevice == nil) {
                desiredDevice = bigWidget.first(where: { device in
                    device.deviceTopic == remote
                })
            }
            
            if let desiredDevice = desiredDevice {
                
                let currentPowerState = desiredDevice.currentPowerState
                let newPowerState = !currentPowerState
                sendPowerCMD(remote: remote, newState: newPowerState)
            }
            
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
        } else {
            print("encoded devices is null")
        }
    }
    
    private func sendPowerCMD(remote: String, newState: Bool) {
        let intState = newState ? 1 : 0
        let message = "\(MQTTConstants.getMqttDevicePowerCommand())\(intState.description)"
        sendToServer(remote: remote, data: message)
    }
    
    private func sendToServer(remote: String, data: String) {
        let formattedData = "\(MQTTConstants.getMqttPackageHeader())\(data)"
        mqtt.publish(remote, withString: formattedData, qos: .qos1)
    }
    
    private func didConnectAck(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            subscribe()
        }
    }
    
    private func didPublishMessage(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        if (mqtt.connState == CocoaMQTTConnState.connected) {
            mqtt.disconnect()
        }
    }
}
