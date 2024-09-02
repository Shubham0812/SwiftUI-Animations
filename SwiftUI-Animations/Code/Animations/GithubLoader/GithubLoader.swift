//
//  GithubLoader.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 14/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct GithubLoader: View {
    
    // MARK: - variables
    @State var resetStrokes: Bool = true
    @State var strokeStart: CGFloat = 0
    @State var strokeEnd: CGFloat = 0
    
    
    // MARK: - views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            OctocatShape()
                .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round, miterLimit: 5))
                .foregroundColor(Color.white)
                .opacity(0.35)
            OctocatShape()
                .trim(from: strokeStart, to: strokeEnd)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, miterLimit: 10))
                .foregroundColor(Color.white)
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
                        if (self.strokeEnd >= 1) {
                            if (self.resetStrokes) {
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                    self.strokeEnd = 0
                                    self.strokeStart = 0
                                    self.resetStrokes.toggle()
                                }
                                self.resetStrokes = false
                            }
                        }
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            self.strokeEnd += 0.1
                            self.strokeStart = self.strokeEnd - 0.3
                        }
                    }
                }
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Text("@Shubham_iosdev")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .medium, design: .monospaced))
                        .opacity(0.3)
                }.padding(.trailing, 16)
            }
        }
    }
}

struct InfinityLoader_Previews: PreviewProvider {
    static var previews: some View {
        GithubLoader()
    }
}
