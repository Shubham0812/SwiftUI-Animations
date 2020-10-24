//
//  Bolt.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct Bolt: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 211.67, y: 327.33))
        path.addLine(to: CGPoint(x: 175, y: 371.33))
        path.addLine(to: CGPoint(x: 208, y: 371.33))
        
        path.addLine(to: CGPoint(x: 204.33, y: 400.67))
        path.addLine(to: CGPoint(x: 241, y: 356.67))
        
        path.addLine(to: CGPoint(x: 208, y: 356.67))
        path.addLine(to: CGPoint(x: 211.67, y: 327.33))
        return path
    }
}

struct Bolt_Previews: PreviewProvider {
    static var previews: some View {
        Bolt()
    }
}
