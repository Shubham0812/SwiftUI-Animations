//
//  CircularDownloadView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/06/22.
//  Copyright © 2022 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A circular download indicator that sequences three states — idle, downloading, and
/// downloaded — inside a single ring.
///
/// **Interaction:** tap anywhere to start the (simulated) download.
///
/// **What's layered inside the ring (back to front):**
/// 1. A liquid `DownloadWaveFill` that rises from the bottom, masked to a circle so it
///    reads as water filling a container.
/// 2. A solid stroked `Circle` border.
/// 3. A `DownloadArrowShape` that morphs into a downward "drop" on tap, plus a
///    `DownloadTickShape` checkmark that draws itself in on completion.
/// 4. Two trimmed `Circle`s that grow symmetrically from the top to form the progress ring.
/// 5. A monospaced percentage label, visible only while downloading.
///
/// **State flow:**
/// ```
/// notInitiated ──tap──► downloading ──(percentage hits 100)──► downloaded
/// ```
///
/// > Note: Progress is driven by timers for demonstration only. Replace the timer-based
/// > increments in `animate()` with real download-progress callbacks for production use.
struct CircularDownloadView: View {
    
    // MARK: - Variables
    
    /// How far each half of the progress ring is drawn (0 = empty, 0.5 = a full semicircle each).
    /// Two mirrored circles each trim to 0.5, so together they complete the full ring.
    @State private var circleTrim: CGFloat = 0
    
    /// Draw-in progress for the arrow icon (0 = hidden, 1 = fully drawn on appear).
    @State private var arrowEnd: CGFloat = 0
    
    /// The current stage of the download lifecycle. Reuses the shared `DownloadState` enum.
    @State private var downloadState: DownloadState = .notInitiated
    
    /// The number shown in the centre label, counted from 0 to 100 while downloading.
    @State private var downloadPercentage: CGFloat = 0
    
    /// Phase accumulator fed into the wave shapes so the liquid surface keeps rippling.
    @State private var time: CGFloat = 0.5
    
    /// Horizontal "pinch" applied to the arrowhead so it narrows into a droplet on tap.
    @State private var animatableX: CGFloat = 0
    
    /// Vertical travel of the liquid fill. Animated to raise/lower the water level.
    @State private var fillOffset: CGFloat = 0
    
    /// Vertical position of the arrow. Springs in on appear, then drops on tap.
    @State private var arrowYOffset: CGFloat = -40
    
    /// Extends the arrow's shaft downward on tap so it stretches into a falling drop.
    @State private var lineDifference: CGFloat = 0
    
    /// Timers driving the in-flight download, kept so `reset()` can cancel them.
    @State private var downloadTimers: [Timer] = []
    
    /// Nominal height of the arrow shape; also reused as the arrow's drop distance.
    private let arrowHeight: CGFloat = 100
    
    /// Duration of the main progress-ring sweep. The percentage timer is paced to match.
    private let animationDuration: TimeInterval = 4
    
