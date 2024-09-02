//
//  YinYangToggleView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

struct YinToggleView: View {
    
    // MARK: - Variables
    @Environment(YinYangViewModel.self) var yinYangViewModel
    @State var viewAppeared = false

    
    let animationDuration: TimeInterval = 0.75
    let xOffset: CGFloat = 28.5
    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            Capsule(style: .continuous)
                .trim(from: 0, to: viewAppeared ? 1 : 0)
                .stroke(lineWidth: 3)
                .foregroundColor(.gray)
                .animation(.smooth(duration: animationDuration).delay(animationDuration * 1.25), value: viewAppeared)
                .overlay(alignment: .leading) {
                    YinYangView(scale: 0.565, yYingOffset: 10, yYangOffset: 15)
                        .offset(y: -2)
                        .rotationEffect(yinYangViewModel.themeToggled ? .degrees(180) : .zero)
                        .offset(x: yinYangViewModel.themeToggled ? proxy.size.width / 2 - xOffset : -proxy.size.width / 2 + xOffset)
                }
                .background {
                    Capsule(style: .continuous)
                        .opacity(viewAppeared ? yinYangViewModel.themeToggled ? 0.95 : 0.8 : 0)
                        .foregroundStyle(!yinYangViewModel.themeToggled ? .black : .white)
                        .animation(.smooth(duration: animationDuration * 1.25).delay(animationDuration * 1.5), value: viewAppeared)
                }
                .onTapGesture {
                    withAnimation(.snappy(duration: animationDuration)) {
                        yinYangViewModel.themeToggled.toggle()
                    }
                }
                .onAppear() {
                    viewAppeared.toggle()
                }
        }
    }
}

#Preview {
    YinToggleView()
        .frame(width: 140, height: 62)
        .environment(YinYangViewModel())
}
