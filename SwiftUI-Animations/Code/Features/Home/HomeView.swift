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
    @State private var isFilterPinned: Bool = false
    @State private var scrollViewTopY: CGFloat = 0
    
    @State var searchText: String = ""
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    private let animationDuration: TimeInterval = 0.325
    
    private var filteredItems: [AnimationItem] {
        let baseItems: [AnimationItem]
        
        if let selected = selectedCategory {
            baseItems = AnimationItem.all.filter { $0.category == selected }
        } else {
            baseItems = AnimationItem.all
        }
        
        guard !searchText.isEmpty else { return baseItems }
        
        let query = searchText.lowercased()
        
        return baseItems.filter {
            $0.title.lowercased().contains(query)
        }
    }
    
    // MARK: - Views
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
                        AnimationCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
            .padding(.top, 12)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedCategory)
            .animation(.smooth(duration: animationDuration), value: filteredItems.count)
        }
        .background(GeometryReader { geo in
            Color.clear.onAppear {
                scrollViewTopY = geo.frame(in: .global).minY
            }
        })
        
        .overlay(alignment: .top) {
            if isFilterPinned {
                filterChips
                    .padding(.vertical, 10)
                    .background(Color(UIColor.systemGroupedBackground))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .searchable(text: $searchText, prompt: Text("Search for a work"))
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
                        .frame(width: 120, alignment: .leading)
                        .padding(.leading, 16)
                }
            }
        }
        .navigationDestination(for: AnimationDestination.self) { destination in
            destinationView(for: destination)
                .toolbar(.hidden, for: .tabBar)
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
            AddCartView(cartAnimation: .ready, backgroundColor: Color.background, color: Color.label)
            
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
            
        case .like:
            LikeView()
            
        case .loader:
            LoaderView()
            
        case .loaderII:
            LoaderIIView()
            
        case .loginView:
            LoginView()
            
        case .octocat:
            OctocatView()
            
        case .pillLoader:
            PillLoader()
            
        case .spinningLoader:
            SpinningView()
            
        case .submitView:
            SubmitView()
            
        case .triangleLoader:
            TriangleLoader()
            
        case .wifi:
            WifiView()
            
        case .yinYangToggle:
            YinYangAnimationView()

        case .textSwirl:
            TextSwirlView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
