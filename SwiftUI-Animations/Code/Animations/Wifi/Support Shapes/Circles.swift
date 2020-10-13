//
//  Circles.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 12/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct Circles : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        path.move(to: rect.origin)
        for _ in 0 ..< 18 {
            let barHeight = CGFloat.random(in: 2.5 ..< 7)
            let barRect = CGRect(x: CGFloat.random(in: rect.minX ..< rect.midX),
                                 y: CGFloat.random(in: rect.minY ..< rect.midY),
                                 width: barHeight,
                                 height: barHeight)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: barHeight / 2, height: barHeight / 2))
        }
        for _ in 0 ..< 18 {
            let barHeight = CGFloat.random(in: 2.5 ..< 7)
            let barRect = CGRect(x: CGFloat.random(in: rect.midX ..< rect.maxX),
                                 y: CGFloat.random(in: rect.minY ..< rect.midY),
                                 width: barHeight,
                                 height: barHeight)
            path.addRoundedRect(in: barRect, cornerSize: CGSize(width: barHeight / 2, height: barHeight / 2))
        }
        return path
    }
}
struct Circles_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Circles()
                .fill(Color.red)
                .frame(height: 300)
        }
    }
}
