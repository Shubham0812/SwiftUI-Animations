//
//  LikeView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/25.
//  Copyright © 2025 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A heart "like" button with a celebratory burst animation.
///
/// Tap the heart to like it: the symbol swaps to a filled gradient heart with a
/// springy pop, a ring of capsule particles bursts outward and fades, an expanding
/// ring pulses out, and a soft glow blooms behind the heart. Use the reset button in
/// the top-trailing toolbar to return to the unliked state.
///
/// The animation is driven entirely by SwiftUI's `withAnimation` (with completion
/// handlers) and `sensoryFeedback` — no timers or polling.
struct LikeView: View {
    
    // MARK: - variables
    
    /// Whether the heart is currently liked. Drives the symbol, colour, and glow.
    @State private var isLiked = false
    /// Springy pop scale applied to the heart on like.
    @State private var heartScale: CGFloat = 1
    /// `true` only while a burst is playing, so particles aren't rendered at rest.
    @State private var isBursting = false
    /// 0 → 1 progress of the current burst, driving particle radius, fade, and the ring pulse.
    @State private var burstProgress: CGFloat = 0
    /// `true` only while the "+1" bubble is floating up.
    @State private var showPlusOne = false
    /// 0 → 1 progress of the "+1" float, driving its rise, sway, and fade.
    @State private var plusOneProgress: CGFloat = 0
    
    /// Number of capsule particles in the radial burst.
    private let particleCount = 14
    /// How far the particles travel from the heart's centre.
    private let burstRadius: CGFloat = 150
    
    /// Reddish heart palette and the matching backdrop.
    private let heartColor = Color(hex: "#F53342")
    private let heartColorDeep = Color(hex: "#CC1233")
    private let backgroundTop = Color(hex: "#29080F")
    private let backgroundBottom = Color(hex: "#570F1F")
    
    /// Shared reddish gradient used by the heart fill and the "+1" bubble.
    private let heartGradient = LinearGradient(
        colors: [Color(hex: "#F53342"), Color(hex: "#CC1233")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    /// Colours cycled through the burst particles for a livelier explosion.
    private let particleColors: [Color] = [
        Color(hex: "#F53342"),
        .pink,
        .orange,
        Color(hex: "#CC1233")
    ]
    
    // MARK: - views
    var body: some View {
        ZStack {
            // A dark reddish gradient that matches the heart.
            LinearGradient(
                colors: [backgroundTop, backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ZStack {
                // Soft radial bloom that fades in behind the heart once liked.
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [heartColor.opacity(isLiked ? 0.45 : 0), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 170
                        )
                    )
                    .frame(width: 340, height: 340)
                    .animation(.smooth(duration: 0.5), value: isLiked)
                
                // A thin ring that expands and fades outward on each like.
                Circle()
                    .stroke(heartColor, lineWidth: 2)
                    .frame(width: 130, height: 130)
                    .scaleEffect(0.6 + burstProgress * 1.6)
                    .opacity(isBursting ? (1 - burstProgress) : 0)
                
                // A radial fan of capsule particles that shoot out and fade as the burst plays.
                if isBursting {
                    ForEach(0..<particleCount, id: \.self) { index in
                        let angle = Angle.degrees(Double(index) / Double(particleCount) * 360)
                        let travel: CGFloat = burstProgress * burstRadius
                        let offsetX: CGFloat = cos(angle.radians) * travel
                        let offsetY: CGFloat = sin(angle.radians) * travel
                        let particleColor = particleColors[index % particleColors.count]
                        Capsule(style: .continuous)
                            .fill(particleColor)
                            .frame(width: 10, height: 26)
                            .scaleEffect(1 - burstProgress * 0.7)
                            .rotationEffect(angle + .degrees(90))
                            .offset(x: offsetX, y: offsetY)
                            .opacity(1 - burstProgress)
                    }
                }
                
                // The central heart symbol, swapping between outline and filled-gradient states.
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 180, weight: .semibold))
                    .foregroundStyle( isLiked ? AnyShapeStyle(heartGradient) : AnyShapeStyle(Color.white.opacity(0.35)))
                    .contentTransition(.symbolEffect(.replace))
                    .scaleEffect(heartScale)
                
                // A "+1" bubble that floats up and fades out each time the heart is liked.
                if showPlusOne {
                    Text("+1")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous).fill(heartGradient)
                        )
                        .rotationEffect(.degrees(-6 + Double(plusOneProgress) * 12))     // gentle sway
                        .scaleEffect(0.85 + (1 - plusOneProgress) * 0.15)
                        .offset(y: -70 - plusOneProgress * 170)                          // rises above the heart
                        .opacity(1 - plusOneProgress)
                }
            }
            .offset(y: -60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture { like() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 17, weight: .semibold))
                }
                .tint(heartColor)
                .disabled(!isLiked)
            }
        }
        // Success haptic on like, a lighter tap on reset.
        .sensoryFeedback(trigger: isLiked) { _, liked in
            liked ? .success : .impact(weight: .light)
        }
    }
    
    // MARK: - functions
    
    /// Likes the heart: pops the symbol and fires the particle/ring burst.
    private func like() {
        guard !isLiked else { return }
        
        withAnimation(.smooth(duration: 0.25)) {
            isLiked = true
        }
        
        // Springy pop — overshoot up, then settle back down.
        withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) {
            heartScale = 1.3
        } completion: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                heartScale = 1
            }
        }
        
        // One-shot burst: reset progress, animate to 1, then stop rendering particles.
        isBursting = true
        burstProgress = 0
        withAnimation(.easeOut(duration: 0.7)) {
            burstProgress = 1
        } completion: {
            isBursting = false
        }
        
        // "+1" bubble: float up and fade, then stop rendering it.
        showPlusOne = true
        plusOneProgress = 0
        withAnimation(.easeOut(duration: 0.9)) {
            plusOneProgress = 1
        } completion: {
            showPlusOne = false
        }
    }
    
    /// Returns the heart to its unliked resting state.
    private func reset() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            isLiked = false
            heartScale = 1
        }
    }
}

#Preview {
    NavigationStack {
        LikeView()
    }
}
