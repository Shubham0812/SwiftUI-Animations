//
//  BouncingCharacterView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct BouncingCharacterView: View {

    // MARK: - variables
    let character: String
    let index: Int
    let activeIndex: Int?

    var isActive: Bool {
        activeIndex == index
    }

    var isAdjacent: Bool {
        guard let active = activeIndex else { return false }
        return abs(active - index) == 1
    }

    // The actively-touched character pops in blue, its neighbours lift slightly,
    // and everything else stays at the primary label colour.
    var color: Color {
        if isActive {
            return .blue.opacity(0.9)
        } else if isAdjacent {
            return .blue.opacity(0.5)
        } else {
            return .primary
        }
    }

    // MARK: - views
    var body: some View {
        Text(character)
            .font(ClashGrotestk.semibold.font(size: 48))
            .foregroundColor(color)
            .scaleEffect(isActive ? 1.4 : 1.0)
            .offset(y: isActive ? -20 : 0)
            .animation(.smooth(duration: 0.225), value: activeIndex)
            .contentTransition(.numericText())
            .animation(.default, value: character)
            .offset(y: -75)
    }
}

#Preview {
    BouncingCharacterView(character: "A", index: 0, activeIndex: 0)
        .padding(24)
}
