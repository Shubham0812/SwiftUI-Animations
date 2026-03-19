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

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    // MARK: - Views
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 32) {
                    ForEach(AnimationItem.all) { item in
                        NavigationLink(value: item.destination) {
                            AnimationCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
                .padding(.top, 18)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading) {
                        Text("SwiftUI")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .frame(width: 120)
                            .padding(.leading, 16)
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
