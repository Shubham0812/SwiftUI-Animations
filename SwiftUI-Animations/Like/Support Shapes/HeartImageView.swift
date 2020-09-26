//
//  HeartImageView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct HeartImageView: View {
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 160, weight: .medium, design: .monospaced))
    }
}

struct HeartImageView_Previews: PreviewProvider {
    static var previews: some View {
        HeartImageView()
    }
}
