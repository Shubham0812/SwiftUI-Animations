//
//  3dLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The four states of a 3D cube face flip in `RotatingLoaderView`.
///
/// Each state provides a `(degree, offset, anchor, yAxis)` tuple used as arguments to
/// `rotation3DEffect`. The `offset` physically moves the face so the rotation pivot
/// appears to be at the cube's edge (perspective hinge) rather than its center.
enum RotationState: CaseIterable {
    case initialLeading
    case finalLeading
    case initialTrailing
    case finalTrailing

    /// Returns `(rotationDegrees, xOffset, anchorPoint, yAxisDirection)`.
    /// - `rotationDegrees`: 0 = face-on, 90 = folded flat/hidden.
    /// - `xOffset`: horizontal translation so the face swings from the correct edge.
    /// - `anchorPoint`: `.leading` or `.trailing` — the hinge edge.
    /// - `yAxisDirection`: 1 (leading hinge rotates inward) or –1 (trailing hinge).
    // Degree, Offset, Anchor, Axis
    var rotationValues: (Double, CGFloat, UnitPoint, CGFloat) {
        switch self {
        case .initialLeading:
            return (90, 260, UnitPoint.leading, 1)
        case .finalLeading:
            return (0, 0, UnitPoint.leading, 1)
        case .initialTrailing:
            return (0, 0,UnitPoint.trailing, -1)
        case .finalTrailing:
            return (90, -260 ,UnitPoint.trailing, -1)
        }
    }
}

/// A two-faced 3D cube loader that alternates between a white face (`DashedLoaderView`)
/// and a dark face (`RectangleLoaderView` or `DotsLoaderView`) using `rotation3DEffect`.
///
/// Each "flip" animates both faces simultaneously — one swings in from the leading edge
/// while the other swings out from the trailing edge — creating the illusion of a rotating cube.
/// After the first two flips, the dark face switches from `RectangleLoaderView` to `DotsLoaderView`.
struct RotatingLoaderView: View {

    // MARK:- variables

    // ── First face (dark, initially trailing/visible) ─────────────────────────
    /// 3D rotation degree for the dark face (0 = visible, 90 = hidden/folded).
    @State var firstViewDegree: Double = RotationState.initialTrailing.rotationValues.0
    /// Horizontal offset for the dark face, moves it to the correct hinge edge.
    @State var firstViewOffset: CGFloat = RotationState.initialTrailing.rotationValues.1
    /// Anchor point (hinge) for the dark face's `rotation3DEffect`.
    @State var firstViewAnchor: UnitPoint = RotationState.initialTrailing.rotationValues.2
    /// Y-axis direction for the dark face (–1 = trailing hinge, rotates left).
    @State var firstViewYAxis: CGFloat = RotationState.initialTrailing.rotationValues.3

    // ── Second face (white, initially leading/hidden) ──────────────────────────
    /// 3D rotation degree for the white (`DashedLoaderView`) face.
    @State var secondViewDegree:Double = RotationState.initialLeading.rotationValues.0
    /// Horizontal offset for the white face.
    @State var secondViewOffset:CGFloat = RotationState.initialLeading.rotationValues.1
    /// Anchor point for the white face's `rotation3DEffect`.
    @State var secondViewAnchor: UnitPoint = RotationState.initialLeading.rotationValues.2
    /// Y-axis direction for the white face (1 = leading hinge, rotates right).
    @State var secondViewYAxis: CGFloat = RotationState.initialLeading.rotationValues.3

    /// Total duration of one pause (face fully visible) before the next flip begins.
    @State var timerDuration: TimeInterval = 3.5
    /// Duration of the easeOut flip animation (face swings in/out).
    @State var animationDuration: TimeInterval = 1.5
    /// Alternates the leading/trailing direction of each flip.
    @State var animateTrail: Bool = false
    /// Unused in current layout — reserved for flickering overlays between flips.
    @State var showFlickeringViews: Bool = false

    /// Counts completed flips; selects `DotsLoaderView` when `counter >= 2`.
    @State var counter = 0
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: 260, height: 260)
                    DashedLoaderView()
                        .frame(width: 140, height: 140)
                }.rotation3DEffect(.degrees(secondViewDegree), axis: (x: 0, y: secondViewYAxis, z: 0), anchor: secondViewAnchor, anchorZ: 0, perspective: 0.1)
                .offset(CGSize(width: secondViewOffset, height: 0))
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.materialBlack)
                        .frame(width: 260, height: 260)
                    if (counter == 0 || counter == 1) {
                        RectangleLoaderView()
                            .frame(width: 140, height: 140)
                    } else  {
                        DotsLoaderView()
                            .frame(width: 140, height: 140)
                    }
                }.rotation3DEffect(.degrees(firstViewDegree), axis: (x: 0, y: firstViewYAxis, z: 0), anchor: firstViewAnchor, anchorZ: 0, perspective: 0.1)
                .offset(x: firstViewOffset, y: 0)
            }
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Text("@Shubham_iosdev")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                        .opacity(0.3)
                }.padding(.trailing, 16)
            }
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: false) { _ in
                withAnimation(Animation.easeOut(duration: animationDuration)) {
                    self.setValuesOnState(rotation1: .finalTrailing, rotation2: .finalLeading)
                    counter += 1
                    rotateCube()
                    showFlickeringViews.toggle()
                }
            }
        }
    }
    
    // MARK:- functions

    /// Applies the rotation values for two `RotationState` cases to the first and second faces.
    /// Called both without animation (to snap to initial position) and within `withAnimation` blocks.
    func setValuesOnState(rotation1: RotationState, rotation2: RotationState) {
        self.firstViewDegree = rotation1.rotationValues.0
        self.firstViewOffset = rotation1.rotationValues.1
        self.firstViewAnchor = rotation1.rotationValues.2
        self.firstViewYAxis = rotation1.rotationValues.3
        
        self.secondViewDegree = rotation2.rotationValues.0
        self.secondViewOffset = rotation2.rotationValues.1
        self.secondViewAnchor = rotation2.rotationValues.2
        self.secondViewYAxis = rotation2.rotationValues.3
    }

    
    /// Starts a repeating timer that alternates the cube flip direction each `timerDuration`.
    ///
    /// Each tick: snaps both faces to their new initial positions (no animation),
    /// then immediately animates them to the opposite final positions via `easeOut`.
    /// `animateTrail` toggles each time so the cube flips left and right alternately.
    func rotateCube() {
        Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: true) { _ in
            showFlickeringViews.toggle()
            if (animateTrail) {
                self.setValuesOnState(rotation1: .initialTrailing, rotation2: .initialLeading)
            } else {
                self.setValuesOnState(rotation1: .initialLeading, rotation2: .initialTrailing)
            }
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                if (animateTrail) {
                    self.setValuesOnState(rotation1: .finalTrailing, rotation2: .finalLeading)
                } else {
                    self.setValuesOnState(rotation1: .finalLeading, rotation2: .finalTrailing)
                }
            }
            self.animateTrail.toggle()
        }
    }
}

struct _dLoader_Previews: PreviewProvider {
    static var previews: some View {
        RotatingLoaderView()
    }
}
