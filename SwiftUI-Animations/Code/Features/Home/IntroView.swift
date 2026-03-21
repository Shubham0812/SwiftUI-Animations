//
//  IntroView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 13/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A placeholder home/navigation view for the app.
///
/// This view is intended to serve as the landing screen or navigation hub
/// for browsing the available animation demos. Currently displays default
/// placeholder text.
struct IntroView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/// Xcode preview provider for ``IntroView``.
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
