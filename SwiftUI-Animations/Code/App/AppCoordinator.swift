//
//  AppCoordinator.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK:- AppCoordinator
/// Global coordinator that owns tab selection and all per-tab routers.
///
/// `RootView` holds this as a `@StateObject` and injects it via `.environmentObject`.
/// Child views should depend only on the specific `Router` for their tab, not on
/// the coordinator itself — this keeps inter-tab coupling at zero.
///
/// To add a new tab:
/// 1. Add a case to `AppTab`.
/// 2. Add a `let newTabRouter = Router<NewTabDestination>()` property here.
/// 3. Add a `case .newTab: newTabRouter.popToRoot()` branch in `selectTab(_:)`.
/// 4. Add the `NavigationStack` + `.tabItem` entry in `RootView`.
@MainActor
final class AppCoordinator: ObservableObject {

    // MARK:- variables
    @Published var selectedTab: AppTab = .home

    let homeRouter    = Router<AnimationDestination>()
    let shadersRouter = Router<ShaderDestination>()

    // MARK:- functions
    /// Selects a tab. If the tab is already active, pops its navigation stack to root —
    /// matching the standard iOS behavior when tapping the current tab bar item.
    func selectTab(_ tab: AppTab) {
        if selectedTab == tab {
            switch tab {
            case .home:    homeRouter.popToRoot()
            case .shaders: shadersRouter.popToRoot()
            }
        } else {
            selectedTab = tab
        }
    }
}
