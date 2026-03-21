//
//  BurnEffect.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 21/03/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI
import Combine

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func burnEffect(progress: Double) -> some View {
        self.modifier(BurnEffectModifier(progress: progress))
    }
}

struct BurnEffectModifier: ViewModifier {
    var progress: Double
    @State private var time: Double = 0
    @State private var startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsedTime = timeline.date.timeIntervalSince(startDate)
            
            // We use a GeometryReader inside an overlay to get the size
            // without messing up the layout of the original view.
            content
                .overlay(
                    GeometryReader { geo in
                        let size = geo.size
                        Color.clear
                            .onAppear {
                                // Reset time on appear if needed
                            }
                            .preference(key: SizePreferenceKey.self, value: size)
                    }
                )
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    // We can store size if needed, but we pass it directly below via VisualEffect usually
                    // For simplicity in this fix, we use the GeometryReader wrapping approach below.
                }
            // We apply the shader via a visualEffect to access 'size' easily in iOS 17
            // If you are on iOS 17+, use visualEffect. If not, use GeometryReader wrapper.
            // Here is the GeometryReader Wrapper approach which is safest:
                .modifier(BurnLayoutWrapper(progress: progress, time: elapsedTime))
        }
    }
}

// Helper to pass Size to Shader
// Helper to pass Size to Shader AND Particles
struct BurnLayoutWrapper: ViewModifier {
    var progress: Double
    var time: Double
    
    func body(content: Content) -> some View {
        content
            .visualEffect { content, geometryProxy in
                content.layerEffect(
                    ShaderLibrary.burnEffect(
                        .float2(geometryProxy.size.width, geometryProxy.size.height),
                        .float(progress),
                        .float(time)
                    ),
                    maxSampleOffset: .zero
                )
            }
    }
}

// --- PREVIEW ---
struct BurnEffectView: View {
    @State private var progress: Double = 1.0
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    // The Burning Card
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom))
                        .burnEffect(progress: progress)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    RoundedRectangle(cornerRadius: 24)
                        .stroke(lineWidth: 4)
                        .foregroundStyle(Color.label)
                }
                .rotationEffect(.degrees(180))
                .frame(width: 340, height: 500)
                
                
                //                Slider(value: $progress, in: 0...1)
                //                    .padding()
            }
            .onTapGesture {
                withAnimation(.snappy(duration: 7)) {
                    progress = 0.0
                }
            }
        }
        .overlay(alignment: .top) {
            Text("Tap to initiate the Burn")
                .font(.system(size: 17, weight: .medium))
                .padding(.top, 24)
        }
    }
}

#Preview {
    BurnEffectView()
}
