//
//  BookLoaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 15/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A book-opening loader animation composed of two capsule "covers" and a
/// `BookHoldView` spine that open and close alternately to the left and right.
///
/// Tap to start. The book opens, page-flip particles play via `BookPagesView`,
/// then the covers close to one side, reopen, and close to the other side in a
/// continuous loop. Each cycle alternates between `closeRight` and `closeLeft`.
struct BookLoaderView: View {

    // MARK: - Variables

    /// Current animation direction — alternates between `.closeRight` and `.closeLeft`.
    @State var bookState: BookLoaderState = .closeRight

    /// Position of the left cover capsule (moves down when closing right).
    @State var leftCoverOffset: CGSize = CGSize(width: -84, height: 0)
    /// Rotation of the left cover (flips 180° when closing right).
    @State var leftRotationDegrees: Angle = .zero

    /// Position of the spine/book-hold shape.
    @State var middleBookOffset: CGSize = CGSize(width: -28, height: -28)
    /// Rotation of the spine (swings ±90° to face the closing direction).
    @State var middleRotationDegrees: Angle = .degrees(-90)

    /// Position of the right cover capsule (moves down when closing left).
    @State var rightCoverOffset: CGSize = CGSize(width: 84, height: 55.75)
    /// Rotation of the right cover (flips -180° when closing left).
    @State var rightRotationDegrees: Angle = .degrees(-180)

    /// Index into `BookLoaderState.allCases` for cycling through states.
    @State var currentIndex = 0
    /// Passed to `BookPagesView` to trigger the page-flip particle effect.
    @State var animationStarted: Bool = false

    /// Width of each cover capsule.
    let bookCoverWidth: CGFloat = 120
    /// Duration of one animation phase (open or close).
    let animationDuration: TimeInterval = 0.4

    // MARK: - Views

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            Capsule()
                .foregroundStyle(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(leftCoverOffset)
                .rotationEffect(leftRotationDegrees)
            BookHoldView()
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .miter))
                .foregroundStyle(.white)
                .rotationEffect(middleRotationDegrees)
                .offset(middleBookOffset)
            Capsule()
                .foregroundStyle(.white)
                .frame(width: bookCoverWidth, height: 8)
                .offset(rightCoverOffset)
                .rotationEffect(rightRotationDegrees)
            BookPagesView(animationStarted: $animationStarted, animationDuration: animationDuration)
                .offset(y: -20)
        }
        .onTapGesture {
            HapticManager().makeImpactFeedback(mode: .light)
            animationStarted.toggle()
            animateBookEnds()

            Timer.scheduledTimer(withTimeInterval: animationDuration * 3.4, repeats: false) { _ in
                animateBook()

                Timer.scheduledTimer(withTimeInterval: animationDuration * 5, repeats: true) { _ in
                    animateBook()
                }
            }
        }
    }

    // MARK: - Functions

    /// Advances to the next `BookLoaderState`, wrapping around to the beginning.
    func getNextCase() -> BookLoaderState {
        let allCases = BookLoaderState.allCases
        if currentIndex == allCases.count - 1 {
            currentIndex = -1
        }
        currentIndex += 1
        return allCases[currentIndex]
    }

    /// Animates the book closing to the current state's end position,
    /// then advances to the next state and opens again.
    func animateBook() {
        withAnimation(.linear(duration: animationDuration)) {
            middleRotationDegrees = bookState.animationEnd.3
            leftCoverOffset = bookState.animationEnd.0
            rightCoverOffset = bookState.animationEnd.4
        }

        withAnimation(.easeOut(duration: animationDuration)) {
            leftRotationDegrees = bookState.animationEnd.1
            rightRotationDegrees = bookState.animationEnd.5
            middleBookOffset = bookState.animationEnd.2
        }

        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.6, repeats: false) { _ in
            bookState = getNextCase()
            animateBookEnds()
        }
    }

    /// Animates the book to its open position for the current state.
    func animateBookEnds() {
        withAnimation(.easeOut(duration: animationDuration)) {
            middleRotationDegrees = bookState.animationBegin.3
            middleBookOffset = bookState.animationBegin.2
        }

        withAnimation(.easeOut(duration: animationDuration)) {
            leftCoverOffset = bookState.animationBegin.0
            rightCoverOffset = bookState.animationBegin.4
        }

        withAnimation(.linear(duration: animationDuration * 0.9).delay(animationDuration * 0.05)) {
            leftRotationDegrees = bookState.animationBegin.1
            rightRotationDegrees = bookState.animationBegin.5
        }
    }
}

#Preview {
    BookLoaderView()
}


/// The two alternating states of the book loader — which side the book closes toward.
///
/// Each state provides begin (open) and end (closed) values as a 6-tuple:
/// `(leftOffset, leftAngle, middleOffset, middleAngle, rightOffset, rightAngle)`.
enum BookLoaderState: CaseIterable {
    case closeRight
    case closeLeft

    /// Layout values for the open position — both covers flat, spine centered.
    var animationBegin: (CGSize, Angle, CGSize, Angle, CGSize, Angle) {
        switch self {
        case .closeRight:
            return (CGSize(width: -84, height: 0), .degrees(0), CGSize(width: 0, height: 0), .degrees(0), CGSize(width: 84, height: 0), .degrees(0))
        case .closeLeft:
            return (CGSize(width: -84, height: 0), .degrees(0), CGSize(width: 0, height: 0), .degrees(0), CGSize(width: 84, height: 0), .degrees(0))
        }
    }

    /// Layout values for the closed position — one cover flipped, spine rotated.
    var animationEnd: (CGSize, Angle, CGSize, Angle, CGSize, Angle) {
        switch self {
        case .closeRight:
            return (CGSize(width: -84, height: 55.75), .degrees(180), CGSize(width: 28, height: -28), .degrees(90), CGSize(width: 84, height: 0), .degrees(0))
        case .closeLeft:
            return (CGSize(width: -84, height: 0), .degrees(0), CGSize(width: -28, height: -28), .degrees(-90), CGSize(width: 84, height: 55.75), .degrees(-180))
        }
    }
}
