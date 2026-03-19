//
//  StateView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 08/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

/// The main download button that sequences three visual states — idle, downloading,
/// and downloaded — by sliding `DownloadStateView` panels vertically in a masked stack.
///
/// **Layout trick:** All three state panels are stacked at full button height and
/// positioned off-screen using Y offsets. Transitions are achieved by animating
/// the offsets so panels slide in from the top and out through the bottom,
/// like a vertical slot machine. A `RoundedRectangle` mask clips everything to
/// the button's visible frame so panels outside it are invisible.
///
/// **State flow:**
/// ```
/// notInitiated  ──tap──►  downloading  ──progress=1──►  downloaded  ──2.5s──►  notInitiated
/// ```
struct DownloadButton: View {
    
    // MARK: - Variables

    /// Owns the current `DownloadState` and is passed to each `DownloadStateView`
    /// via the environment so all panels share the same state.
    @State var downloader = Downloader()
    
    // ── Panel Y offsets ───────────────────────────────────────────────────────
    // Each panel starts off-screen and is animated into/out of the visible frame.
    // "On screen" = offset 0. "Above" = negative. "Below" = positive.
    
    /// Y offset for the `.notInitiated` panel.
    /// Starts at 0 (visible), slides down to `+height` when downloading begins.
    @State var downloadYOffset: CGFloat = 0
    
    /// Y offset for the `.downloading` panel.
    /// Starts one full height above (`-height`), slides to 0 when active,
    /// then slides down to `+height` when download completes.
    @State var downloadingYOffset: CGFloat = -ButtonDimension.height
    
    /// Y offset for the `.downloaded` panel.
    /// Starts two full heights above (`-height * 2`) so it's well clear of the
    /// mask during the `.notInitiated` → `.downloading` transition,
    /// then slides to 0 when the download finishes.
    @State var downloadedOffset: CGFloat = -(ButtonDimension.height * 2)
    
    /// Tracks download progress from 0.0 to 1.0.
    /// Drives the progress indicator in the `.downloading` panel and
    /// triggers `itemDownloaded()` when it reaches 1.0.
    @State var downloadProgress: CGFloat = 0
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            
            // ── Panel stack (back to front = top to bottom in slot machine order) ──
            // Rendered back-to-front so the active panel is always on top.
            
            // Downloaded panel — starts furthest off-screen (2× height above)
            DownloadStateView(state: .downloaded, isLight: true, progress: .constant(0))
                .environment(downloader)
                .offset(y: downloadedOffset)
            
            // Downloading panel — starts one height above, slides in when active
            DownloadStateView(state: .downloading, needsProgress: true, isLight: true, progress: $downloadProgress)
                .environment(downloader)
                .offset(y: downloadingYOffset)
            
            // NotInitiated panel — starts visible (offset 0), the default resting state
            DownloadStateView(state: .notInitiated, progress: .constant(0))
                .environment(downloader)
                .offset(y: downloadYOffset)
            
