//
//  ShaderItem.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - ShaderCategory
enum ShaderCategory: String, CaseIterable, Hashable {
    case effect
    case filter
    case transition
}

// MARK: - ShaderDestination
/// Navigation destinations for the Shaders tab.
/// Add a new case here when a new shader demo is introduced.
enum ShaderDestination: Hashable {
    case burnEffect
    case pixelSnap
    case emberReveal
    case rippleEffect
    case chromaticAberration
    case halftone
    case glitchEffect
}

// MARK: - ShaderItem
struct ShaderItem: Identifiable {

    let id = UUID()
    let title: String
    let systemIcon: String
    let iconColor: Color
    let destination: ShaderDestination
    let category: ShaderCategory

    // MARK: - All Shaders
    static let all: [ShaderItem] = [
        ShaderItem(title: "Burn Effect",          systemIcon: "flame.fill",                  iconColor: Color(r: 255, g: 69,  b: 0),   destination: .burnEffect,          category: .effect),
        ShaderItem(title: "Pixel Appear",         systemIcon: "hand.point.up.braille.fill",  iconColor: .indigo,                       destination: .pixelSnap,           category: .effect),
        ShaderItem(title: "Ember Reveal",         systemIcon: "sparkles",                    iconColor: Color(r: 255, g: 140, b: 0),   destination: .emberReveal,         category: .effect),
        ShaderItem(title: "Wave Ripple",          systemIcon: "water.waves",                 iconColor: .cyan,                         destination: .rippleEffect,        category: .effect),
        ShaderItem(title: "Glitch",               systemIcon: "bolt.fill",                   iconColor: Color(r: 57,  g: 255, b: 20),  destination: .glitchEffect,        category: .effect),
    ]
}
