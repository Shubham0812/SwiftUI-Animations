//
//  BurnEffect.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - BurnEffectModifier
/// A `ViewModifier` that applies an animated burn/fire dissolve effect via a Metal layer shader.
///
/// The shader sweeps from top to bottom as `progress` moves from `1.0` (fully intact)
/// to `0.0` (fully burned away). An organic noise layer gives the burn edge its
/// flickering, fire-like shape, driven by the elapsed animation time.
///
/// Usage:
/// ```swift
/// myView.burnEffect(progress: progress)
/// ```
struct BurnEffectModifier: ViewModifier {

    // MARK: - variables
    var progress: Double
    @State private var startDate = Date()

    // MARK: - views
    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsedTime = timeline.date.timeIntervalSince(startDate)
            content
                .modifier(BurnLayoutWrapper(progress: progress, time: elapsedTime))
        }
    }
}

// MARK: - BurnLayoutWrapper
/// Bridges geometry-aware data (view size) to the Metal shader via `visualEffect`.
struct BurnLayoutWrapper: ViewModifier {

    // MARK: - variables
    var progress: Double
    var time: Double

    // MARK: - views
    func body(content: Content) -> some View {
        content
            .visualEffect { content, geometryProxy in
                content.layerEffect(
                    ShaderLibrary.burnEffect(
                        .float2(geometryProxy.size.width, geometryProxy.size.height),
                        .float(progress),
                        .float(time)
                    ),
                    maxSampleOffset: .zero
                )
            }
    }
}

// MARK: - View Extension
extension View {
    /// Applies an animated burn/fire dissolve shader to this view.
    ///
    /// - Parameter progress: `1.0` = fully intact, `0.0` = fully burned away.
    func burnEffect(progress: Double) -> some View {
        self.modifier(BurnEffectModifier(progress: progress))
    }
}
