//
//  CartView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CartView: View {
    
    @Binding var itemAdded: Bool
    
    var animationDuration: Double = 0.55
    var animationDelay: Double = 0.25
    
    var body: some View {
        ZStack {
            Image(self.itemAdded ? "cart-fill" : "cart")
                .resizable()
                .frame(width: 42, height: 42)
                .rotationEffect(self.itemAdded ? .degrees(-22) : .degrees(0))
                .animation(Animation.easeIn(duration: self.animationDuration).delay(self.animationDelay))
            Tick()
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

struct Tick: Shape {
    func path(in rect: CGRect) -> Path {
        let cX = rect.midX + 4
        let cY = rect.midY - 3
        let scaleFactor: CGFloat = 0.125
        
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.move(to: CGPoint(x: cX - (42 * scaleFactor), y: cY - (4 * scaleFactor)))
        path.addLine(to: CGPoint(x: cX - (scaleFactor * 18), y: cY + (scaleFactor * 28)))
        path.addLine(to: CGPoint(x: cX + (scaleFactor * 46), y: cY - (scaleFactor * 36)))
        return path
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(itemAdded: .constant(true))
    }
}
