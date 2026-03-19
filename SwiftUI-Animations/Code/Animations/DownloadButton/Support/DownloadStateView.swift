//
//  DownloadStateView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 09/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A single visual panel representing one `DownloadState` inside `DownloadButton`.
///
/// Three instances are stacked and shown/hidden by animating their Y offsets (slot-machine effect).
/// Each panel renders only its own state's background and label; `DownloadButton` owns transitions.
/// The optional progress capsule at the bottom edge is only shown when `needsProgress = true`.
struct DownloadStateView: View {

    // MARK: - Variables

    /// The `DownloadState` this panel represents — drives background color and label text.
    var state: DownloadState = .downloaded
    /// When `true`, renders a progress capsule along the bottom edge (`.downloading` panel only).
    var needsProgress: Bool = true
    /// When `true`, renders the label in white; when `false`, uses `Color.background`.
    var isLight: Bool = false

    /// Shared download state — used to hide this panel's label when it is not the active state.
    @Environment(Downloader.self) var downloader
    /// Download progress 0→1 from `DownloadButton`.
    @Binding var progress: CGFloat

    // MARK: - Views

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(state.getBackground())
            Text(state.getStateName())
                .foregroundStyle(isLight ? .white : Color.background)
                .font(.system(size: 26, weight: .bold))
                .shadow(color: Color.white.opacity(0.3), radius: 5, y: 2)
                .opacity(downloader.currentState != state ? 0 : 1)
                .offset(x: downloader.currentState.offsetForText() + 26)
                .animation(.easeOut(duration: ButtonDimension.animationDuration / 2.25), value: downloader.currentState)
                .frame(alignment: .leading)

            if needsProgress {
                Capsule(style: .circular)
                    .trim(from: 0, to: progress / 2)
                    .stroke(lineWidth: 8)
                    .rotationEffect(.degrees(180))
                    .foregroundStyle(Color(hex: "25D366"))
                    .frame(width: ButtonDimension.width, height: 12)
                    .offset(y: ButtonDimension.height / 2 + 4.5)
                    .mask(
                        RoundedRectangle(cornerRadius: ButtonDimension.cornerRadius)
                            .frame(width: 320, height: 84)
                    )
                    .opacity(downloader.currentState != state ? 0 : 1)
                    .animation(.default, value: downloader.currentState)
            }
        }
        .frame(width: ButtonDimension.width, height: ButtonDimension.height)
    }
}

#Preview {
    DownloadStateView(progress: .constant(0))
        .environment(Downloader())
}
