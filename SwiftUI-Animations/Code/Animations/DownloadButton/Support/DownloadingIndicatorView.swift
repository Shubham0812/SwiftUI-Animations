//
//  DownloadingIcon.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 09/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct DownloadingIndicatorView: View {
    
    // MARK:- variables
    @State var downloadSymbolYOffset:  CGFloat = 0
    let animationDuration: TimeInterval = 0.5
    let size: CGFloat = 38
    
    var needsAnimation: Bool = true
    
    // MARK:- views
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 4))
                .frame(width: size, height: size)
                .shadow(color: Color.label.opacity(0.25), radius: 4, y: 2)
            Image(systemName: "arrow.down")
                .font(.system(size: 20, weight: .heavy))
                .offset(y: downloadSymbolYOffset)
                .mask(
                    Circle()
                        .frame(width: size, height: size)
                )
        }
        .onAppear() {
            if (needsAnimation) {
                withAnimation(Animation.easeIn(duration: animationDuration)) {
                    downloadSymbolYOffset = size
                }
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
                    animate()
                }
            }
        }
    }
    
    // MARK: - functions
    func animate() {
        downloadSymbolYOffset = -size
        withAnimation(Animation.easeIn(duration: animationDuration)) {
            downloadSymbolYOffset = size
        }
    }
}

struct DownloadingIcon_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingIndicatorView()
    }
}
