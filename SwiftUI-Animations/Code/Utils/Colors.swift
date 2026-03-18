//
//  Colors.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 08/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Convenience color definitions used throughout the animation demos.
///
/// Provides a semantic color palette (e.g., `background`, `chatBackground`) and
/// an RGB convenience initializer so colors can be expressed as 0-255 values.
extension Color {

    /// Adaptive system background color, light or dark depending on the user's appearance setting.
    static let background: Color = Color(UIColor.systemBackground)
    /// Adaptive label color that automatically adjusts for light/dark mode.
    static let label: Color = Color(UIColor.label)

    /// Primary blue used in the chat bubble animation.
    static let chatBackground: Color = Color(r: 41, g: 121, b: 255.0)
    /// Light blue used for button backgrounds in the chat animation.
    static let buttonBackground: Color = Color(r: 144.0, g: 202.0, b: 249.0)

    /// Dark navy background for the Wi-Fi loader animation.
    static let wifiBackground: Color = Color(r: 5, g: 23, b: 46)
    /// Shadow color for the Wi-Fi loader rings.
    static let wifiShadow: Color = Color(r: 13, g: 50, b: 125)

    /// Green tint shown when the Wi-Fi loader reaches the connected state.
    static let wifiConnected: Color = Color(r: 170, g: 255, b: 197)

    /// Teal background for the expanding view animation.
    static let expandingBackground: Color = Color(r: 3, g: 247, b: 235)
    /// Accent magenta for the expanding view animation.
    static let expandingAccent: Color = Color(r: 186, g: 38, b: 75)

    /// Gradient start color for the circular progress track.
    static let circleTrackStart: Color = Color(r: 237, g: 242, b: 255)
    /// Gradient end color for the circular progress track.
    static let circleTrackEnd: Color = Color(r: 235, g: 248, b: 255)

    /// Gradient start color for the circular progress indicator.
    static let circleRoundStart: Color = Color(r: 71, g: 198, b: 255)
    /// Gradient end color for the circular progress indicator.
    static let circleRoundEnd: Color = Color(r: 90, g: 131, b: 255)

    /// Pink color used in the pill-shaped toggle animation.
    static let pillColor: Color = Color(r: 242, g: 53, b: 174)

    /// Deep purple background for the like button animation.
    static let likeBackground: Color = Color(r: 49, g: 28, b: 78)
    /// Slightly lighter purple overlay for the like button animation.
    static let likeOverlay: Color = Color(r: 64, g: 49, b: 82)

    /// Warm orange used for the like button heart icon.
    static let likeColor: Color = Color(r: 254, g: 140, b: 100)

    /// Vivid purple used for the submit button animation.
    static let submitColor: Color = Color(r: 110, g: 80, b: 249)

    /// Near-black color used as a material-style dark background.
    static let materialBlack: Color = Color(r: 18, g: 18, b: 18)
    /// Soft off-white used for text and shapes on dark backgrounds.
    static let offWhite: Color = Color(r: 225, g: 225, b: 235)

    /// Creates a color from 0-255 RGB values, converting them to the 0-1 range that SwiftUI expects.
    /// - Parameters:
    ///   - r: Red component (0-255).
    ///   - g: Green component (0-255).
    ///   - b: Blue component (0-255).
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
}

/// Adds a hex-string color initializer to `Color` by delegating to the `UIColor` hex initializer.
extension Color {

    /// Creates a SwiftUI `Color` from a hex string (e.g., `"#FF5733"` or `"FF5733"`).
    /// - Parameter hex: A 6- or 8-character hex string, with or without a leading `#`.
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}

/// Adds hex-string color parsing to `UIColor`.
extension UIColor {
    /// Creates a `UIColor` from a hex string, supporting 6-character (RGB) and 8-character (RGBA) formats.
    /// - Parameter hex: A hex string such as `"#FF5733"` or `"FF573380"`. The `#` prefix is optional.
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}


// Foundation
/// Adds number-formatting helpers to `Double`.
extension Double {

    /// Formats the double as a string, omitting the decimal part when the value is whole.
    /// - Parameter places: The number of decimal places to show for non-whole values.
    /// - Returns: A formatted string representation (e.g., `"3"` or `"3.14"`).
    func clean(places: Int) -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.\(places)f", self)
    }
}
