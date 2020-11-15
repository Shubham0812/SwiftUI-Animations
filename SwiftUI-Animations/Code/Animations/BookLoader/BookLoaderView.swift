//
//  BookLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 15/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct BookLoaderView: View {
    
    // MARK:- variables
    @State var rotationDegrees: Angle = .degrees(0)
    
    
    let bookCoverWidth: CGFloat = 120
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
         
            Capsule()
                .foregroundColor(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: -92, y: 0)
                .rotationEffect(rotationDegrees * 2, anchor: .center)
            BookHoldView()
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .miter))
                .foregroundColor(.white)
                .rotationEffect(rotationDegrees)
                .offset(x: 40, y: -34)
            Capsule()
                .foregroundColor(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: 92)
        }.onAppear() {
            withAnimation(Animation.easeIn(duration: 0.35)) {
                rotationDegrees = .degrees(90)
            }
        }
    }
}

struct BookLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        BookLoaderView()
    }
}
