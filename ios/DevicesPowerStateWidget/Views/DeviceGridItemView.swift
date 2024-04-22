//
//  DeviceGridItemView.swift
//  DevicesPowerStateWidgetExtension
//
//  Created by Daniel on 17.02.2024.
//

import Foundation
import SwiftUI
import AppIntents

struct DeviceGridItemView: View {
    let deviceData: DeviceData
    let showBrightnessPercent: Bool
    let intent: any AppIntent
    
    @Environment(\.widgetFamily) private var widgetFamily
    @Environment(\.colorScheme) private var colorScheme
    
    private let lineWidth = 5.0
    
    var IconWidget: some View {
        
        if let iconPath = deviceData.iconPath {
            if let uiImage = UIImage(contentsOfFile: iconPath) {
                
                let color: Color = (colorScheme == .dark) ? .white : .black
                
                let image = Image(uiImage: uiImage)
                    .renderingMode(.template)
                    .foregroundColor(color)
                
                return AnyView(image)
            }
        }
        
        print("The image file not loaded")
        return AnyView(EmptyView())
    }
    
    var CircleProgress: some View {
        ZStack {
            IconWidget
                .frame(width: 22, height: 22)
                .opacity(deviceData.currentPowerState ? 1.0 : 0.8)
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.15)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: self.deviceData.currentBrightness)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(foregroundColor)
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
    
    var body: some View {
        VStack {
            Button(intent: intent) {
                CircleProgress
            }
            .buttonStyle(.plain)
            
            if (showBrightnessPercent) {
                let brightnessPercent = calculateBrightnessPercent(brightnessFactor: self.deviceData.currentBrightness)
                
                Spacer(minLength: 14)
                Text("\(brightnessPercent.description)%").font(.callout).fontWeight(.medium).opacity(deviceData.currentPowerState ? 0.9 : 0.6)
            }
        }
    }
    
    private var foregroundColor: Color {
        return deviceData.currentPowerState ? Color(hex: deviceData.colorHex) : Color.gray.opacity(0.6)
    }
    
    private func calculateBrightnessPercent(brightnessFactor: Double) -> Int {
        return Int(brightnessFactor * 100)
    }
}
