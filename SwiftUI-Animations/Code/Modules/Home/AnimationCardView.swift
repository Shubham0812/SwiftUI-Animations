//
//  AnimationCardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct AnimationCardView: View {

    // MARK: - Variables
    let item: AnimationItem

    // MARK: - Views
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: item.systemIcon)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(Color.label)
                .frame(width: 60, height: 60)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.iconColor.gradient)
                        .opacity(0.2)
                )

            Text(item.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.label)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AnimationCardView(item: AnimationItem.all[0])
        .padding()
}
