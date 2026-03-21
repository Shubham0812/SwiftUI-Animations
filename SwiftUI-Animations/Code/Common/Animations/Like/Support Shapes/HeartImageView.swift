//
//  HeartImageView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 26/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A large filled heart SF Symbol (160 pt) used as the central icon in `LikeView`.
///
/// Extracted into its own view so it can be used twice in `LikeView` — once as the
/// white base icon and once as a color-masked overlay that sweeps across on like.
struct HeartImageView: View {
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 160, weight: .medium, design: .monospaced))
    }
}

#Preview {
    HeartImageView()
}
