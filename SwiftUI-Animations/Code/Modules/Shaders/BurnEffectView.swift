//
//  BurnEffectView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - BurnEffectView
struct BurnEffectView: View {

    // MARK: - variables
    @State private var progress: Double = 1.0
    @State private var hasBurned: Bool  = false

    // MARK: - views
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .burnEffect(progress: progress)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 4)
                        .foregroundStyle(Color.label)
                }
                .rotationEffect(.degrees(180))
                .frame(width: 340, height: 500)
            }
            .onTapGesture {
                HapticManager().makeImpactFeedback(mode: .medium)
                if hasBurned {
                    progress   = 1.0
                    hasBurned  = false
                } else {
                    withAnimation(.snappy(duration: 7)) {
                        progress = 0.0
                    }
                    hasBurned = true
                }
            }
        }
        .overlay(alignment: .top) {
            Text(hasBurned ? "Tap to restore" : "Tap to ignite the burn")
                .font(ClashGrotestk.medium.font(size: 17))
                .foregroundStyle(Color.label)
                .padding(.top, 24)
                .animation(.smooth, value: hasBurned)
        }
        .navigationTitle("Burn Effect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BurnEffectView()
    }
}
