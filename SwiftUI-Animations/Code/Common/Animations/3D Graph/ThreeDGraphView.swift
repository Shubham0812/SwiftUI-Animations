//
//  ThreeDGraphView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 19/07/24.
//  Copyright © 2024 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Model

/// One bar in the 3-D graph: a label, a 0...1 value that scales its height, and a fill color.
struct SkillBar: Identifiable {
    let id = UUID()
    let name: String
    /// Height of the bar relative to the tallest, in the range 0...1. Mutable so a drag can resize it.
    var value: CGFloat
    /// Fill color; resolves automatically to a lighter pastel in dark mode and a deeper,
    /// more saturated tone in light mode so the bars stay legible on either background.
    let color: Color
}

/// A `Color` that resolves to `dark` in dark mode and `light` in light mode, both hex strings.
private extension Color {
    init(light: String, dark: String) {
        self = Color(UIColor { traits in
            UIColor(hex: traits.userInterfaceStyle == .dark ? dark : light)
        })
    }
}

// MARK: - Main View

/// An interactive isometric 3-D bar graph. The bars grow in on appear, and each bar can be
/// dragged up or down to change its own height in real time.
///
/// Each bar is drawn as three shaded faces (top, left, right) so it reads as a solid
/// isometric block. The bars are arranged with a negative `HStack` spacing and a per-bar
/// vertical offset so they recede up-and-to-the-right like a row of dominoes, and each grows
/// from zero height with a staggered delay when `animate` flips true.
struct ThreeDGraphView: View {

    // MARK: - Variables

    /// Drives the initial grow-in animation. Set true on appear.
    @State private var animate = false

    /// The bars, sorted shortest-first so the tallest sits at the back-right of the stack.
    /// Mutable state so each bar's `value` can be updated live while dragging.
    @State private var bars: [SkillBar] = [
        SkillBar(name: "SwiftUI",    value: 1.0,  color: Color(light: "4E92CE", dark: "C6DEF1")),
        SkillBar(name: "UIKit",      value: 0.9,  color: Color(light: "8E6FD0", dark: "DBCDF0")),
        SkillBar(name: "MVVM",       value: 0.8,  color: Color(light: "4FA98D", dark: "C9E4DE")),
        SkillBar(name: "Networking", value: 0.75, color: Color(light: "E0925A", dark: "F7D9C4")),
        SkillBar(name: "CoreData",   value: 0.6,  color: Color(light: "D9B441", dark: "FAEDCB")),
        SkillBar(name: "Combine",    value: 0.45, color: Color(light: "4FAAA4", dark: "CDE8E6")),
    ].sorted { $0.value < $1.value }

    /// Fixed footprint of a single bar (width of the block, max height).
    private let barSize = CGSize(width: 40, height: 212)

    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            // Spacing/offset unit derived from the available width, matching the original layout.
            let unit = (proxy.size.width / 1.5) / CGFloat(bars.count)

            ZStack {
                Color.background
                    .ignoresSafeArea()

                // Negative spacing overlaps the bars; the per-bar Y offset staggers them upward.
                HStack(alignment: .bottom, spacing: -unit / 2) {
                    ForEach(Array(bars.enumerated()), id: \.element.id) { index, bar in
                        GraphBarView(
                            barSize: barSize,
                            progress: bar.value,
                            animate: animate,
                            delay: TimeInterval(Double(index) * 0.1)
                        )
                        .zIndex(CGFloat(bars.count - index) * 0.1)   // Front bars draw over those behind.
                        .foregroundStyle(bar.color)
                        .frame(width: 65)
                        .gesture(
                            // Drag a bar vertically to change its height: up grows it, down shrinks it.
                            // Hit-testing falls on the filled faces, so each bar only grabs its own drag
                            // even though the columns overlap.
                            DragGesture()
                                .onChanged { value in
                                    let delta = value.translation.height * -0.0002
                                    bars[index].value = min(max(bars[index].value + delta, 0), 1)
                                }
                        )
                        .overlay(alignment: .bottom) {
                            // Vertical skill label riding along the bar's left edge.
                            Text(bar.name)
                                .font(.system(size: 10.5, weight: .medium))
                                .tracking(1.05)
                                .foregroundStyle(Color.label)
                                .fixedSize()   // Don't let the rotated label truncate (e.g. "Networking").
                                .offset(x: -50 + Double(index * 2), y: 4)
                                .rotationEffect(.degrees(-90))
                        }
                        .offset(y: unit / 3.5 * -CGFloat(index))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Single Bar

/// A single isometric bar built from three shaded faces. The faces inherit the bar's color
/// via `foregroundStyle`; `brightness` on each face fakes directional lighting so the block
/// looks three-dimensional. The bar grows from zero to its target height when `animate` is true.
struct GraphBarView: View {

    /// The bar's footprint: `width` is the block width, `height` the fully-grown height.
    let barSize: CGSize

    /// The bar's value in 0...1, controlling how tall it grows.
    let progress: CGFloat

    /// When true the bar animates up to its target height; when false it collapses to zero.
    let animate: Bool

    /// Stagger applied so bars grow in one after another.
    var delay: TimeInterval = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TopFace().brightness(0)       // Lit top.
            LeftFace().brightness(-0.05)  // Shaded left.
            RightFace().brightness(0.1)   // Highlighted right.
        }
        // Grow from 0 up to a base (barSize.width) plus a share of the remaining height.
        .frame(width: barSize.width,
               height: animate ? barSize.width + (barSize.height - barSize.width) * progress : 0)
        .frame(height: 0, alignment: .bottom)
        .animation(.smooth.delay(delay), value: animate)
    }

    // The three isometric faces. Coordinates are fractions of the shape's rect so the block
    // keeps its proportions at any height. `width / 2.1` is the front vertical edge; `width / 4`
    // is the depth of the top face.
    struct LeftFace: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let start = CGPoint(x: 0, y: rect.width / 4)
            path.move(to: start)
            path.addLine(to: CGPoint(x: rect.width / 2.1, y: rect.width / 2.1))
            path.addLine(to: CGPoint(x: rect.width / 2.1, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height - (rect.width / 4)))
            path.addLine(to: start)
            path.closeSubpath()
            return path
        }
    }

    struct RightFace: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let start = CGPoint(x: rect.width / 2.1, y: rect.width / 2.1)
            path.move(to: start)
            path.addLine(to: CGPoint(x: rect.width, y: rect.width / 4))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - (rect.width / 4)))
            path.addLine(to: CGPoint(x: rect.width / 2.1, y: rect.height))
            path.addLine(to: start)
            path.closeSubpath()
            return path
        }
    }

    struct TopFace: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let start = CGPoint(x: 0, y: rect.width / 4)
            path.move(to: start)
            path.addLine(to: CGPoint(x: rect.width - (rect.width / 2.1), y: rect.width / 25))
            path.addLine(to: CGPoint(x: rect.width, y: rect.width / 4))
            path.addLine(to: CGPoint(x: rect.width / 2.1, y: rect.width / 2.1))
            path.addLine(to: start)
            path.closeSubpath()
            return path
        }
    }
}

#Preview {
    ThreeDGraphView()
}
