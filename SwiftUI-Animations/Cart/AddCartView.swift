//
//  ContentView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

enum CartState {
    case origin
    case center
    case move
    
    var offset: CGFloat {
        switch self {
        case .origin:
            return -(UIScreen.main.bounds.width / 2 - 68)
        case .center:
            return -4
        case .move:
            return (UIScreen.main.bounds.width / 2 + 42)
        }
    }
    
    var image: String {
        switch self {
        case .origin:
            return "cart"
        case.center:
            return "cart-fill"
        default:
            return "cart-fill"
        }
    }
}

struct AddCartView: View {
    @State var isAnimating: Bool = false
    @State var addItem: Bool = false
    @State var cartAnimation: CartState
    @State var bounceAnimation: Bool = false
    
    var backgroundColor: Color
    var color: Color
    
    
    var body: some View {
        ZStack {
            self.backgroundColor
                .edgesIgnoringSafeArea(.all)
            ZStack {
                ZStack {
                    self.color
                    CartView(itemAdded: $addItem)
                        .offset(x: self.cartAnimation.offset)
                        .scaleEffect(self.isAnimating ? 1.1 : 1)
                        .animation(Animation.linear(duration: 0.5).delay(0.25))
                    
                    
                    Text("Add to cart")
                        .foregroundColor(self.backgroundColor)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .opacity(self.isAnimating ? 0 : 1)
                        .animation(Animation.spring())
                }
            }.frame(height: 72)
                .cornerRadius(12)
                .padding()
                .padding([.leading, .trailing], 16)
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
                        self.cartAnimation = .move
                    }
//                    Timer.scheduledTimer(withTimeInterval: 2.2, repeats: false) { (Timer) in
//                        self.isAnimating.toggle()
//                        self.addItem.toggle()
//                        self.cartAnimation = .origin
//                    }
            }
            Triangle()
                .fill(Color.white)
                .frame(width: 120, height: self.bounceAnimation ? 22 : 0)
                .animation(
                    Animation.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1)
                        .delay(0.35)
            )
                .offset(y: -36)
            ShirtView(itemAdded: $isAnimating)
                .frame(width: 22, height: 22)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddCartView(cartAnimation: .origin, backgroundColor: Color.black, color: Color.white)
        }
    }
}
