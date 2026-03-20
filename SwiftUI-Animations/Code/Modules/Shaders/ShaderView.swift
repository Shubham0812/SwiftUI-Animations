//
//  ShaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK:- ShaderDestination
/// Placeholder destination enum for the Shaders tab.
/// Add cases here as shader demos are added to the project.
enum ShaderDestination: Hashable {
    // future: case metalBlur, case distortion, case colorShift, etc.
}

// MARK:- ShaderView
struct ShaderView: View {

    // MARK:- views
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 56, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.submitColor, Color.circleRoundStart],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                VStack(spacing: 8) {
                    Text("Shaders")
                        .font(ClashGrotestk.bold.font(size: 32))

                    Text("Coming Soon")
                        .font(ClashGrotestk.medium.font(size: 17))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: ShaderDestination.self) { _ in EmptyView() }
    }
}

#Preview {
    NavigationStack {
        ShaderView()
    }
}
