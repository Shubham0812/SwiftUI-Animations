//
//  TriangleLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 13/09/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//


import SwiftUI

/// Represents the four animation phases of the triangle loader.
/// Each phase defines where the stroke is drawn and where the circle sits.
enum TriangleState {
    case begin
    case phaseOne
    case phaseTwo
    case stop
    
    /// Returns the (strokeStart, strokeEnd) trim values for each phase,
    /// controlling which portion of the triangle outline is visible.
    func getStrokes() -> (CGFloat, CGFloat) {
        switch self {
        case .begin:
            return (0.335, 0.665)
        case .phaseOne:
            return (0.5, 0.825)
        case .phaseTwo:
            return (0.675, 1)
        case .stop:
            return (0.175, 0.5)
        }
    }
    
    /// Returns the (x, y) offset for the circle indicator at each phase,
    /// positioning it at the corresponding corner/apex of the triangle.
    func getCircleOffset() -> (CGFloat, CGFloat) {
        switch self {
        /// you'll have to change the offset values here if you want to increase/decrease the size of the circle
        case .begin:
            return (0, 35)       // Bottom-center (base midpoint)
        case .phaseOne:
            return (30, -5)      // Bottom-right corner
        case .phaseTwo:
            return (-30, -5)     // Bottom-left corner
        case .stop:
            return (-30, 0)      // Transitional reset position before looping
        }
    }
}

/// An animated triangle loader where a stroke segment and circle indicator
/// travel around the triangle's edges through four sequential phases.
///
/// Tap to start. A partial stroke slides along the triangle outline while a
/// small circle bounces between vertices using spring physics. The animation
/// loops indefinitely via a repeating `Timer`.
struct TriangleLoader: View {

    // MARK: - Variables

    /// Controls which segment of the triangle stroke is currently visible.
    @State var strokeStart: CGFloat = 0
    /// End point of the visible stroke segment, paired with `strokeStart`.
    @State var strokeEnd: CGFloat = 0

    /// Controls the position of the circle indicator relative to the triangle center.
    @State var circleOffset: CGSize = CGSize(width: 0, height: 0)

    /// Duration (in seconds) of each individual animation step.
    let animationDuration: TimeInterval = 0.7

    /// Color of the circle indicator — can be customised at the call site.
    var circleColor: Color = Color.blue
    
    // MARK: - Views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ZStack {
                // Trimmed triangle outline — only the segment between strokeStart and strokeEnd is drawn
                TriangleShape()
                    .trim(from: strokeStart, to: strokeEnd)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 8))
                
                // Circle indicator that moves around the triangle's vertices
                Circle()
                    .offset(circleOffset)
                    .foregroundStyle(circleColor)
                    .frame(width: 15, height: 15)
            }
            .frame(width: 100, height: 100)
            .offset(y: -75)
        }.onAppear {
            // Set initial state before animation begins
            setStroke(state: .begin)
            setCircleOffset(state: .begin)
            
            // Kick off the first animation cycle immediately
            animate()
            
            // Repeat the full animation loop every 4.5 steps
            // (must match the total duration of one animate() cycle)
            Timer.scheduledTimer(withTimeInterval: animationDuration * 4.5, repeats: true) { _ in
                animate()
            }
        }
    }
    
    // MARK: - Functions
    
    /// Orchestrates one full loop of the animation across three phases,
    /// using staggered timers to sequence stroke and circle transitions.
    func animate() {
        // Phase 1: Stroke and circle move to the right corner
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseOne)
            }
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseOne)
            }
        }
        
        // Phase 2: Stroke and circle move to the left corner
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2 , repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseTwo)
            }
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseTwo)
            }
        }
        
        // Stop & reset: snap stroke to the .stop position (no animation),
        // then animate back to .begin, ready for the next loop iteration.
        Timer.scheduledTimer(withTimeInterval: animationDuration * 3.5, repeats: false) { _ in
            setStroke(state: .stop) // Instant reposition to avoid a reverse-travel artifact
            
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .begin)
            }
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .begin)
            }
        }
    }
    
    /// Applies the stroke trim values for the given state to the `@State` properties.
    func setStroke(state: TriangleState) {
        (strokeStart, strokeEnd) = state.getStrokes()
    }
    
    /// Converts the tuple offset from `TriangleState` into a `CGSize` and applies it.
    func setCircleOffset(state: TriangleState) {
        let offset = state.getCircleOffset()
        circleOffset = CGSize(width: offset.0, height: offset.1)
    }
}

#Preview {
    TriangleLoader()
}
