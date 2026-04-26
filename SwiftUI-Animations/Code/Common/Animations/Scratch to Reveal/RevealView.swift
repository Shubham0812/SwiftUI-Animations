//
//  RevealView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 25/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// RevealView is a "scratch to reveal" effect: a hidden image sits behind a
// solid cover, and dragging across the screen exposes the image only along
// the drag path. Each drag sample is stored as a `FadePoint`; the points are
// drawn into a `Canvas` mask using radial gradients so the reveal feels soft.
//
// A repeating timer trims old points so the reveal fades back over time —
// toggle the circle button in the corner to pause/resume that auto-fade. The
// reset button (active only when auto-fade is paused) clears all points with
// a quick staggered animation.
//
// To customise: swap the `LinearGradient` cover for any view, change the
// `Image("landing1")` to your own asset, and tune `radius` / `fadeDuration`
// to control the brush size and how long a stroke remains visible.

// Model storing a single drag sample: where the user touched and when.
// `timestamp` lets the fading timer remove points older than `fadeDuration`.
struct FadePoint: Identifiable {
    let id = UUID()
    var location: CGPoint
    var timestamp: Date
}

struct RevealView: View {
    
    // MARK: - Variables
    @State private var fadePoints: [FadePoint] = [] // To store the Fade points
    
    @State var resetDrawing = false
    @State var fadingTimerActive = true
    
    @State var fadingTimer: Timer? // variable to hold the timer
    
    
    let fadeDuration: TimeInterval = 0.25 // the duration of the fade
    let radius: CGFloat = 35 // the radius of the Path drawn to reveal
    
    
    // MARK: - Views
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // The Cover for the hidden image
                // Can be another image, color, background etc.
                LinearGradient(colors: [Color.black, .black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                // The hidden image
                Image("landing1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .mask( // We use mask property to show the Image only in the drawn path
                        Canvas { context, size in // for drawing shapes on the path we'll use Canvas
                            for (ix, point) in fadePoints.enumerated() { // iterate through the fade points
                                
                                // gradient for the fill
                                let gradient = Gradient(stops: [.init(color: .white, location: 0), .init(color: .white.opacity(0), location: 1)])
                                
                                context.fill(
                                    // create an Ellipse(Circle) on the specified path
                                    Path(ellipseIn: CGRect(
                                        x: point.location.x - radius,
                                        y: point.location.y - radius,
                                        width: radius * 2,
                                        height: radius  * 2
                                    )),
                                    with: .radialGradient( // fill it with a radial gradient
                                        gradient,
                                        center: point.location,
                                        startRadius: 0,
                                        endRadius: radius + CGFloat(ix + 1)
                                                         ))
                            }
                        }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // add the location in the fade points array by creating a FadePoint
                                fadePoints.append(FadePoint(location: value.location, timestamp: Date()))
                            }
                    )
                // Now we'll add the two buttons
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                                Button {
                                    withAnimation(.snappy) {
                                        // toggle the reset drawing variable to animate the symbol
                                        resetDrawing.toggle()
                                    }
                                    
                                    removeFadePoints() // remove the fade points
                                } label: {
                                    if #available(iOS 18.0, *) {
                                        Image(systemName: "arrow.trianglehead.clockwise")
                                    } else {
                                        Image(systemName: "arrow.trianglehead.clockwise")
                                    }
                                }
                                .buttonStyle(.plain)
                                .frame(width: 32, height: 32)
                                
                                // Change the opacity and set the reset button to disabled
                                // When fading timer is active
                                // The Fade Points will disappear anyway
                                .opacity(!fadingTimerActive ? 1 : 0.3)
                                .disabled(fadingTimerActive)
                                
                                
                                // Button to Start / Stop the Fading Timer
                                Button {
                                    withAnimation(.smooth) {
                                        // toggle the fading Timer variable to animate the symbol & start / stop the disappearing timer
                                        fadingTimerActive.toggle()
                                        
                                        setFadingTimer()
                                    }
                                } label: {
                                    Image(systemName: fadingTimerActive ? "circle.slash" : "circle")
                                        .font(.system(size: 20, weight: .semibold))
                                        .symbolEffect(.bounce, value: fadingTimerActive)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 32, height: 32)
                        }
                    }
            }
            .onAppear {
                // We'll start the Fading Timer to remove the old Paths
                startFadingTimer()
            }
        }
        .ignoresSafeArea()
    }
    
    /// Updates the points every 0.1s to remove those fully faded out
    func startFadingTimer() {
        fadingTimer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            let now = Date()
            fadePoints.removeAll { point in
                now.timeIntervalSince(point.timestamp) > fadeDuration
            }
        }
    }
    
    /// Starts or stops the Fading timer
    func setFadingTimer() {
        if fadingTimerActive {
            if fadingTimer == nil {
                startFadingTimer()
            }
        } else {
            fadingTimer?.invalidate()
            fadingTimer = nil
        }
    }
    
    /// Removes the Fade points
    func removeFadePoints() {
        // Iterate through the Points, and remove them one by one
        for (index, point) in fadePoints.reversed().enumerated() {
            
            // delay between each removal
            let delay: TimeInterval = Double(index) * 0.001
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.default) {
                    // remove a point
                    fadePoints.removeAll { $0.id == point.id }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RevealView()
    }
}
