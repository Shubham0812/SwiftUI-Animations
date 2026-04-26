//
//  CardHolderView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 26/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// `CardHolderView` is the visual chrome for a single card: a rounded rect
// filled with a `LinearGradient` (passed in via `gradientColors`) plus two
// thin decorative circles for that "embossed" look, and a hairline stroke
// border. `darkText` flips the decorative stroke colors so they read on
// either light or dark gradients.
//
// It's intentionally dumb — no card data lives here. `CardTwoView` composes
// this with the holder name, masked card number, and provider logo.

// Card's Design View
// We'll add a Gradient to it that is received from the Card data we defined in the ViewModel
struct CardHolderView: View {
    
    // MARK: - Variables
    var gradientColors: [Color]
    var darkText: Bool = false
    
    // We'll pass the hardcoded width for now to make the tutorial easier
    // Do add private to these variables, these are only used within the View. Good practices :D
    let width: CGFloat = UIScreen.main.bounds.width - 48
    let ratioConstant: CGFloat = 1.623
    
    let cornerRadius: CGFloat = 24
    
    // MARK: - Views
    var body: some View {
        let darkTextColor: Color = darkText ? Color.white : Color.black

        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundStyle(.clear)
            .overlay {
                // Gradient Fill and Shape
                ZStack {
                    
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(darkTextColor.opacity(0.125))
                        .offset(y: 70)
                        .scaleEffect(1.4)
                    
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundStyle(darkTextColor.opacity(0.125))
                        .offset(y: -70)
                        .scaleEffect(1.4)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            .frame(height: width / ratioConstant)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 1.25)
                    .foregroundStyle(darkTextColor)
                    .opacity(0.65)
            }
    }
    // That's it, let's make the Card View now
}

#Preview {
    CardHolderView(gradientColors: [Color.black, Color.black.opacity(0.85), Color.black], darkText: true)
        .fixedSize(horizontal: false, vertical: true)
        .padding(24)
}
