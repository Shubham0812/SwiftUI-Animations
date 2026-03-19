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
enum ShirtState: Equatable {
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
        Color.clear
            .ignoresSafeArea()
            .overlay(
                Image(changeShirtColor ? "shirt-black" : "shirt-white")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .scaleEffect(itemAdded ? shirtState.scale : 0.5)
                    .animation(.spring().speed(0.6), value: shirtState)
                    .offset(y: iconOffset)
                    .animation(.easeOut(duration: 0.35), value: iconOffset)
                    .opacity(shirtState.opacity)
                    .animation(.default.delay(0.15), value: shirtState)
            )
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                    if itemAdded {
                        checkingTimer.invalidate()
                        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { _ in
                            iconOffset = -120
                            shirtState = .top
                        }
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            iconOffset = -6
                        }
                        Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { _ in
                            changeShirtColor.toggle()
                            shirtState = .end
                        }
                    }
                }
            }
    }
}

#Preview {
    ZStack {
        Color.gray
            .ignoresSafeArea()
        ShirtView(itemAdded: .constant(false))
    }
}
