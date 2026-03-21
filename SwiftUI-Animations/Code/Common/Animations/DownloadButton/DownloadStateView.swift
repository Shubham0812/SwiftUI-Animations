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
/// Three instances of this view are stacked in `DownloadButton` — one per state —
/// and shown/hidden by animating their Y offsets (the slot-machine effect).
/// Each panel is responsible only for rendering its own state's appearance;
/// `DownloadButton` owns all the transition logic.
///
/// The optional progress bar at the bottom edge is only shown when
/// `needsProgress = true` (i.e. the `.downloading` panel).
struct DownloadStateView: View {

    // MARK: - Variables

    /// The `DownloadState` this panel represents.
    var state: DownloadState = .downloaded

    /// When `true`, renders a progress capsule along the bottom edge of the panel.
    var needsProgress: Bool = true

    /// When `true`, renders the label in white (for use on dark/colored backgrounds).
    var isLight: Bool = false

    /// Shared download state owner — used to check whether this panel is currently
    /// the active state, which controls label visibility and text offset.
    @Environment(Downloader.self) var downloader

    /// Download progress value from 0.0 to 1.0, bound from `DownloadButton`.
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
