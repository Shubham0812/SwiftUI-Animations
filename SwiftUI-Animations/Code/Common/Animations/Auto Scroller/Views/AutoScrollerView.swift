//
//  AutoScrollerView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI
import Combine

/// An auto-scrolling card carousel.
///
/// The top card advances automatically every couple of seconds and can also be
/// swiped left/right. The slide direction follows the navigation direction, with a
/// faint viscous background, a page indicator, and a hint at the bottom.
struct AutoScrollerView: View {

    // MARK: - variables
    @Environment(\.colorScheme) var colorScheme

    @State private var currentIndex = 0
    /// Drives the transition direction: `true` when moving to the previous card.
    @State private var showPreviousCard = false
    @State private var viewModel = AutoScrollerViewModel()

    /// Fires the automatic advance every 2 seconds.
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    private let width: CGFloat = UIScreen.main.bounds.width - 48
    private let visaRatio: CGFloat = 2.095

    // MARK: - views
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                
                ForEach(0 ..< viewModel.cards.count, id: \.self) { index in
                    if index == currentIndex {
                        WalletCardView(card: viewModel.cards[index])
                            .transition(.asymmetric(
                                insertion: .move(edge: showPreviousCard ? .leading : .trailing),
                                removal: .move(edge: showPreviousCard ? .trailing : .leading)
                            ))
                            .frame(height: width / visaRatio)
                            .padding(24)
                            .offset(y: -42)
                    }
                }
                HStack {
                    ForEach(0 ..< viewModel.cards.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 24)
                            .opacity(index == currentIndex ? 1 : 0.5)
                            .frame(width: index == currentIndex ? 18 : 6, height: 6)
                    }
                }
                
                Spacer()
            }
            .overlay(alignment: .bottom) {
            
            }
        }
        .overlay(alignment: .bottom) {
            VStack {
                Spacer()
                
                Text("You can also Swipe Left / Right")
                    .font(ClashGrotestk.medium.font(size: 14))
                    .opacity(0.6)
                    .padding(.bottom, 24)
            }
        }
        .onReceive(timer) { _ in
            advance(forward: true)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 100
                    if value.translation.width < -threshold {
                        advance(forward: true)
                    } else if value.translation.width > threshold {
                        advance(forward: false)
                    }
                }
        )
    }

    // MARK: - functions

    /// Moves to the next (or previous) card, wrapping around, and sets the slide direction.
    private func advance(forward: Bool) {
        let count = viewModel.cards.count
        guard count > 0 else { return }

        showPreviousCard = !forward
        withAnimation(.snappy) {
            currentIndex = forward
                ? (currentIndex + 1) % count
                : (currentIndex - 1 + count) % count
        }
    }
}

#Preview {
    AutoScrollerView()
}
