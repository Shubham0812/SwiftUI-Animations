//
//  RectangleLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct RectangleLoaderView: View {
    
    // MARK:- variables
    @State var yOffset: CGFloat = 0
    @State var rectangleHeight: CGFloat = 12
    
    // MARK:- views
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.materialBlack
                    .edgesIgnoringSafeArea(.all)
                HStack(alignment: .center, spacing: 8) {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .offset(x: 0, y: yOffset)
                        .animation(Animation.easeOut.delay(0))
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .offset(x: 0, y: yOffset)
                        .animation(Animation.easeOut.delay(0.2))
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .offset(x: 0, y: yOffset)
                        .animation(Animation.easeOut.delay(0.4))
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 12, height: rectangleHeight)
                        .offset(x: 0, y: yOffset)
                        .animation(Animation.easeOut.delay(0.6))
                }.onAppear() {
                    rectangleHeight = geometry.size.width * 0.25
                    animateRectangles(in: geometry)
                    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                        animateRectangles(in: geometry)
                    }
                }
            }
        }
    }
    
    // MARK:- functions
    func animateRectangles(in geometry: GeometryProxy) {
        rectangleHeight = geometry.size.width * 0.25
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            rectangleHeight = geometry.size.width * 0.1
        }
    }
}

struct RectangleLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleLoaderView()
            .frame(width: 200, height: 200)
    }
}
