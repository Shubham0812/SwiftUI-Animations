//
//  3dLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

enum RotationState: CaseIterable {
    case initialLeading
    case finalLeading
    case initialTrailing
    case finalTrailing
    
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

struct RotatingLoaderView: View {
    
    // MARK:- variables
    @State var firstViewDegree: Double = RotationState.initialTrailing.rotationValues.0
    @State var firstViewOffset: CGFloat = RotationState.initialTrailing.rotationValues.1
    @State var firstViewAnchor: UnitPoint = RotationState.initialTrailing.rotationValues.2
    @State var firstViewYAxis: CGFloat = RotationState.initialTrailing.rotationValues.3
    
    @State var secondViewDegree:Double = RotationState.initialLeading.rotationValues.0
    @State var secondViewOffset:CGFloat = RotationState.initialLeading.rotationValues.1
    @State var secondViewAnchor: UnitPoint = RotationState.initialLeading.rotationValues.2
    @State var secondViewYAxis: CGFloat = RotationState.initialLeading.rotationValues.3
    
    
    @State var timerDuration: TimeInterval = 3.5
    @State var animationDuration: TimeInterval = 1.5
    @State var animateTrail: Bool = false
    @State var showFlickeringViews: Bool = false
    
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
                if (showFlickeringViews) {
                    FlickeringView(backgroundColor: Color.white, initialOffset: CGSize(width: 200, height: -300), initialSize: CGSize(width: 200, height: 44), finalSize: CGSize(width: 100, height: 44), finalOffset: CGSize(width: -120, height: -300), fadeDuration: 0.6)
                    
                    FlickeringView(backgroundColor: Color.black, initialOffset: CGSize(width: 200, height: -100), initialSize: CGSize(width: 300, height: 32), finalSize: CGSize(width: 44, height: 32), finalOffset: CGSize(width: -80, height: -100), fadeDuration: 0.5)
                    
                    FlickeringView(backgroundColor: Color.white, initialOffset: CGSize(width: 200, height: 250), initialSize: CGSize(width: 40, height: 40), finalSize: CGSize(width: 40, height: 40), finalOffset: CGSize(width: -80, height: 250), fadeDuration: 0.75)
                }
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
    
    func stepCounter() {
        if (counter == 3) {
            counter = -1
        }
        counter += 1
    }
    
    func rotateCube() {
        Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: true) { _ in
            stepCounter()
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
