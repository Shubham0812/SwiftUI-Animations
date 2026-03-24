//
//  ShaderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 20/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - ShaderView
struct ShaderView: View {

    // MARK: - variables
    @State private var selectedCategory: ShaderCategory? = nil
    @State private var searchText: String = ""

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    private let animationDuration: TimeInterval = 0.325

    private var filteredItems: [ShaderItem] {
        let baseItems: [ShaderItem]

        if let selected = selectedCategory {
            baseItems = ShaderItem.all.filter { $0.category == selected }
        } else {
            baseItems = ShaderItem.all
        }

        guard !searchText.isEmpty else { return baseItems }

        let query = searchText.lowercased()
        return baseItems.filter { $0.title.lowercased().contains(query) }
    }

    // MARK: - views
    var body: some View {
        ScrollView(showsIndicators: false) {
            filterChips
                .safeAreaPadding(.trailing, 12)
                .safeAreaPadding(.leading, 24)
                .padding(.horizontal, -24)
                .padding(.top, 12)

            LazyVGrid(columns: columns, spacing: 32) {
                ForEach(filteredItems) { item in
                    NavigationLink(value: item.destination) {
                        ShaderCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .padding(.top, 12)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedCategory)
            .animation(.smooth(duration: animationDuration), value: filteredItems.count)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .searchable(text: $searchText, prompt: Text("Search for an effect"))
        .toolbar {
            if #available(iOS 26.0, *) {
                ToolbarItem(placement: .topBarLeading) {
                    Text("SwiftUI")
                        .font(ClashGrotestk.bold.font(size: 32))
                        .frame(width: 120, alignment: .leading)
                        .padding(.leading, 10)
                }
                .sharedBackgroundVisibility(.hidden)

            } else {
                ToolbarItem(placement: .topBarLeading) {
                    Text("SwiftUI")
                        .font(ClashGrotestk.bold.font(size: 24))
                        .frame(width: 120)
                        .padding(.leading, 16)
                }
            }
        }
        .navigationDestination(for: ShaderDestination.self) { destination in
            destinationView(for: destination)
                .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - views (private)
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                chipButton(title: "All", category: nil)
                ForEach(ShaderCategory.allCases, id: \.self) { category in
                    chipButton(title: category.rawValue.capitalized, category: category)
                }
            }
            .safeAreaPadding(.leading, 16)
        }
    }

    private func chipButton(title: String, category: ShaderCategory?) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            HapticManager().makeSelectionFeedback()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = isSelected ? nil : category
            }
        } label: {
            Text(title)
                .font(isSelected ? ClashGrotestk.semibold.font(size: 14) : ClashGrotestk.medium.font(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.secondarySystemFill).opacity(0.7))
                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCategory)
    }

    // MARK: - functions
    @ViewBuilder
    private func destinationView(for destination: ShaderDestination) -> some View {
        switch destination {
        case .burnEffect:
            BurnEffectView()

        case .pixelSnap:
            PixelSnapView()

        case .emberReveal:
            EmberRevealView()

        case .rippleEffect:
            RippleEffectView()

        case .chromaticAberration:
            ChromaticAberrationView()

        case .halftone:
            HalftoneView()

        case .glitchEffect:
            GlitchEffectView()
        }
    }
}

#Preview {
    NavigationStack {
        ShaderView()
    }
}
