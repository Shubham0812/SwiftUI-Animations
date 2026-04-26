//
//  AnimationItem.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - AnimationDestination
enum AnimationCategory: String, CaseIterable, Hashable {
    case animation
    case loader
    case component
}

enum AnimationDestination: String, Hashable, CaseIterable {
    case rotatingLoader
    case addView
    case bankCard
    case bookLoader
    case cart
    case chatBar
    case circleLoader
    case downloadButton
    case githubLoader
    case infinityLoader
    case lightSwitch
    case like
    case loader
    case loaderII
    case loginView
    case octocat
    case pillLoader
    case spinningLoader
    case submitView
    case triangleLoader
    case wifi
    case yinYangToggle
    case textSwirl
    case cardSwap
    case scratchToReveal
}

// MARK: - AnimationItem
struct AnimationItem: Identifiable {
    
    let id = UUID()
    let title: String
    let systemIcon: String
    let iconColor: Color
    let destination: AnimationDestination
    let category: AnimationCategory
    var isNew: Bool = false
    
    // MARK: - All Animations
    static let all: [AnimationItem] = [
        AnimationItem(title: "3D Loader", systemIcon: "cube.fill", iconColor: Color(r: 255, g: 149, b: 0), destination: .rotatingLoader, category: .loader),
        AnimationItem(title: "Add View", systemIcon: "plus.circle.fill", iconColor: Color.expandingAccent, destination: .addView, category: .component),
        AnimationItem(title: "Bank Card", systemIcon: "creditcard.fill", iconColor: Color.submitColor, destination: .bankCard, category: .component),
        AnimationItem(title: "Book Loader", systemIcon: "book.fill", iconColor: Color(r: 52, g: 199, b: 89), destination: .bookLoader, category: .loader),
        AnimationItem(title: "Cart", systemIcon: "cart.fill", iconColor: Color.chatBackground, destination: .cart, category: .component),
        AnimationItem(title: "Chat Bar", systemIcon: "message.fill", iconColor: Color.chatBackground, destination: .chatBar, category: .component),
        AnimationItem(title: "Circle Loader", systemIcon: "arrow.triangle.2.circlepath", iconColor: Color.circleRoundStart, destination: .circleLoader, category: .loader),
        AnimationItem(title: "Download Button", systemIcon: "arrow.down.circle.fill", iconColor: Color(r: 52, g: 199, b: 89), destination: .downloadButton, category: .component),
        AnimationItem(title: "Github Loader", systemIcon: "antenna.radiowaves.left.and.right", iconColor: Color.secondary, destination: .githubLoader, category: .loader),
        AnimationItem(title: "Infinity Loader", systemIcon: "infinity", iconColor: Color.pillColor, destination: .infinityLoader, category: .loader),
        AnimationItem(title: "Light Switch", systemIcon: "lightswitch.on", iconColor: Color(r: 255, g: 204, b: 0), destination: .lightSwitch, category: .component),
        AnimationItem(title: "Like Button", systemIcon: "heart.fill", iconColor: Color.likeColor, destination: .like, category: .component),
        AnimationItem(title: "Loader", systemIcon: "circle.dotted", iconColor: Color.circleRoundEnd, destination: .loader, category: .loader),
        AnimationItem(title: "Loader II", systemIcon: "circles.hexagongrid.fill", iconColor: Color.circleRoundStart, destination: .loaderII, category: .loader),
        AnimationItem(title: "Login View", systemIcon: "person.crop.circle.fill", iconColor: Color.submitColor, destination: .loginView, category: .component),
        AnimationItem(title: "Octocat Wink", systemIcon: "eye.fill", iconColor: Color.secondary, destination: .octocat, category: .animation),
        AnimationItem(title: "Pill Loader", systemIcon: "capsule.fill", iconColor: Color.pillColor, destination: .pillLoader, category: .loader),
        AnimationItem(title: "Spinning Loader", systemIcon: "arrow.2.circlepath", iconColor: Color(r: 255, g: 149, b: 0), destination: .spinningLoader, category: .loader),
        AnimationItem(title: "Submit View", systemIcon: "paperplane.fill", iconColor: Color.submitColor, destination: .submitView, category: .component),
        AnimationItem(title: "Triangle Loader", systemIcon: "triangle.fill", iconColor: Color.expandingAccent, destination: .triangleLoader, category: .loader),
        AnimationItem(title: "Wifi", systemIcon: "wifi", iconColor: Color.wifiConnected, destination: .wifi, category: .animation),
        AnimationItem(title: "Yin Yang Toggle", systemIcon: "circle.lefthalf.filled", iconColor: Color.label, destination: .yinYangToggle, category: .component, isNew: true),
        AnimationItem(title: "Text Swirl", systemIcon: "tornado", iconColor: Color.blue, destination: .textSwirl, category: .component, isNew: true),
        AnimationItem(title: "Card Swap", systemIcon: "creditcard.and.123", iconColor: Color.orange, destination: .cardSwap, category: .component, isNew: true),
        AnimationItem(title: "Scratch to Reveal", systemIcon: "wand.and.sparkles", iconColor: Color.purple, destination: .scratchToReveal, category: .animation, isNew: true),
    ]
}
