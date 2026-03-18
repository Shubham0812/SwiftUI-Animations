//
//  AddView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// A floating action button that expands four action tiles on tap.
///
/// The central `+` icon rotates 45° and scales up when expanded.
/// Four `ExpandingView` tiles fly out in the four cardinal directions
/// (top, bottom, left, right), each revealing a different SF Symbol icon.
/// Tapping again collapses everything back to the `+`.
struct AddView: View {

    // MARK:- variables

    /// `true` when the four action tiles are expanded; drives all child animations.
    @State var isAnimating: Bool = false
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                ExpandingView(expand: $isAnimating, direction: .bottom, symbolName: "note.text")
                ExpandingView(expand: $isAnimating, direction: .left, symbolName: "doc")
                ExpandingView(expand: $isAnimating, direction: .top, symbolName: "photo")
                ExpandingView(expand: $isAnimating, direction: .right, symbolName: "mic.fill")
                Image(systemName: "plus")
                    .font(.system(size: 40, weight:  self.isAnimating ? .regular : .semibold, design: .rounded))
                    .foregroundColor(self.isAnimating ? Color.white : Color.black)
                    .rotationEffect(self.isAnimating ? .degrees(45) : .degrees(0))
                    .scaleEffect(self.isAnimating ? 3 : 1)
                    .opacity(self.isAnimating ? 0.5 : 1)
                    .animation(Animation.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 1))
                    .onTapGesture {
                        self.isAnimating.toggle()
                    }
            }.frame(height: 300)
            .padding()
        }
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

/// The direction a tile flies out from the central `+` button in `AddView`.
///
/// Each case provides two offset tuples used by `ExpandingView`:
/// - `offsets`: the final (x, y) position of the tile when fully expanded.
/// - `containerOffset`: a small static nudge applied to the tile's outer `ZStack`
///   to prevent all four tiles from stacking exactly on the center point.
enum ExpandDirection {
    case bottom
    case left
    case right
    case top

    /// Final (x, y) offset of the tile when `expand == true`.
    var offsets: (CGFloat, CGFloat) {
        switch self {
        case .bottom:
            return (32, 62)
        case .left:
            return (-62, 32)
        case .top:
            return (-32, -62)
        case .right:
            return (62, -32)
        }
    }
    
    /// Small static offset applied to the tile's outer container, unique per direction,
    /// so collapsed tiles don't overlap perfectly at the origin.
    var containerOffset: (CGFloat, CGFloat) {
        switch self {
        case .bottom:
            return (18, 18)
        case .left:
            return (-18, 18)
        case .top:
            return (-18, -18)
        case .right:
            return (18, -18)
        }
    }
}
