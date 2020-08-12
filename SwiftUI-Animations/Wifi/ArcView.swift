//
//  ArcView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 11/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct ArcView: View {
    var radius: CGFloat
    @Binding var fillColor: Color
    @Binding var shadowColor: Color

    var body: some View {
        ArcShape(radius: radius)
            .fill(fillColor)
            .shadow(color: shadowColor, radius: 5)
            .frame(height: radius)
            .animation(Animation.spring().speed(0.75))
            .onTapGesture {
                fillColor = Color.wifiConnected
            }
    }
}

struct ArcView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            ArcView(radius: 42, fillColor: .constant(Color.wifiConnected), shadowColor: .constant(Color.red))
        }
    }
}
