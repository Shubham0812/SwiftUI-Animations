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
        ShaderItem(title: "Burn Effect", systemIcon: "flame.fill", iconColor: Color(r: 255, g: 69, b: 0), destination: .burnEffect, category: .transition),
    ]
}
