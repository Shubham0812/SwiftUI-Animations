//
//  SwiftUIView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// An empty placeholder view created as a stub during `LoginView` development.
///
/// Contains only a black background with no additional content. Kept as a reference
/// template for future views in the LoginView group.
struct SwiftUIView: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
