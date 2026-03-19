//
//  LoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI


/// A directional capsule loader composed of three `Loader` instances that
/// travel around a square path (down → right → up → left) with staggered start times.
///
/// Each `Loader` begins at a different phase offset (`timerDuration`), so the three
/// capsules chase each other around the corners, creating a perpetual-motion effect.
struct LoaderView: View {

    // MARK: - Variables

    /// Triggers all three child `Loader` animations simultaneously on appear.
    @State var animateLoaders: Bool = false

    // MARK: - Views
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ZStack {
                // Three capsules offset by ~0.7s each so they're evenly spaced around the path
                Loader(loaderState: .down, timerDuration: 0.35, startAnimating: $animateLoaders)
                Loader(loaderState: .right, timerDuration: 1.05, startAnimating: $animateLoaders)
                Loader(loaderState: .up, timerDuration: 1.75, startAnimating: $animateLoaders)
            }.offset(x: -40, y: -40)
        }.onAppear {
            animateLoaders.toggle()
        }
    }
}

#Preview {
    LoaderView()
}
