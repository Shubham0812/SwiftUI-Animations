//
//  ShirtView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The three animation stages of the shirt icon in `ShirtView`.
///
/// - `.origin`: Shirt starts tiny (scale 0.2) at the cart position.
/// - `.top`: Shirt grows to full size (scale 1) and floats upward to `iconOffset = –120`.
/// - `.end`: Shirt shrinks (scale 0.5) and fades out (opacity 0) to simulate flying into the cart.
enum ShirtState {
    case origin
    case top
    case end

    /// Scale factor applied to the shirt image at this stage.
    var scale: CGFloat {
        switch self {
        case .origin:
            return 0.2
        case .top:
            return 1
        case .end:
            return 0.5
        }
    }
    
    /// Opacity of the shirt — 0 at `.end` (fade out), 1 otherwise.
    var opacity: Double {
        switch self {
        case .end:
            return 0
        default:
            return 1
        }
    }
}

/// A shirt icon that floats up and "flies into" the cart as confirmation of adding an item.
///
/// Waits for `itemAdded` to become `true` (polling every 0.1 s), then runs a two-phase animation:
/// 1. Shirt rises to `iconOffset = –120` and grows to full size (`.top`).
/// 2. Shirt changes color from white to black, shrinks, and fades out (`.end`).
///
/// Used inside `AddCartView` — positioned over the cart icon while it's centered.
struct ShirtView: View {
    /// Bound to `AddCartView.isAnimating`; animation begins when this becomes `true`.
    @Binding var itemAdded: Bool

    /// Current vertical offset of the shirt icon — starts low, rises, then drops slightly at end.
    @State var iconOffset: CGFloat = -12
    /// When `true`, switches from `"shirt-white"` to `"shirt-black"` image asset.
    @State var changeShirtColor: Bool = false
    /// Current animation stage driving scale and opacity.
    @State var shirtState: ShirtState = .origin
    
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            Image(self.changeShirtColor ? "shirt-black" : "shirt-white")
                .resizable()
                .frame(width: 27, height: 27)
                .scaleEffect(self.itemAdded ? self.shirtState.scale : 0.5)
                .animation(Animation.spring().speed(0.6))
                .offset(y: self.iconOffset)
                .animation(Animation.easeOut(duration: 0.35))
                .opacity(self.shirtState.opacity)
                .animation(Animation.default.delay(0.15))
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                        if (self.itemAdded) {
                            checkingTimer.invalidate()
                            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (Timer) in
                                self.iconOffset = -120
                                self.shirtState = .top
                            }
                            Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { (Timer) in
                                self.changeShirtColor.toggle()
                                self.shirtState = .end
                            }
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                                self.iconOffset = -6
                            }
                        }
                    }
            }
        }
    }
}

struct ShirtView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
            ShirtView(itemAdded: .constant(false))
        }
    }
}
