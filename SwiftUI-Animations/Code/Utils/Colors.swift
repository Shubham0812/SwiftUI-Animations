//
//  Colors.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 08/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

extension Color {
    
    static let chatBackground: Color = Color(r: 41, g: 121, b: 255.0)
    static let buttonBackground: Color = Color(r: 144.0, g: 202.0, b: 249.0)
    
    static let wifiBackground: Color = Color(r: 5, g: 23, b: 46)
    static let wifiShadow: Color = Color(r: 13, g: 50, b: 125)
    
    static let wifiConnected: Color = Color(r: 170, g: 255, b: 197)
    
    static let expandingBackground: Color = Color(r: 3, g: 247, b: 235)
    static let expandingAccent: Color = Color(r: 186, g: 38, b: 75)
    
    static let circleTrackStart: Color = Color(r: 237, g: 242, b: 255)
    static let circleTrackEnd: Color = Color(r: 235, g: 248, b: 255)
    
    static let circleRoundStart: Color = Color(r: 71, g: 198, b: 255)
    static let circleRoundEnd: Color = Color(r: 90, g: 131, b: 255)
    
    static let pillColor: Color = Color(r: 242, g: 53, b: 174)
    
    static let likeBackground: Color = Color(r: 49, g: 28, b: 78)
    static let likeOverlay: Color = Color(r: 64, g: 49, b: 82)
    
    static let likeColor: Color = Color(r: 254, g: 140, b: 100)
    
    static let submitColor: Color = Color(r: 110, g: 80, b: 249)
    
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
}
