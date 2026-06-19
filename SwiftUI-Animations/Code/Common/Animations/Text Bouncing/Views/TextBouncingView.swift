//
//  TextBouncingView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct TextBouncingView: View {

    // MARK: - variables
    @State private var currentText = "iOS Engineer"
    @State private var customText: String = ""

    @State private var activeIndex: Int? = nil
    // Keyed by character index. Reported continuously via a preference key so the
    // frames stay accurate after the insert transition settles and as the text changes.
    @State private var characterFrames: [Int: CGRect] = [:]

    @State private var changeText = false
    @State private var currentTextIndex: Int = 0

    private let textArrays: [String] = [
        "iOS Engineer",
        "Happy Birthday",
        "Ephemeral",
        "Frivolous"
    ]

    private let haptics = HapticManager()

    // MARK: - views
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            HStack(spacing: 0) {
                ForEach(Array(currentText.enumerated()), id: \.offset) { index, char in
                    BouncingCharacterView(character: String(char), index: index, activeIndex: activeIndex)
                    // Continuously publish each character's frame so the drag gesture can
                    // map a touch's x position back to the character underneath it. Using a
                    // preference (instead of a one-shot onAppear) keeps frames correct after
                    // the insert transition finishes and as the text length changes.
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: CharacterFramePreferenceKey.self,
                                        value: [index: geo.frame(in: .named("textArea"))]
                                    )
                            }
                        )
                        .id(currentText)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .offset(y: -40)
        }
        .onPreferenceChange(CharacterFramePreferenceKey.self) { frames in
            characterFrames = frames
        }
        .coordinateSpace(name: "textArea")
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let x = value.location.x
                    if let idx = indexAt(xLocation: x), idx != activeIndex {
                        activeIndex = idx
                        haptics.makeImpactFeedback(mode: .light)
                    }
                }
                .onEnded { _ in
                    activeIndex = nil
                }
        )
        .overlay(alignment: .bottom) {
            TextField("Enter name to bounce", text: $customText)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .font(ClashGrotestk.medium.font(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(UIColor.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 32)
                .onChange(of: customText) { _, newValue in
                    withAnimation(.smooth) {
                        currentText = newValue.isEmpty ? " " : newValue
                    }
                }
                .padding(.bottom, 24)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.snappy(duration: 0.3)) {
                        haptics.makeSelectionFeedback()
                        customText = ""
                        changeText.toggle()
                        currentTextIndex = currentTextIndex + 1 > textArrays.count - 1 ? 0 : currentTextIndex + 1
                        currentText = textArrays[currentTextIndex]
                    }
                } label: {
                    Image(systemName: "shuffle")
                }
                .symbolEffect(.bounce, options: .speed(1.25), value: changeText)
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - functions
    private func indexAt(xLocation: CGFloat) -> Int? {
        characterFrames
            .first { _, rect in xLocation >= rect.minX && xLocation < rect.maxX }?
            .key
    }
}

// MARK: - CharacterFramePreferenceKey
private struct CharacterFramePreferenceKey: PreferenceKey {
    static let defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

#Preview {
    NavigationStack {
        TextBouncingView()
    }
}
