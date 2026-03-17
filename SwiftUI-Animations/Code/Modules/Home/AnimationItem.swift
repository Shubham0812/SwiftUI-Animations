//
//  AnimationItem.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - AnimationDestination
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
}

// MARK: - AnimationItem
struct AnimationItem: Identifiable {
    let id = UUID()
    let title: String
    let systemIcon: String
    let iconColor: Color
    let destination: AnimationDestination

    // MARK: - All Animations
    static let all: [AnimationItem] = [
        AnimationItem(title: "3D Loader", systemIcon: "cube.fill", iconColor: Color(r: 255, g: 149, b: 0), destination: .rotatingLoader),
        AnimationItem(title: "Add View", systemIcon: "plus.circle.fill", iconColor: Color.expandingAccent, destination: .addView),
        AnimationItem(title: "Bank Card", systemIcon: "creditcard.fill", iconColor: Color.submitColor, destination: .bankCard),
        AnimationItem(title: "Book Loader", systemIcon: "book.fill", iconColor: Color(r: 52, g: 199, b: 89), destination: .bookLoader),
        AnimationItem(title: "Cart", systemIcon: "cart.fill", iconColor: Color.chatBackground, destination: .cart),
        AnimationItem(title: "Chat Bar", systemIcon: "message.fill", iconColor: Color.chatBackground, destination: .chatBar),
        AnimationItem(title: "Circle Loader", systemIcon: "arrow.triangle.2.circlepath", iconColor: Color.circleRoundStart, destination: .circleLoader),
        AnimationItem(title: "Download Button", systemIcon: "arrow.down.circle.fill", iconColor: Color(r: 52, g: 199, b: 89), destination: .downloadButton),
        AnimationItem(title: "Github Loader", systemIcon: "antenna.radiowaves.left.and.right", iconColor: Color.materialBlack, destination: .githubLoader),
        AnimationItem(title: "Infinity Loader", systemIcon: "infinity", iconColor: Color.pillColor, destination: .infinityLoader),
        AnimationItem(title: "Light Switch", systemIcon: "lightswitch.on", iconColor: Color(r: 255, g: 204, b: 0), destination: .lightSwitch),
        AnimationItem(title: "Like Button", systemIcon: "heart.fill", iconColor: Color.likeColor, destination: .like),
        AnimationItem(title: "Loader", systemIcon: "circle.dotted", iconColor: Color.circleRoundEnd, destination: .loader),
        AnimationItem(title: "Loader II", systemIcon: "circles.hexagongrid.fill", iconColor: Color.circleRoundStart, destination: .loaderII),
        AnimationItem(title: "Login View", systemIcon: "person.crop.circle.fill", iconColor: Color.submitColor, destination: .loginView),
        AnimationItem(title: "Octocat Wink", systemIcon: "eye.fill", iconColor: Color.materialBlack, destination: .octocat),
        AnimationItem(title: "Pill Loader", systemIcon: "capsule.fill", iconColor: Color.pillColor, destination: .pillLoader),
        AnimationItem(title: "Spinning Loader", systemIcon: "arrow.2.circlepath", iconColor: Color(r: 255, g: 149, b: 0), destination: .spinningLoader),
        AnimationItem(title: "Submit View", systemIcon: "paperplane.fill", iconColor: Color.submitColor, destination: .submitView),
        AnimationItem(title: "Triangle Loader", systemIcon: "triangle.fill", iconColor: Color.expandingAccent, destination: .triangleLoader),
        AnimationItem(title: "Wifi", systemIcon: "wifi", iconColor: Color.wifiConnected, destination: .wifi),
        AnimationItem(title: "Yin Yang Toggle", systemIcon: "circle.lefthalf.filled", iconColor: Color.label, destination: .yinYangToggle),
    ]
}
