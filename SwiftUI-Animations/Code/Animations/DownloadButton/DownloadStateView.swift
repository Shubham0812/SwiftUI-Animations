//
//  DownloadStateView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 09/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct DownloadStateView: View {
    
    // MARK:- variables
    var state: DownloadState = .downloaded
    var needsProgress: Bool = true
    var isLight: Bool = false
    
    @EnvironmentObject var downloader: Downloader
    @Binding var progress: CGFloat
    
    // MARK:- views
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(state.getBackground())
            Text(state.getStateName())
                .foregroundColor(isLight ? .white : .background)
                .font(.system(size: 26, weight: .bold))
                .shadow(color: Color.white.opacity(0.3), radius: 5, y: 2)
                .opacity(downloader.currentState != state ? 0 : 1)
                .offset(x: downloader.currentState.offsetForText() + 26)
                .animation(Animation.easeOut(duration: ButtonDimension.animationDuration / 2.25))
                .frame(alignment: .leading)
            
            if (needsProgress) {
                Capsule(style: .circular)
                    .trim(from: 0, to: progress / 2)
                    .stroke(lineWidth: 8)
                    .rotationEffect(.degrees(180))
                    .foregroundColor(Color(hex: "25D366"))
                    .frame(width: ButtonDimension.width, height: 12)
                    .offset(y: ButtonDimension.height / 2 + 4.5)
                    .mask(
                        RoundedRectangle(cornerRadius: ButtonDimension.cornerRadius)
                            .frame(width: 320, height: 84)
                    )
                    .opacity(downloader.currentState != state ? 0 : 1)
                    .animation(.default)
            }
        }
        .frame(width: ButtonDimension.width, height: ButtonDimension.height)
    }
}

struct DownloadingStatesView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadStateView(progress: .constant(0))
    }
}
