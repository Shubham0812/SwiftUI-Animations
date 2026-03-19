//
//  FontManager.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 19/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

enum ClashGrotestk {
    case extralight
    case light
    case regular
    case medium
    case semibold
    case bold

    // MARK: - Functions
    func font(size: CGFloat) -> Font {
        switch self {
        case .extralight:
            return .custom("ClashGrotesk-Extralight", size: size)
        case .light:
            return .custom("ClashGrotesk-Light", size: size)
        case .regular:
            return .custom("ClashGrotesk-Regular", size: size)
        case .medium:
            return .custom("ClashGrotesk-Medium", size: size)
        case .semibold:
            return .custom("ClashGrotesk-Semibold", size: size)
        case .bold:
            return .custom("ClashGrotesk-Bold", size: size)
        }
    }
}
