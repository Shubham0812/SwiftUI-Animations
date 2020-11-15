//
//  BookHold.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 15/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct BookHoldView: Shape {
    
    // MARK:- variables
    
    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        
        let cX: CGFloat = rect.midX - 36
        let cY: CGFloat = rect.midY + 20
        
        ///phew, had to do a lot of hit and trials for this xD
        var path = Path()
        path.move(to: CGPoint(x: cX, y: cY - 20))
        path.addCurve(to: CGPoint(x: cX + 32, y: cY), control1: CGPoint(x: cX , y: cY), control2: CGPoint(x: cX, y: cY))
        path.addCurve(to: CGPoint(x: cX + 70, y: cY - 20), control1: CGPoint(x: cX + 70, y: cY), control2: CGPoint(x: cX + 70, y: cY))
        return path
    }
}

struct BookHoldView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            BookHoldView()
                .stroke(lineWidth: 4)
                .foregroundColor(.white)
            Capsule()
                .frame(width: 5)
                .foregroundColor(.white)
        }
    }
}
