//
//  BookPagesView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 17/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Animates a fan of 15 capsule "pages" fanning open and closing inside a book loader.
///
/// Composed of:
/// - Two end-cap capsules (left and right) that rotate and shift vertically
///   to mimic the top and bottom pages of the open book.
/// - Thirteen intermediate capsules staggered with `delay` so they fan out
///   one by one rather than all at once, creating a rippling page-turn effect.
///
/// `animationStarted` is polled every 0.3 s until the parent sets it `true`,
/// then `animatePages()` fires immediately and repeats every `animationDuration × 10`.
struct BookPagesView: View {

    // MARK:- variables

    /// Unused directly in layout — reserved as a flag that `onAppear` polling can check.
    @State var isAppeared: Bool = false

    /// Rotation of the left end-cap capsule (flips to 180° when the book opens).
    @State var leftEndDegree: Angle = .zero
    /// Vertical offset of the left end-cap (shifts down 20 pt when the book is open).
    @State var leftYOffset: CGFloat = 0

    /// Rotation of the right end-cap capsule (flips to 180° immediately on open).
    @State var rightEndDegree: Angle = .zero
    /// Vertical offset of the right end-cap (starts at –20 pt, normalises on open).
    @State var rightYOffset: CGFloat = -20

    /// Shared rotation applied to all 13 intermediate page capsules.
    /// Animates from 0° (closed) to 180° (open) with staggered delays per capsule.
    @State var pagesDegree: Angle = .zero
    /// Bound from the parent `BookLoaderView`; polling begins as soon as this turns `true`.
    @Binding var animationStarted: Bool

    /// Width of each capsule bar — slightly narrower than the cover (`bookCoverWidth` in parent).
    let bookCoverWidth: CGFloat = 100
    /// Horizontal offset applied to all capsules so they appear inside the open book spine.
    let barsOffset: CGFloat = -78
    /// Duration injected by `BookLoaderView`; all internal timers are multiples of this.
    let animationDuration: TimeInterval
    
    // MARK:- views
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barsOffset, y: leftYOffset)
                .rotationEffect(leftEndDegree)
                .animation(Animation.easeOut(duration: animationDuration))
            
            Capsule()
                .foregroundColor(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(x: barsOffset, y: rightYOffset)
                .rotationEffect(rightEndDegree)
                .animation(Animation.easeOut(duration: animationDuration))
            
            //            // Bars
            ForEach(0..<13) { num in
                Capsule()
                    .foregroundColor(.white)
                    .frame(width: bookCoverWidth, height: 8)
                    .offset(x: barsOffset)
                    .rotationEffect(pagesDegree)
                    .animation(Animation.easeOut(duration: animationDuration).delay((animationDuration * 0.21) * Double(num)))
            }
        }.onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { animationTimer in
                if (animationStarted) {
                    animatePages()
                    Timer.scheduledTimer(withTimeInterval: animationDuration * 10, repeats: true) { _ in
                        animatePages()
                    }
                    animationTimer.invalidate()
                }
            }
        }
    }
    
    // MARK:- functions

    /// Runs one full page-turn animation cycle across five timer phases:
    ///
    /// - **t = 0**: Right end-cap and all 13 pages snap to 180° (fan open).
    /// - **t = duration × 2.7**: Left end-cap shifts down and rotates 180°.
    /// - **t = duration × 5.0**: Left end-cap resets (returns to 0° / 0 offset).
    /// - **t = duration × 5.25**: Page fan collapses back to 0°.
    /// - **t = duration × 7.0**: Right end-cap resets to its initial position.
    func animatePages() {
        self.isAppeared.toggle()
        self.rightEndDegree = .degrees(180)
        self.pagesDegree = .degrees(180)
        self.rightYOffset = 0
        
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2.7, repeats: false) { _ in
            self.leftYOffset = 20
            self.leftEndDegree = .degrees(180)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5, repeats: false) { _ in
            self.leftYOffset = 0
            self.leftEndDegree = .zero
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 5.25, repeats: false) { _ in
            self.pagesDegree = .degrees(0)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 7, repeats: false) { _ in
            self.rightEndDegree = .degrees(0)
            self.rightYOffset = -20
        }
    }
    
}

struct BookPagesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            BookPagesView(animationStarted: .constant(true), animationDuration: 0.5)
        }
    }
}
