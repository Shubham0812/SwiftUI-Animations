//
//  ShaderCardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct ShaderCardView: View {

    // MARK: - variables
    let item: ShaderItem

    // MARK: - views
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: item.systemIcon)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(Color.label)
                .frame(width: 60, height: 60)
                .padding(6)
                .background {
                    Circle()
                        .fill(item.iconColor.gradient)
                        .opacity(0.2)
                }

            Text(item.title)
                .font(ClashGrotestk.semibold.font(size: 14))
                .tracking(0.1)
                .foregroundStyle(Color.label)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ShaderCardView(item: ShaderItem.all[0])
        .padding()
}
