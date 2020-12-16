//
//  LightSwitchView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 16/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct LightSwitchView: View {
    
    // MARK:- variables
    let appWidth = UIScreen.main.bounds.width
    let appHeight = UIScreen.main.bounds.height
    let animationDuration: TimeInterval = 0.35
    
    @State var xScale: CGFloat = 2
    @State var yScale: CGFloat = 0.4
    @State var yOffset: CGFloat = UIScreen.main.bounds.height * 0.8
    
    
    @State var isOff: Bool = true
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
            Circle()
                .fill(Color.yellow)
                .scaleEffect(CGSize(width: xScale, height: yScale))
                .offset(y: yOffset)
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "arrow.left")
                        .foregroundColor(isOff ? .white : .black)
                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                    Spacer()
                    Text("Study Room")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(isOff ? .white : .black)
                        .offset(x: -12)
                    Spacer()
                }.padding([.top, .bottom], 24)
                Spacer()
            }.offset(y: 32)
            .padding([.leading, .trailing], 24)
            ZStack {
                Capsule(style: .continuous)
                    .foregroundColor(.gray)
                    .frame(width: 52, height: appHeight * 0.25 + 6)
                    .opacity(0.275)
                    .offset(x: appWidth / 2 - 48, y: 16)
                ZStack {
                    Capsule()
                        .frame(width: 3, height: self.isOff ? appHeight * 0.41 : appHeight * 0.625)
                        .foregroundColor(.white)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 42, height: 42)
                        .offset(y: self.isOff ? appHeight * 0.225: appHeight * 0.25 + 42)
                        .onTapGesture {
                            toggleAllLights()
                        }
                }.offset(x: appWidth / 2 - 48, y: -appHeight / 2)
                .frame(height: 0, alignment: .top)
            }
            .animation(Animation.spring(dampingFraction: 0.65).speed(1.25))
        }.edgesIgnoringSafeArea(.all)
    }
    
    // MARK:- functions
    func toggleAllLights() {
        if (isOff) {
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                xScale = 4
                yScale = 4
                yOffset = 0
            }
        } else {
            withAnimation(Animation.easeOut(duration: animationDuration * 0.75)) {
                yScale = 0.4
                xScale = 2
                yOffset = UIScreen.main.bounds.height * 0.8
            }
        }
        isOff.toggle()
    }
}

struct LightSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        LightSwitchView()
    }
}
