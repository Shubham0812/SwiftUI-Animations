//
//  YinYangAnimationView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 02/09/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The root view for the yin-yang theme switcher animation.
/// Composes the background transition, decorative lines, and the toggle control,
/// and drives the initial appear animation for the title/subtitle overlays.
struct YinYangAnimationView: View {
    
    // MARK: - Variables
    
    /// Used to read the current system color scheme (light/dark),
    /// though visual theming is driven by `yinYangViewModel.themeToggled` instead.
    @Environment(\.colorScheme) var colorScheme
    
    /// The shared view model that owns the toggle state and is passed
    /// down the view hierarchy via the environment.
    @State var yinYangViewModel: YinYangViewModel = .init()
    
    /// Flipped to `true` in `onAppear` to trigger the staggered entrance animations
    /// on the title, subtitle, and decorative lines.
    @State var viewAppeared = false
    
    /// Base duration used to stagger entrance animations and the background transition.
    let animationDuration: TimeInterval = 0.475
    
    /// Scale factor applied to the background color fill so it covers the full screen
    /// when expanded (scaleEffect is cheaper than frame-filling for this effect).
    let scale: CGFloat = 2.5
    
    
    // MARK: - Views
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                // Layered from back to front: background fill → decorative lines → toggle
                GenerateViewBackground()
                GenerateShapeView()
                GenerateYinToggleView()
            }
            // "Theme Switcher" title — slides up and fades in after a short delay
            .overlay(alignment: .topLeading) {
                VStack {
                    HStack {
                        Text("Theme Switcher")
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .tracking(-0.2)
                            .padding(.top, 14)
                            // Color flips with the theme so it stays readable on both backgrounds
                            .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                        Spacer()
                    }
                    // Entrance animation: slides up from +34pt and fades in
                    .offset(y: viewAppeared ? 0 : 34)
                    .opacity(viewAppeared ? 1 : 0)
                    .animation(.smooth.delay(animationDuration * 3), value: viewAppeared)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            // "@Shubham_iosdev" subtitle — same entrance animation, offset lower
            .overlay(alignment: .topLeading) {
                Text("@Shubham_iosdev")
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .tracking(-0.2)
                    .offset(y: viewAppeared ? 0 : 34)
                    .opacity(viewAppeared ? 0.7 : 0)   // Slightly dimmed vs the title
                    .padding(.top, 14)
                    .animation(.smooth.delay(animationDuration * 3), value: viewAppeared)
                    .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                    .padding(.leading, 24)
                    .padding(.top, 54)
            }
        }
        // Inject the view model so child views (e.g. YinToggleView) can read it
        .environment(yinYangViewModel)
        .onAppear() {
            // One-shot toggle that fires all entrance animations simultaneously
            viewAppeared.toggle()
        }
    }
    
    // MARK: - Functions
    
    /// Builds the two-layer background that transitions between light and dark themes.
    ///
    /// - Light mode: a full-screen white `Color` view is visible and the dark `Circle` is scaled to zero.
    /// - Dark mode: the white view collapses while a `Circle` expands from the yin-yang origin point,
    ///   painting the screen dark. Using `scaleEffect` (rather than changing the frame) keeps the
    ///   animation GPU-friendly and lets SwiftUI interpolate it smoothly.
    @ViewBuilder
    func GenerateViewBackground() -> some View {
        // White fill — present in light mode, scaled away when toggled to dark
        Color.white
            .ignoresSafeArea()
            .scaleEffect(!yinYangViewModel.themeToggled ? scale : 0)
            .opacity(yinYangViewModel.themeToggled ? 0 : 1)
            .animation(.smooth, value: yinYangViewModel.themeToggled)
        
        // Dark circle ripple — expands from the toggle when switching to dark mode.
        // Uses `.smooth` going in and `.snappy` coming back for an asymmetric feel.
        Circle()
            .ignoresSafeArea()
            .scaleEffect(yinYangViewModel.themeToggled ? scale : 0)
            .offset(y: -44)   // Aligned with the yin-yang toggle's vertical position
            .opacity(yinYangViewModel.themeToggled ? 1 : 0)
            .animation(
                yinYangViewModel.themeToggled
                    ? .smooth(duration: animationDuration)
                    : .snappy(duration: animationDuration),
                value: yinYangViewModel.themeToggled
            )
    }
    
    /// Builds the two thin diagonal lines that appear behind the toggle as decorative detail.
    ///
    /// Both lines are rotated –25° and positioned near the top of the screen.
    /// Their opacity shifts slightly between themes to keep them subtle on both backgrounds.
    /// The whole group fades in during the initial appear sequence.
    @ViewBuilder
    func GenerateShapeView() -> some View {
        ZStack {
            // Upper decorative line
            Rectangle()
                .foregroundColor(.label)
                .opacity(yinYangViewModel.themeToggled ? 0.25 : 0.02)
                .frame(height: 3)
                .scaleEffect(3)         // Stretched horizontally to bleed past screen edges
                .rotationEffect(.degrees(-25))
                .offset(y: -UIScreen.main.bounds.height * 0.5 + 48)
            
            // Lower decorative line — sits 36pt below the first
            Rectangle()
                .foregroundColor(.label)
                .opacity(yinYangViewModel.themeToggled ? 0.225 : 0.025)
                .foregroundStyle(yinYangViewModel.themeToggled ? Color.background : Color.label)
                .frame(height: 3)
                .scaleEffect(3)
                .rotationEffect(.degrees(-25))
                .offset(y: -UIScreen.main.bounds.height * 0.5 + 84)
        }
        // Fades in slightly later than the title to layer the entrance
        .opacity(viewAppeared ? 1 : 0)
        .animation(.smooth.delay(animationDuration * 3.25), value: viewAppeared)
    }
    
    /// Wraps `YinToggleView` and positions it at the vertical center of the screen,
    /// nudged upward by 44pt to leave breathing room below.
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
