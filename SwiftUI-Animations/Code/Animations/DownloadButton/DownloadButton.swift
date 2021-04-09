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
    @State var downloadingYOffset: CGFloat = -ButtonDimension.height
    @State var downloadedOffset: CGFloat = -(ButtonDimension.height * 2)
    
    @State var downloadProgress: CGFloat = 0
    
    // MARK:- views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            DownloadStateView(state: .downloaded, isLight: true, progress: .constant(0))
                .environmentObject(downloader)
                .offset(y: downloadedOffset)
            DownloadStateView(state: .downloading, needsProgress: true, isLight: true, progress: $downloadProgress)
                .environmentObject(downloader)
                .offset(y: downloadingYOffset)
            DownloadStateView(state: .notInitiated,  progress: .constant(0))
                .environmentObject(downloader)
                .offset(y: downloadYOffset)
            
            ZStack {
                getSupportingView()
                    .scaleEffect(0.9)
            }
            .offset(x: -ButtonDimension.width / 3.5 + 13)
            
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
            downloadProgress += 0.045
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
    
    @ViewBuilder func getSupportingView() -> some View {
        if (downloader.currentState == .notInitiated) {
            DownloadingIndicatorView(needsAnimation: false)
                .foregroundColor(.background)
        } else if (downloader.currentState == .downloading) {
            DownloadingIndicatorView()
                .offset(x: -16)
        } else {
            CircleTickShape()
                .trim(from: 0, to: self.downloadProgress == 1 ? 0 : 1)
                .stroke(style: StrokeStyle(lineWidth: 5.5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .scaleEffect(0.6)
                .opacity(self.downloader.currentState == .downloaded ? 1 : 0)
                .offset(x: 8)
                .animation(Animation.easeInOut(duration: ButtonDimension.animationDuration * 2).delay(self.downloader.currentState == .downloaded ? ButtonDimension.animationDuration / 4 : 0))
                .frame(width: 44, height: 44)
        }
    }
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

