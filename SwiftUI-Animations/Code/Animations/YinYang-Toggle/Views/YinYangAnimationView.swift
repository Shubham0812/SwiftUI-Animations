//
//  YinYangAnimationView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

struct YinYangAnimationView: View {
    // MARK: - Variables
    @Environment(\.colorScheme) var colorScheme
    @State var yinYangViewModel: YinYangViewModel = .init()
    
    @State var viewAppeared = false
    
    let animationDuration: TimeInterval = 0.475
    let scale: CGFloat = 2.5
    
    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                GenerateViewBackground()
                GenerateShapeView()
                GenerateYinToggleView()
            }
            .overlay(alignment: .topLeading) {
                VStack {
                    HStack {
                        Text("Theme Switcher")
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .tracking(-0.2)
                            .padding(.top, 14)
                            .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                        
                        Spacer()
                    }
                    .offset(y: viewAppeared ? 0 : 34)
                    .opacity(viewAppeared ? 1 : 0)
                    .animation(.smooth.delay(animationDuration * 3), value: viewAppeared)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .overlay(alignment: .topLeading) {
                Text("@Shubham_iosdev")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .tracking(-0.2)
                    .offset(y: viewAppeared ? 0 : 34)
                    .opacity(viewAppeared ? 0.7 : 0)
                    .padding(.top, 14)
                    .animation(.smooth.delay(animationDuration * 3), value: viewAppeared)
                    .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                    .padding(.leading, 24)
                    .padding(.top, 54)
                
            }
        }
        .environment(yinYangViewModel)
        .onAppear() {
            viewAppeared.toggle()
        }
    }
    
    // MARK: - Functions
    @ViewBuilder
    func GenerateViewBackground() -> some View {
        Color.white
            .ignoresSafeArea()
            .scaleEffect(!yinYangViewModel.themeToggled ? scale : 0)
            .opacity(yinYangViewModel.themeToggled ? 0 : 1)
            .animation(.smooth, value: yinYangViewModel.themeToggled)
        
        Circle()
            .ignoresSafeArea()
            .scaleEffect(yinYangViewModel.themeToggled ? scale : 0)
            .offset(y: -44)
            .opacity(yinYangViewModel.themeToggled ? 1 : 0)
            .animation(yinYangViewModel.themeToggled ? .smooth(duration: animationDuration) : .snappy(duration: animationDuration), value: yinYangViewModel.themeToggled)
    }
    
    @ViewBuilder
    func GenerateShapeView() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.label)
                .opacity(yinYangViewModel.themeToggled ? 0.25 : 0.02)
                .frame(height: 3)
                .scaleEffect(3)
                .rotationEffect(.degrees(-25))
                .offset(y: -UIScreen.main.bounds.height * 0.5 + 48)
            
            Rectangle()
                .foregroundColor(.label)
                .opacity(yinYangViewModel.themeToggled ? 0.225 : 0.025)
                .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                .frame(height: 3)
                .scaleEffect(3)
                .rotationEffect(.degrees(-25))
                .offset(y: -UIScreen.main.bounds.height * 0.5 + 84)
        }
        .opacity(viewAppeared ? 1 : 0)
        .animation(.smooth.delay(animationDuration * 3.25), value: viewAppeared)
    }
    
    @ViewBuilder
    func GenerateYinToggleView() -> some View {
        YinToggleView()
            .frame(width: 140, height: 62)
            .offset(y: -44)
        
    }
}

#Preview {
    YinYangAnimationView()
}
