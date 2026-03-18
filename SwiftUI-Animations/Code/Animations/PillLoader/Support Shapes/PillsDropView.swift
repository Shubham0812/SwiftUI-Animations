//
//  PillDropView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Composes three `PillGroupView` clusters into a full particle burst effect.
///
/// The three groups are vertically staggered (`y` offsets: 0, –45, –99.5 pt) so the
/// dots appear to spill out from the bottom, middle, and upper portions of the pill.
/// Together they create the visual effect of liquid dots erupting from the open pill.
///
/// Shown in `PillLoader` when `hideCapsule` is `true` (pill is split open).
struct PillsDropView: View {

    // MARK:- variables

    /// Passed through to all three `PillGroupView` instances to trigger the burst.
    @Binding var isAnimating: Bool
    
    // MARK:- views
    var body: some View {
        ZStack {
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: 0, height: 0), animationOffset: 0.05)
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: 10, height: -45), animationOffset: 0.05)
            PillGroupView(isAnimating: $isAnimating, initialOffSet: CGSize(width: -10, height: -99.5), animationOffset: 0.025)
        }
    }
}

struct PillDropView_Previews: PreviewProvider {
    static var previews: some View {
        PillsDropView(isAnimating: .constant(false))
    }
}
