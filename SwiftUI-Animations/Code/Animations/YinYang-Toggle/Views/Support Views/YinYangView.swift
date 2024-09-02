//
//  YinYangView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

struct YinYangView: View {
    
    // MARK: - Variables
    @State var viewAppeared = false
    
    var scale: CGFloat = 1
    var size: CGFloat = 100
    
    var yYingOffset: CGFloat = -15
    var yYangOffset: CGFloat = 20
    
    let animationDuration: TimeInterval = 0.5
    
    // MARK: - Views
    var body: some View {
        ZStack {
            YinYangShape()
                .trim(from: 0, to: viewAppeared ? 1 : 0)
                .stroke(lineWidth: 2)
                .scaleEffect(scale)
                .animation(.easeInOut(duration: animationDuration), value: viewAppeared)
                .opacity(viewAppeared ? 0 : 1)
                .animation(.smooth(duration: animationDuration / 2).delay(animationDuration), value: viewAppeared)
            
            YinYangShape()
                .scaleEffect(scale)
                .overlay {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: size * scale, height: size * scale)
                        .offset(x: 2, y: 2)
                }
                .background {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(width: size * scale, height: size * scale)
                        .offset(y: 2)
                }
                .opacity(viewAppeared ? 1 : 0)
                .animation(.smooth.delay(animationDuration), value: viewAppeared)
                .overlay {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: viewAppeared ? 1 : 0)
                            .stroke(lineWidth: 2)
                            .animation(.snappy.delay(animationDuration * 1.2), value: viewAppeared)
                        Circle()
                            .opacity(viewAppeared ? 1 : 0)
                            .animation(.smooth.delay(animationDuration * 1.5), value: viewAppeared)
                    }
                    .frame(width: 11.5 * scale)
                    .offset(y: -yYingOffset) // Change the offset if needed when you change the main Scale
                }
                .overlay {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: viewAppeared ? 1 : 0)
                            .stroke(lineWidth: 2)
                            .animation(.snappy.delay(animationDuration * 1.5), value: viewAppeared)
                        Circle()
                            .opacity(viewAppeared ? 1 : 0)
                            .animation(.smooth.delay(animationDuration * 1.5), value: viewAppeared)
                    }
                    .foregroundColor(Color.white)
                    .frame(width: 12 * scale)
                    .offset(y: yYangOffset) // Change the offset if needed when you change the main Scale
                }
        }
        .onAppear() {
            viewAppeared.toggle()
        }
    }
}

#Preview {
    YinYangView(scale: 0.7, size: 100)
}
