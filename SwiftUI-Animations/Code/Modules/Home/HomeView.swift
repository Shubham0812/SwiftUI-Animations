//
//  HomeView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct HomeView: View {

    // MARK: - Variables
    @State private var chatMessage: String = ""
    @State private var selectedCategory: AnimationCategory? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    private var filteredItems: [AnimationItem] {
        guard let selected = selectedCategory else { return AnimationItem.all }
        return AnimationItem.all.filter { $0.category == selected }
    }

    // MARK: - Views
    var body: some View {
        NavigationStack {
            ScrollView {
                filterChips
                    .safeAreaPadding(.trailing, 12)
                    .safeAreaPadding(.leading, 42)
                    .padding(.horizontal, -24)
                    .padding(.top, 12)
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(filteredItems) { item in
                        NavigationLink(value: item.destination) {
                            AnimationCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .padding(.top, 6)
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedCategory)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("SwiftUI")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .frame(width: 120)
                            .padding(.leading, 10)
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("SwiftUI")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .frame(width: 120)
                            .padding(.leading, 16)
                    }
                }
            }
            .navigationDestination(for: AnimationDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                chipButton(title: "All", category: nil)
                ForEach(AnimationCategory.allCases, id: \.self) { category in
                    chipButton(title: category.rawValue.capitalized, category: category)
                }
            }
            .safeAreaPadding(.leading, 16)
        }
    }

    private func chipButton(title: String, category: AnimationCategory?) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedCategory = isSelected ? nil : category
            }
        } label: {
            Text(title)
                .font(.system(.subheadline, design: .rounded).weight(isSelected ? .bold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color(.secondarySystemFill).opacity(0.7))
                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCategory)
    }

    // MARK: - Functions
    @ViewBuilder
    private func destinationView(for destination: AnimationDestination) -> some View {
        switch destination {
        case .rotatingLoader:
            RotatingLoaderView()
        case .addView:
            AddView()
        case .bankCard:
            CardView(card: AppConstants.cards[0], UIState: UIStateModel())
        case .bookLoader:
            BookLoaderView()
        case .cart:
            AddCartView(cartAnimation: .ready, backgroundColor: Color.black, color: Color.white)
        case .chatBar:
            ChatBarView(message: $chatMessage)
        case .circleLoader:
            CircleLoader()
        case .downloadButton:
            DownloadButton()
        case .githubLoader:
            GithubLoader()
        case .infinityLoader:
            InfinityView()
        case .lightSwitch:
            LightSwitchView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .like:
            LikeView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .loader:
            LoaderView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .loaderII:
            LoaderIIView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .loginView:
            LoginView()
        case .octocat:
            OctocatView()
        case .pillLoader:
            PillLoader()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .spinningLoader:
            SpinningView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .submitView:
            SubmitView()
        case .triangleLoader:
            TriangleLoader()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .wifi:
            WifiView()
                .toolbarColorScheme(.dark, for: .navigationBar)
        case .yinYangToggle:
            YinYangAnimationView()
        }
    }
}

#Preview {
    HomeView()
    
}
