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
            return  -(UIScreen.main.bounds.width / 2 - 80)
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
            return Animation.linear(duration: 0)
        default:
            return Animation.easeIn(duration: 0.55).delay(0.25)
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
    // MARK:- variables

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
    
    // MARK:- views
    var body: some View {
        ZStack {
            self.backgroundColor
                .edgesIgnoringSafeArea(.all)
            ZStack {
                    self.color
                    CartView(itemAdded: $addItem, animation: self.cartAnimation.animation)
                        .offset(x: self.cartAnimation.offset)
                        .scaleEffect(self.isAnimating ? 1.1 : 1)
                        .animation(Animation.linear(duration: 0.5).delay(0.25))
                    
                    
                    Text("Add to cart")
                        .foregroundColor(self.backgroundColor)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .opacity(self.isAnimating ? 0 : 1)
                        .animation(Animation.spring())
                
            }.frame(height: 72)
                .cornerRadius(12)
                .padding()
                .padding([.leading, .trailing], 24)
                .shadow(radius: 10)
                .scaleEffect(x: self.bounceAnimation ? 0.98 : 1, y: 1, anchor: .center)
                .animation(
                    Animation.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1)
                        .delay(0.15)
            )
                
                .onTapGesture {
                    self.cartAnimation = .center
                    self.isAnimating.toggle()
                    self.bounceAnimation.toggle()
                    
                    Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (Timer) in
                        self.bounceAnimation.toggle()
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { (Timer) in
                        self.addItem.toggle()
                    }
                    Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { (Timer) in
                        self.cartAnimation = .moveToEnd
                    }
                    Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (Timer) in
                        self.isAnimating.toggle()
                        self.addItem.toggle()
                        self.cartAnimation = .origin
                    }
            }
            Triangle()
                .fill(Color.white)
                .frame(width: 120, height: self.bounceAnimation ? 22 : 0)
                .animation(
                    Animation.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1)
                        .delay(0.35)
            )
                .offset(y: -36)
            if (self.isAnimating) {
                ShirtView(itemAdded: $isAnimating)
                    .frame(width: 22, height: 22)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCartView(cartAnimation: .ready, backgroundColor: Color.black, color: Color.white)
        }
    }
}