            // ── Supporting icon overlay ───────────────────────────────────────
            // Positioned to the left of center inside the button.
            // Shows a static arrow (idle), animated arrow (downloading),
            // or circle-tick (downloaded) — see `getSupportingView()`.
            ZStack {
                getSupportingView()
                    .scaleEffect(0.9)
            }
            .offset(x: -ButtonDimension.width / 3.5 + 13)
            
        }
        // Clips all three panels to the button's rounded rect so off-screen
        // panels are invisible during transitions — this is what makes the
        // slot-machine illusion work.
        .mask(
            RoundedRectangle(cornerRadius: ButtonDimension.cornerRadius)
                .frame(width: ButtonDimension.width, height: ButtonDimension.height)
        )
        .onTapGesture {
            startDownloading()
        }
        .frame(width: ButtonDimension.width, height: ButtonDimension.height)
        .shadow(color: Color.background.opacity(0.4), radius: 10)
    }
    
    // MARK: - Functions
    
    /// Transitions from `.notInitiated` to `.downloading`.
    ///
    /// Slides the idle panel down out of frame, the downloading panel up into frame,
    /// and pre-positions the downloaded panel just above so it's ready to slide in next.
    /// Progress incrementing begins after the slide animation completes.
    func startDownloading() {
        self.downloader.currentState = .downloading
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadedOffset   = -ButtonDimension.height + 10  // Pre-position: just above frame
            self.downloadYOffset    = ButtonDimension.height         // Slide idle panel down out of view
            self.downloadingYOffset = 0                              // Slide downloading panel into view
        }
        
        // Wait for the slide animation to finish before starting progress,
        // so the progress bar doesn't start moving during the transition.
        Timer.scheduledTimer(withTimeInterval: ButtonDimension.animationDuration, repeats: false) { _ in
            incrementProgress()
        }
    }
    
    /// Increments `downloadProgress` by 0.045 every 0.15s until it reaches 1.0,
    /// then invalidates the timer and calls `itemDownloaded()`.
    ///
    /// > Note: Progress is hardcoded for demonstration purposes.
    /// > Replace with real download progress callbacks for production use.
    func incrementProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { progressTimer in
            if downloadProgress > 1 {
                downloadProgress = 1
                progressTimer.invalidate()  // Stop ticking once complete
                itemDownloaded()
                return
            }
            downloadProgress += 0.045   // Hardcoded increment — replace with real progress
        }
    }
    
    /// Transitions from `.downloading` to `.downloaded`.
    ///
    /// Slides the downloading panel down out of frame and the downloaded panel into view.
    /// After a 2.5-second display period, `reset()` is called to return to idle.
    func itemDownloaded() {
        self.downloader.currentState = .downloaded
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadingYOffset = ButtonDimension.height  // Slide downloading panel down out of view
            self.downloadedOffset   = 0                       // Slide downloaded panel into view
        }
        
        // Hold the success state for 2.5 seconds so the user can see it,
        // then automatically reset back to idle.
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
            reset()
        }
    }
    
    /// Resets all state back to `.notInitiated`, ready for the next download.
    ///
    /// The idle panel slides back in from the top. The downloading and downloaded
    /// panels are moved back to their off-screen starting positions after a short delay
    /// so they don't flash visibly during the idle panel's re-entry animation.
    func reset() {
        // Snap idle panel above the frame (invisible behind mask), then animate it in
        self.downloadYOffset    = -ButtonDimension.height
        self.downloadProgress   = 0
        self.downloader.currentState = .notInitiated
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadYOffset = 0  // Slide idle panel back into view from above
        }
        
        // Wait until the idle panel has fully slid in before resetting the other
        // two panels — avoids a visible flicker if they moved while still on-screen.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.downloadingYOffset = -ButtonDimension.height      // Reset to one height above
            self.downloadedOffset   = -(ButtonDimension.height * 2) // Reset to two heights above
        }
    }
    
    /// Returns the icon displayed on the left side of the button, keyed to the current state:
    ///
    /// - `.notInitiated` → Static (non-animated) download arrow in background color
    /// - `.downloading`  → Animated looping download arrow, offset left to align with progress bar
    /// - `.downloaded`   → `CircleTickShape` that draws itself in on appear, then stays visible
    ///
    /// The tick in the `.downloaded` case uses `.trim(from: 0, to:)` to animate the
    /// circle and checkmark drawing on. The trim target flips to `0` while in the
    /// `.downloading` state (keeping it invisible) and to `1` on `.downloaded`
    /// so it draws itself in during the panel transition.
    @ViewBuilder func getSupportingView() -> some View {
        if downloader.currentState == .notInitiated {
            // Static arrow — animation disabled since the button is idle
            DownloadingIndicatorView(needsAnimation: false)
                .foregroundStyle(.background)
            
        } else if downloader.currentState == .downloading {
            // Animated looping arrow — shifted left to sit beside the progress bar
            DownloadingIndicatorView()
                .offset(x: -16)
            
        } else {
            // Circle-tick that draws itself on when the downloaded panel slides in.
            // trim = 0 while downloading (fully hidden), trim = 1 when downloaded (fully drawn).
            // The delayed animation gives the panel time to slide in before the tick appears.
            CircleTickShape()
                .trim(from: 0, to: self.downloadProgress == 1 ? 0 : 1)
                .stroke(style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.white)
                .scaleEffect(0.6)
                .opacity(self.downloader.currentState == .downloaded ? 1 : 0)
                .animation(
                    Animation.easeInOut(duration: ButtonDimension.animationDuration * 2)
                        .delay(self.downloader.currentState == .downloaded
                               ? ButtonDimension.animationDuration / 4  // Short delay — let panel settle first
                               : 0),
                    value: downloader.currentState
                )
                .frame(width: 44, height: 44)
        }
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        DownloadButton(downloader: Downloader())
    }
    .colorScheme(.dark)
}


// 25 - 23
//
