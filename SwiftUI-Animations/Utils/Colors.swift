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
    
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
}
