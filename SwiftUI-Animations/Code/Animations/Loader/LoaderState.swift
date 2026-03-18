//
//  LoaderState.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Represents the four directional phases of the capsule loader animation.
///
/// Each case defines the capsule's travel direction and provides layout values
/// (alignment, size, and position offsets) for both the "stretching" (`increment_before`)
/// and "contracting" (`increment_after`) halves of the movement.
enum LoaderState: CaseIterable {
    case right
    case down
    case left
    case up

    /// The alignment anchor for the capsule's frame during this phase.
    var alignment: Alignment {
        switch self {
        case .right, .down:
            return .topLeading
        case .left:
            return .topTrailing
        case .up:
            return .bottomLeading
        }
    }
    
    /// Base size of the capsule when it is at rest (square: 40×40).
    var capsuleDimension: CGFloat {
        return 40
    }
    /// Extra length added when the capsule stretches in its travel direction.
    var increasingOffset: CGFloat {
        return 72
    }

    /// Returns (x offset, y offset, width, height) for the first half of the animation —
    /// the capsule stretches from its current corner toward the next corner.
    var increment_before: (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch self {
        case .right:
            return (0, 0, capsuleDimension + increasingOffset, capsuleDimension)
        case .down:
            return (increasingOffset, 0, capsuleDimension, capsuleDimension + increasingOffset)
        case .left:
            return (increasingOffset, increasingOffset, capsuleDimension + increasingOffset, capsuleDimension)
        case .up:
            return (0, capsuleDimension + increasingOffset, capsuleDimension, capsuleDimension + increasingOffset)
        }
    }
    
    /// Returns (x offset, y offset, width, height) for the second half —
    /// the trailing edge catches up, contracting the capsule at the new corner.
    var increment_after: (CGFloat, CGFloat, CGFloat, CGFloat) {
        switch self {
        case .right:
            return (increasingOffset, 0, capsuleDimension, capsuleDimension)
        case .down:
            return (increasingOffset, increasingOffset, capsuleDimension, capsuleDimension)
        case .left:
            return (0, increasingOffset, capsuleDimension, capsuleDimension)
        default:
            return (0, capsuleDimension, capsuleDimension, capsuleDimension)
        }
    }
}
