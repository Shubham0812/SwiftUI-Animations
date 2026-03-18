//
//  ArcView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single colored wifi arc at a given `radius`, backed by an `ArcShape`.
///
/// Used in `WifiView` at three radii (12, 24, 36) to compose the stacked wifi signal icon.
/// Color and shadow are bound so the parent can transition all arcs simultaneously
/// from white (scanning) to green (connected).
struct ArcView: View {
    /// Distance from the center to the arc — larger values produce outer arcs.
    var radius: CGFloat
    /// Fill color of the arc, driven by the parent's `arcColor` state.
    @Binding var fillColor: Color
    /// Glow shadow color, driven by the parent's `shadowColor` state.
    @Binding var shadowColor: Color

    var body: some View {
        ArcShape(radius: radius)
            .fill(fillColor)
            .shadow(color: shadowColor, radius: 5)
            .frame(height: radius)
            .animation(Animation.spring().speed(0.75))
            .onTapGesture {
                self.fillColor = Color.wifiConnected
            }
    }
}

struct ArcView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            ArcView(radius: 42, fillColor: .constant(Color.wifiConnected), shadowColor: .constant(Color.red))
        }
    }
}
