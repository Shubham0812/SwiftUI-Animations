//
//  LoaderIIView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct LoaderIIView: View {
        
    // MARK:- views
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1)
                MovingCircleView(state: .left, moveOffset: 15, animationDuration: 1.1)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.05)
                MovingCircleView(state: .left, moveOffset: 15, animationDuration: 1.15)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1.1)
                MovingCircleView(state: .left, moveOffset: 15, animationDuration: 1.05)
                MovingCircleView(state: .right, moveOffset: 15, animationDuration: 1)
            }
        }
    }
}

struct LoaderIIView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            LoaderIIView()
        }
    }
}
