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
    
    @Binding var itemAdded: Bool
    
    var animationDuration: Double = 0.55
    var animationDelay: Double = 0.25
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
                .animation(.easeOut(duration: 0.35), value: itemAdded)
                .rotationEffect(itemAdded ? .degrees(-22) : .degrees(0))
                .animation(.easeIn(duration: animationDuration).delay(animationDelay), value: itemAdded)
        }
        .onTapGesture {
            HapticManager().makeImpactFeedback(mode: .light)
            itemAdded.toggle()
        }
    }
}


#Preview {
    CartView(itemAdded: .constant(true), animation: .easeIn(duration: 0.55).delay(0.25))
}
