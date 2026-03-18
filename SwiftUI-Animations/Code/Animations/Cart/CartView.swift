//
//  CartView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A tappable cart icon that tilts and shows a checkmark when an item is added.
///
/// When `itemAdded` is `true`:
/// - Switches from the empty `"cart"` image to the filled `"cart-fill"` image.
/// - Rotates –22° to create a dynamic "received item" tilt.
/// - Draws a red `Tick` checkmark that grows in using a trimmed stroke animation.
struct CartView: View {

    /// `true` when an item has been added — drives the icon swap, tilt, and tick draw.
    @Binding var itemAdded: Bool

    /// Base animation duration (used for the tick trim animation).
    var animationDuration: Double = 0.55
    /// Delay before the animation starts after `itemAdded` changes.
    var animationDelay: Double = 0.25
    /// Animation curve injected by the parent, applied to both the image rotation and tick.
    var animation: Animation
    
    var body: some View {
        ZStack {
            Image(self.itemAdded ? "cart-fill" : "cart")
                .resizable()
                .frame(width: 42, height: 42)
                .rotationEffect(self.itemAdded ? .degrees(-22) : .degrees(0))
                .animation(self.animation)
            Tick(scaleFactor: 0.125)
                .trim(from: 0, to: self.itemAdded ? 1 : 0)
                .stroke(style: StrokeStyle(lineWidth: 2.4, lineCap: .round))
                .foregroundColor(Color.red)
                .frame(width: 42, height: 42)
                .animation(.easeOut(duration: 0.35))
                .rotationEffect(self.itemAdded ? .degrees(-22) : .degrees(0))
                .animation(Animation.easeIn(duration: self.animationDuration).delay(self.animationDelay))
        }.onTapGesture {
            self.itemAdded.toggle()
        }
    }
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(itemAdded: .constant(true), animation: Animation.easeIn(duration: 0.55).delay(0.25))
    }
}
