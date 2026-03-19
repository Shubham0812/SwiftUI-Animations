//
//  ContentView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The four stages of the cart icon's horizontal travel inside the "Add to cart" button.
///
/// - `.ready` / `.origin`: Cart starts off-screen to the left (hidden behind the label).
/// - `.center`: Cart slides to the center of the button while the label fades out.
/// - `.moveToEnd`: Cart flies off-screen to the right, simulating dispatch.
/// After `.moveToEnd`, everything resets to `.origin` (linear 0-duration snap) for the next tap.
enum CartState {
    case ready
    case center
    case moveToEnd
    case origin

    /// Horizontal x-offset for the cart icon at this state.
    var offset: CGFloat {
        switch self {
        case .origin, .ready:
            return -(UIScreen.main.bounds.width / 2 - 80)
        case .center:
            return -4
        case .moveToEnd:
            return (UIScreen.main.bounds.width / 2 + 42)
        }
    }

    /// Cart image name — empty cart for idle states, filled cart when traveling.
    var image: String {
        switch self {
        case .origin, .ready:
            return "cart"
        default:
            return "cart-fill"
        }
    }

    /// Animation curve for the cart's horizontal travel.
    /// `.origin` uses a zero-duration linear snap (invisible reset); all other states ease in.
    var animation: Animation {
        switch self {
        case .origin:
            return .linear(duration: 0)
        default:
            return .easeIn(duration: 0.55).delay(0.25)
        }
    }
}

/// A full "Add to cart" button with a multi-step cart travel animation.
///
/// **Tap sequence:**
/// 1. Button bounces (spring squeeze) and "Add to cart" label fades out.
/// 2. Cart icon slides from left edge to center (`.center`).
/// 3. A tick checkmark appears on the cart icon at `t ≈ 1.4 s`.
/// 4. Cart flies off the right edge (`.moveToEnd`) at `t ≈ 1.6 s`.
/// 5. Everything resets at `t ≈ 2.5 s` — label fades back in, cart snaps to origin.
///
/// A white `Triangle` bubble pops above the button during the bounce phase
/// and a `ShirtView` floats up from the cart while it's in the center.
struct AddCartView: View {

    // MARK: - Variables

    /// `true` while the cart is in motion (label hidden, shirt visible).
    @State var isAnimating: Bool = false
    /// Passed to `CartView` — triggers the tick checkmark and cart tilt at the right moment.
    @State var addItem: Bool = false
    /// Current stage of the cart's horizontal travel; drives offset and image via `CartState`.
    @State var cartAnimation: CartState
    /// Drives the button spring-squeeze and Triangle bubble animations.
    @State var bounceAnimation: Bool = false

    /// Background color of the full screen (passed through to the button overlay text color).
    var backgroundColor: Color
    /// Fill color of the button pill.
    var color: Color

    // MARK: - Views

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            ZStack {
                color
                CartView(itemAdded: $addItem, animation: cartAnimation.animation)
                    .offset(x: cartAnimation.offset)
                    .scaleEffect(isAnimating ? 1.1 : 1)
                    .animation(.linear(duration: 0.5).delay(0.25), value: isAnimating)

                Text("Add to cart")
                    .foregroundStyle(backgroundColor)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .opacity(isAnimating ? 0 : 1)
                    .animation(.spring(), value: isAnimating)
            }
            .frame(height: 72)
            .cornerRadius(12)
            .padding()
            .padding([.leading, .trailing], 24)
            .shadow(radius: 10)
            .scaleEffect(x: bounceAnimation ? 0.98 : 1, y: 1, anchor: .center)
            .animation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1).delay(0.15), value: bounceAnimation)
            .onTapGesture {
                cartAnimation = .center
                isAnimating.toggle()
                bounceAnimation.toggle()

                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                    bounceAnimation.toggle()
                }
                Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { _ in
                    addItem.toggle()
                }
                Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { _ in
                    cartAnimation = .moveToEnd
                }
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                    isAnimating.toggle()
                    addItem.toggle()
                    cartAnimation = .origin
                }
            }

            Triangle()
                .fill(.white)
                .frame(width: 120, height: bounceAnimation ? 22 : 0)
                .animation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1).delay(0.35), value: bounceAnimation)
                .offset(y: -36)

            if isAnimating {
                ShirtView(itemAdded: $isAnimating)
                    .frame(width: 22, height: 22)
            }
        }
    }
}

#Preview {
    AddCartView(cartAnimation: .ready, backgroundColor: .black, color: .white)
}
