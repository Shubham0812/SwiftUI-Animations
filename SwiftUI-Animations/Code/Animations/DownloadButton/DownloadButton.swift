//
//  StateView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 08/04/21.
//  Copyright © 2021 Shubham Singh. All rights reserved.
//

import SwiftUI

struct DownloadButton: View {
    
    // MARK:- variables
    @StateObject var downloader = Downloader()
    
    @State var downloadYOffset: CGFloat = 0
    @State var downloadingYOffset: CGFloat = -ButtonDimension.height + 10
    @State var downloadedOffset: CGFloat = -(ButtonDimension.height * 2)
    
    @State var downloadProgress: CGFloat = 0
    
    // MARK:- views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            DownloadingStatesView(state: .downloaded, isLight: true, progress: .constant(0))
                .environmentObject(downloader)
                .offset(y: downloadedOffset)
            DownloadingStatesView(state: .downloading, needsProgress: true, isLight: true, progress: $downloadProgress)
                .environmentObject(downloader)
                .offset(y: downloadingYOffset)
            DownloadingStatesView(state: .notInitiated,  progress: .constant(0))
                .environmentObject(downloader)
                .offset(y: downloadYOffset)
            
            ZStack {
                if (downloader.currentState == .notInitiated) {
                    DownloadingIndicatorView(needsAnimation: false)
                        .foregroundColor(.black)
                }
                else if (downloader.currentState == .downloading) {
                    DownloadingIndicatorView()
                        .offset(x: -12)
                }
                
                CircleTickShape()
                    .trim(from: 0, to: self.downloader.currentState == .downloaded ? 1 : 0)
                    .stroke(style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.white)
                    .scaleEffect(0.6)
                    .opacity(self.downloader.currentState == .downloaded ? 1 : 0)
                    .animation(Animation.easeInOut(duration: ButtonDimension.animationDuration * 2).delay(self.downloader.currentState == .downloaded ? ButtonDimension.animationDuration : 0))
                    .frame(width: 44, height: 44)
            }
            .offset(x: -ButtonDimension.width / 3.5 + 12)
            
        }.mask(
            RoundedRectangle(cornerRadius: ButtonDimension.cornerRadius)
                .frame(width: ButtonDimension.width, height: ButtonDimension.height)
        )
        .onTapGesture {
            startDownloading()
        }
        .frame(width: ButtonDimension.width, height: ButtonDimension.height)
        .shadow(color: Color.background.opacity(0.4), radius: 10)
    }
    
    // MARK:- functions
    func startDownloading() {
        self.downloader.currentState = .downloading
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadedOffset = -ButtonDimension.height + 10
            self.downloadYOffset = ButtonDimension.height
            self.downloadingYOffset = 0
        }
        
        Timer.scheduledTimer(withTimeInterval: ButtonDimension.animationDuration, repeats: false) { _ in
            incrementProgress()
        }
    }
    
    func incrementProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { progressTimer in
            if (downloadProgress > 1) {
                downloadProgress = 1
                progressTimer.invalidate()
                itemDownloaded()
            }
            /// hardcoding progress for now
            downloadProgress += 0.06
        }
    }
    
    func itemDownloaded() {
        self.downloader.currentState = .downloaded
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadingYOffset = ButtonDimension.height
            self.downloadedOffset = 0
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
            reset()
        }
    }
    
    func reset() {
        self.downloadYOffset = -ButtonDimension.height
        self.downloadProgress = 0
        self.downloader.currentState = .notInitiated
        withAnimation(Animation.easeOut(duration: ButtonDimension.animationDuration)) {
            self.downloadYOffset = 0
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.downloadingYOffset = -ButtonDimension.height
            self.downloadedOffset = -(ButtonDimension.height * 2)
        }
    }
}


struct DownloadingStatesView: View {
    
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
                .offset(x: downloader.currentState.offsetForText() + 20)
                .animation(Animation.easeOut(duration: ButtonDimension.animationDuration / 2.25))
            
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

struct ButtonDimension {
    static let width: CGFloat = 320
    static let height: CGFloat = 76
    static let animationDuration: TimeInterval = 0.35
    static let cornerRadius: CGFloat = 12
}



struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            DownloadButton(downloader: Downloader())
        }
        .colorScheme(.dark)
    }
}

