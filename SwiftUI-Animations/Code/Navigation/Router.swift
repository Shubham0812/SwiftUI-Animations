//
//  Router.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK:- Router
/// A generic, per-tab navigation manager that owns a `NavigationPath`.
///
/// Each tab gets its own typed router instance — e.g. `Router<AnimationDestination>` for Home.
/// Views push destinations by calling `push(_:)` rather than constructing `NavigationLink` values
/// directly, keeping navigation logic out of view bodies.
///
/// Usage:
/// ```swift
/// // In RootView — bind the path to a NavigationStack:
/// NavigationStack(path: $coordinator.homeRouter.path) { HomeView() }
///
/// // In any child view — push a destination:
/// @EnvironmentObject var router: Router<AnimationDestination>
/// router.push(.circleLoader)
/// ```
@MainActor
final class Router<Destination: Hashable>: ObservableObject {

    // MARK:- variables
    @Published var path = NavigationPath()

    // MARK:- functions
    func push(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
