//
//  DownloadStateView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 09/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

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
    
    // MARK: - variables
    
    /// The `DownloadState` this panel represents.
    /// Drives the background color (via `state.getBackground()`) and
    /// label text (via `state.getStateName()`).
    var state: DownloadState = .downloaded
    
    /// When `true`, renders a progress capsule along the bottom edge of the panel.
    /// Only the `.downloading` panel needs this — the others pass `false`.
    var needsProgress: Bool = true
    
    /// When `true`, renders the label in white (for use on dark/colored backgrounds).
    /// When `false`, uses `Color.background` (for the idle panel's light background).
    var isLight: Bool = false
    
    /// Shared download state owner — used to check whether this panel is currently
    /// the active state, which controls label visibility and text offset.
    @EnvironmentObject var downloader: Downloader
    
    /// Download progress value from 0.0 to 1.0, bound from `DownloadButton`.
    /// Divided by 2 when passed to `.trim()` because the capsule is full-width
    /// and only the left half should fill (see progress bar notes below).
    @Binding var progress: CGFloat
    
    
    // MARK: - views
    var body: some View {
        ZStack {
            
            // ── Background ────────────────────────────────────────────────────
            // Solid fill using the color defined for this state in `DownloadState.getBackground()`.
            // cornerRadius: 0 because the parent `DownloadButton` applies its own
            // RoundedRectangle mask — no need to clip here.
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(state.getBackground())
            
            // ── State label ───────────────────────────────────────────────────
            // Shows the label for this panel's state (e.g. "Download", "Downloading", "Finished").
            // Fades out when this panel is not the active state, preventing labels from
            // bleeding through during the slide transition in `DownloadButton`.
            // The X offset shifts the text rightward to leave room for the supporting
            // icon on the left (the arrow or tick rendered by `getSupportingView()`).
            Text(state.getStateName())
                .foregroundColor(isLight ? .white : .background)
                .font(.system(size: 26, weight: .bold))
                .shadow(color: Color.white.opacity(0.3), radius: 5, y: 2)
                // Visible only when this panel's state matches the current download state
                .opacity(downloader.currentState != state ? 0 : 1)
                // `offsetForText()` adds extra horizontal nudge for the `.downloading` state
                // (shifts text right to accommodate the animated arrow beside it),
                // plus a fixed +26pt base offset to clear the icon on all states.
                .offset(x: downloader.currentState.offsetForText() + 26)
                .animation(Animation.easeOut(duration: ButtonDimension.animationDuration / 2.25))
                .frame(alignment: .leading)
            
            // ── Progress bar (downloading panel only) ─────────────────────────
            if needsProgress {
                // A half-filled capsule that grows from left to right as `progress` increases.
                //
                // Design notes:
                // • `.trim(from: 0, to: progress / 2)`: the capsule spans the full button width,
                //   but only the left half should fill. Dividing progress by 2 maps the
                //   0→1 progress range to the 0→0.5 trim range, so the fill reaches the
                //   center of the capsule at 100% — which visually spans the full button width.
                // • `.rotationEffect(.degrees(180))`: SwiftUI's trim starts from the 3 o'clock
                //   position by default. Rotating 180° makes the fill grow left-to-right
                //   from the leading edge instead.
                // • Positioned just below the button's bottom edge (`height/2 + 4.5`) and
                //   re-masked to the button's rounded rect so it appears as a flush bottom bar.
                Capsule(style: .circular)
                    .trim(from: 0, to: progress / 2)
                    .stroke(lineWidth: 8)
                    .rotationEffect(.degrees(180))          // Makes fill grow left→right
                    .foregroundColor(Color(hex: "25D366"))  // WhatsApp-style green progress tint
                    .frame(width: ButtonDimension.width, height: 12)
                    .offset(y: ButtonDimension.height / 2 + 4.5) // Push to the bottom edge
                    .mask(
                        // Re-apply the button's rounded rect mask so the progress bar
                        // is clipped to the same corner radius as the button itself.
                        RoundedRectangle(cornerRadius: ButtonDimension.cornerRadius)
                            .frame(width: 320, height: 84)
                    )
                    // Hide when this panel isn't active — prevents the bar
                    // from flickering in during transitions to other states.
                    .opacity(downloader.currentState != state ? 0 : 1)
                    .animation(.default)
            }
        }
        .frame(width: ButtonDimension.width, height: ButtonDimension.height)
    }
}

#Preview {
    DownloadStateView(progress: .constant(0))
        .environmentObject(Downloader())
}
