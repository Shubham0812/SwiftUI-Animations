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
            return (90, 300, UnitPoint.leading, 1)
        case .finalLeading:
            return (0, 0, UnitPoint.leading, 1)
        case .initialTrailing:
            return (0, 0,UnitPoint.trailing, -1)
        case .finalTrailing:
            return (90, -300,UnitPoint.trailing, -1)
        }
    }
}

struct RotatingLoader: View {
    
    // MARK:- variables
    @State var orangeDegree: Double = RotationState.initialTrailing.rotationValues.0
    @State var orangeOffset: CGFloat = RotationState.initialTrailing.rotationValues.1
    @State var orangeAnchor: UnitPoint = RotationState.initialTrailing.rotationValues.2
    @State var orangeYAxis: CGFloat = RotationState.initialTrailing.rotationValues.3
    
    @State var greenDegree:Double = RotationState.initialLeading.rotationValues.0
    @State var greenOffset:CGFloat = RotationState.initialLeading.rotationValues.1
    @State var greenAnchor: UnitPoint = RotationState.initialLeading.rotationValues.2
    @State var greenYAxis: CGFloat = RotationState.initialLeading.rotationValues.3
    
    
    @State var timerDuration: TimeInterval = 6
    @State var animationDuration: TimeInterval = 2.5
    @State var animateTrail: Bool = false
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 300)
                }.rotation3DEffect(.degrees(greenDegree), axis: (x: 0, y: greenYAxis, z: 0), anchor: greenAnchor, anchorZ: 0, perspective: 0.1)
                .offset(CGSize(width: greenOffset, height: 0))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.materialBlack)
                        .frame(width: 300, height: 300)
                }.rotation3DEffect(.degrees(orangeDegree), axis: (x: 0, y: orangeYAxis, z: 0), anchor: orangeAnchor, anchorZ: 0, perspective: 0.1)
                .offset(x: orangeOffset, y: 0)
            }
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: false) { _ in
                withAnimation(Animation.easeOut(duration: animationDuration)) {
                    self.setValuesOnState(rotation1: .finalTrailing, rotation2: .finalLeading)
                    imitateCube()
                }
            }
        }
    }
    
    // MARK:- functions
    func setValuesOnState(rotation1: RotationState, rotation2: RotationState) {
        self.orangeDegree = rotation1.rotationValues.0
        self.orangeOffset = rotation1.rotationValues.1
        self.orangeAnchor = rotation1.rotationValues.2
        self.orangeYAxis = rotation1.rotationValues.3
        
        self.greenDegree = rotation2.rotationValues.0
        self.greenOffset = rotation2.rotationValues.1
        self.greenAnchor = rotation2.rotationValues.2
        self.greenYAxis = rotation2.rotationValues.3
    }
    
    func imitateCube() {
        Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: true) { _ in
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
        RotatingLoader()
    }
}
