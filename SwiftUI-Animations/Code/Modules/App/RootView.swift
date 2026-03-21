//
//  RootView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK:- RootView
/// The top-level view that owns the `TabView` and per-tab `NavigationStack`s.
///
/// Each tab's `NavigationStack` is bound to the corresponding router's `path` on
/// `AppCoordinator`. Because `coordinator` is a `@StateObject`, both tab selection
/// and navigation stacks survive tab switches — each tab maintains its own independent
/// navigation state.
struct RootView: View {

    // MARK:- variables
    @StateObject private var coordinator = AppCoordinator()

    // MARK:- views
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack(path: $coordinator.homeRouter.path) {
                HomeView()
            }
            .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.systemIcon) }
            .tag(AppTab.home)

            NavigationStack(path: $coordinator.shadersRouter.path) {
                ShaderView()
            }
            .tabItem { Label(AppTab.shaders.title, systemImage: AppTab.shaders.systemIcon) }
            .tag(AppTab.shaders)
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