    /// Blue used for the ring border and the liquid fill.
    private let fillColor: Color = .init(hex: "2079ff")
    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ZStack {
                    // Liquid fill — two offset waves stacked for depth, masked to a circle.
                    // Before the download starts the level sits low; once it begins it rises.
                    ZStack {
                        DownloadWaveFill(curve: time * 0.5, curveHeight: 10, curveLength: 5)
                            .fill(fillColor.opacity(0.985))
                            .offset(y: downloadState != .notInitiated ? fillOffset : -fillOffset + 5)
                        
                        DownloadWaveFill(curve: time * 0.25, curveHeight: 5, curveLength: 10)
                            .fill(fillColor.opacity(0.9))
                            .offset(y: downloadState != .notInitiated ? fillOffset : -fillOffset + 7)
                    }
                    .mask(Circle().scaleEffect(0.91))
                    
                    // Solid ring border.
                    Circle()
                        .stroke(lineWidth: 10)
                        .fill(fillColor)
                        .opacity(0.85)
                    
                    // Centre iconography: the download arrow and the completion checkmark.
                    ZStack {
                        // Arrow that draws in on appear and morphs into a drop on tap.
                        DownloadArrowShape(lineWidth: arrowHeight, animatableX: animatableX, lineDifference: lineDifference)
                            .trim(from: 0, to: arrowEnd)
                            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                            .offset(y: arrowYOffset)
                        
                        // Checkmark — trims from 0 to 1 (draws itself in) only once downloaded.
                        DownloadTickShape(scaleFactor: 1)
                            .trim(from: 0, to: downloadState == .downloaded ? 1 : 0)
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .offset(y: 6)
                            .foregroundColor(Color.white)
                            .animation(.easeOut(duration: 0.35), value: downloadState)
                    }
                    
                    // Progress ring — two mirrored half-circles that grow from the top.
                    // One is flipped on the X axis so both sweep outward symmetrically.
                    ZStack {
                        Circle()
                            .trim(from: 0, to: circleTrim)
                            .stroke(style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(270))
                            .rotation3DEffect(.degrees(180), axis: (x: 1.0, y: 0.0, z: 0.0))
                        
                        Circle()
                            .trim(from: 0, to: circleTrim)
                            .stroke(style: StrokeStyle(lineWidth: 11, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(90))
                    }
                    .foregroundColor(.init(hex: "efefef"))
                    .zIndex(3)
                    
                    // Percentage read-out, shown only during the downloading phase.
                    Text("\(Double(downloadPercentage).clean(places: 2))%")
                        .font(.system(size: 64, weight: .semibold, design: .monospaced))
                        .foregroundColor(.label)
                        .frame(minWidth: 300)
                        .opacity(downloadState == .downloading ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: downloadState)
                }
                .frame(width: proxy.size.width * 0.5)
                .offset(y: -72)
            }
            .onTapGesture {
                initiateDownload()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 17, weight: .semibold))
                }
                .tint(.primary)
                .disabled(downloadState != .downloaded)
            }
        }
        .onAppear {
            // Prime the resting water level and spring the arrow in from above.
            fillOffset = -150
            
            // Use the explicit pre-iOS-17 default spring. `.spring()` was redefined in
            // iOS 17, so pinning the response/damping keeps the arrow's entrance identical
            // across deployment targets.
            withAnimation(.spring(response: 0.55, dampingFraction: 0.825)) {
                arrowYOffset = 0
            }
            
            withAnimation(.easeInOut(duration: 0.4)) {
                arrowEnd = 1
            }
        }
    }
    
    // MARK: - Functions
    
    /// Plays the tap "launch" choreography, then kicks off the actual download after a short delay.
    ///
    /// The arrow first nudges up, pinches its head into a droplet, stretches its shaft downward,
    /// and drops through the ring — after which `animate()` takes over the progress sweep.
    private func initiateDownload() {
        // Only start from a fully reset state, so a second tap can't spawn another
        // progress timer and push the percentage past 100.
        guard downloadState == .notInitiated else { return }
        
        // Small anticipatory hop upward.
        // `.easeInOut(duration: 0.35)` is what `.default` meant pre-iOS 17; pinning it
        // keeps the morph from picking up iOS 17's springier `.default` and drifting
        // from the original's feel.
        withAnimation(.easeInOut(duration: 0.35)) {
            arrowYOffset = -20
        }
        
        // Pinch the arrowhead inward so it starts to look like a drop.
        withAnimation(.easeInOut(duration: 0.3)) {
            animatableX = arrowHeight / 3
        }
        
        // Stretch the shaft down and send the whole arrow falling through the ring.
        withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
            lineDifference = arrowHeight
            arrowYOffset = arrowHeight
        }
        
        // Finish narrowing the head as it falls.
        withAnimation(.easeInOut(duration: 0.35).delay(0.45)) {
            animatableX = arrowHeight / 3 + 10
        }
        
        // Once the drop has cleared the ring, begin the download animation.
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
            animate()
        }
    }
    
    /// Runs the download simulation: sweeps the progress ring, counts the percentage up to 100,
    /// and keeps the liquid surface rippling until completion.
    private func animate() {
        // Raise the water level and sweep both half-rings to their midpoint over the full
        // duration -> one complete ring. Driving the fill here (rather than with a
        // value-scoped `.animation` on the wave) keeps `reset()` free to snap it back instantly.
        withAnimation(.linear(duration: animationDuration)) {
            downloadState = .downloading
            circleTrim = 0.5
        }
        
        // Count 0 -> 100, paced so the label finishes in step with the ring sweep.
        let percentageTimer = Timer.scheduledTimer(withTimeInterval: animationDuration / 100, repeats: true) { timer in
            downloadPercentage += 1
            if downloadPercentage >= 100 {
                downloadState = .downloaded
                timer.invalidate()
            }
        }
        downloadTimers.append(percentageTimer)
        
        // Advance the wave phase while downloading so the liquid keeps moving.
        let waveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if downloadState == .downloading {
                withAnimation(.easeInOut(duration: 0.35)) {
                    time += 0.05
                }
            } else {
                timer.invalidate()
            }
        }
        downloadTimers.append(waveTimer)
    }
    
    /// Returns the indicator to its resting, ready-to-download state and cancels any
    /// in-flight timers so a partially finished download stops cleanly.
    private func reset() {
        downloadTimers.forEach { $0.invalidate() }
        downloadTimers.removeAll()

        // Snap the water level and state back with no animation so the fill drains instantly.
        downloadState = .notInitiated
        downloadPercentage = 0
        fillOffset = -150
        time = 0.5

        // Ease the ring and arrow back to their resting positions.
        withAnimation(.easeInOut(duration: 0.35)) {
            circleTrim = 0
            animatableX = 0
            lineDifference = 0
            arrowYOffset = 0
            arrowEnd = 1
        }
    }
}

#Preview {
    NavigationStack {
        CircularDownloadView()
            .colorScheme(.dark)
    }
}
