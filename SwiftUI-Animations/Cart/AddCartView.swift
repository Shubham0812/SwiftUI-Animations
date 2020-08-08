//
//  ContentView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

enum CartState {
    case ready
    case center
    case moveToEnd
    case origin
    
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
    
    var image: String {
        switch self {
        case .origin, .ready:
            return "cart"
        default:
            return "cart-fill"
        }
    }
    
    var animation: Animation {
        switch self {
        case .origin:
            return Animation.linear(duration: 0)
        default:
            return Animation.easeIn(duration: 0.55).delay(0.25)
        }
    }
}

struct AddCartView: View {
    // MARK:- variables
    @State var isAnimating: Bool = false
    @State var addItem: Bool = false
    @State var cartAnimation: CartState
    @State var bounceAnimation: Bool = false
    
    var backgroundColor: Color
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
            if (self.isAnimating){
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
