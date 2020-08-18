//
//  LoaderState.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

enum LoaderState: CaseIterable {
    case right
    case down
    case left
    case up
    
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
    
    var capsuleDimension: CGFloat {
        return 40
    }
    var increasingOffset: CGFloat {
        return 72
    }
    
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
