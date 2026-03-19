//
//  Loader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single animated capsule that moves in a specific direction as part of the square Loader animation.
///
/// Each `Loader` instance represents one capsule that stretches and slides along one edge of an
/// invisible square. Multiple `Loader` instances (one per direction) are combined to create the
/// full square loader effect. The capsule animates in two phases per cycle: first it stretches
/// in the movement direction (`increment_before`), then it contracts and slides to the final
/// position (`increment_after`), creating a fluid bouncing motion. The animation cycles through
/// all `LoaderState` cases (directions) continuously.
struct Loader: View {

    // MARK: - Variables
    /// The current width of the animated capsule, changes during stretch/contract phases.
    @State var capsuleWidth: CGFloat = 40
    /// The current height of the animated capsule, changes during stretch/contract phases.
    @State var capsuleHeight: CGFloat = 40
    /// Horizontal offset from center, animated to slide the capsule along the x-axis.
    @State var xOffset: CGFloat = 0
    /// Vertical offset from center, animated to slide the capsule along the y-axis.
    @State var yOffset: CGFloat = 0
    /// The current movement direction/state of this capsule in the animation cycle.
    @State var loaderState: LoaderState
    /// Tracks which `LoaderState` case is active, used to cycle through all directions.
    @State var currentIndex = 0
    /// Flag indicating whether the animation has been initialized.
    @State var animationStarted: Bool = true

    /// Delay before the first animation cycle begins, used to stagger multiple loader capsules.
    var timerDuration: TimeInterval
    /// External binding that controls whether the animation is running; setting to `false` stops the loop.
    @Binding var startAnimating: Bool

    // MARK: - Views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            Capsule()
                .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .foregroundStyle(.white)
                .frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                .animation(.easeOut(duration: 0.35), value: capsuleWidth)
                .offset(x: xOffset, y: yOffset)

        }).frame(width: 40, height: 0, alignment: loaderState.alignment)
        .onAppear {
            setIndex()
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { initialTimer in
                if startAnimating {
                    Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: false) { _ in
                        animateCapsule()
                        Timer.scheduledTimer(withTimeInterval: 2.1, repeats: true) { loaderTimer in
                            if !startAnimating {
                                loaderTimer.invalidate()
                            }
                            loaderState = getNextCase()
                            animateCapsule()
                        }
                    }
                    initialTimer.invalidate()
                }
            }
        }
    }

    // MARK: - Functions

    // provides the next case defined in the enum based on the currentIndex
    func getNextCase() -> LoaderState {
        let allCases = LoaderState.allCases
        if currentIndex == allCases.count - 1 {
            currentIndex = -1
        }
        currentIndex += 1
        return allCases[currentIndex]
    }

    // sets the initialIndex & offset values based on the loader state provided to the view
    func setIndex() {
        for (ix, loaderCase) in LoaderState.allCases.enumerated() {
            if loaderCase == loaderState {
                currentIndex = ix
                xOffset = LoaderState.allCases[currentIndex].increment_before.0
                yOffset = LoaderState.allCases[currentIndex].increment_before.1
            }
        }
    }

    // animates the capsule to a direction
    func animateCapsule() {
        xOffset = loaderState.increment_before.0
        yOffset = loaderState.increment_before.1
        capsuleWidth = loaderState.increment_before.2
        capsuleHeight = loaderState.increment_before.3

        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { _ in
            xOffset = loaderState.increment_after.0
            yOffset = loaderState.increment_after.1
            capsuleWidth = loaderState.increment_after.2
            capsuleHeight = loaderState.increment_after.3
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        Loader(loaderState: .down, timerDuration: 0.35, startAnimating: .constant(true))
    }
}
