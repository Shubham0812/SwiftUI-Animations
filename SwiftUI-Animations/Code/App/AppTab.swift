//
//  AppTab.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

// MARK:- AppTab
/// Enum representing the top-level tabs in the app.
/// Named `AppTab` (not `Tab`) to avoid collision with SwiftUI's iOS 18 `Tab` type.
/// To add a new tab: add a case here, a router in `AppCoordinator`, and a
/// `NavigationStack` entry in `RootView`.
enum AppTab: Hashable, CaseIterable {
    case home
    case shaders

    // MARK:- variables
    var title: String {
        switch self {
        case .home:    return "Home"
        case .shaders: return "Shaders"
        }
    }

    var systemIcon: String {
        switch self {
        case .home:    return "square.grid.2x2.fill"
        case .shaders: return "sparkles"
        }
    }
}
