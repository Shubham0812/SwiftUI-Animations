//
//  TextSwirlView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 21/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// TextSwirlView arranges a list of `words` around a circle and animates them
// into a chaotic "swirl" when tapped, highlighting a randomly-selected keyword
// in the center. Tap anywhere to swirl, and use the top-right reset button to
// return to the neat circular layout.
//
// To customise: pass / override `words` with your own strings. The central
// `keyword` is picked at random from that list. `matchedGeometryEffect` drives
// the smooth transition between the "compact circle" and "scattered" states.
struct TextSwirlView: View {
    
    // MARK: - Variables
    // Shared namespace used by `matchedGeometryEffect` so each word animates
    // smoothly between its circular slot and its scattered position.
    @Namespace private var animation
    
    // `true` when words are laid out in a neat circle; `false` when scattered.
    @State private var compactCircle: Bool = true
    // Rotation applied to the entire word ring for extra motion.
    @State private var angle: Angle = .zero
    // The word shown in the center; updates on each swirl interaction.
    @State private var keyword: String = "Batman"
    
    // Incremented on reset to drive the toolbar icon's symbol effect.
    @State var animationCount: Int = 1
    
    // Gate the initial fade/rotate-in animation after the view appears.
    @State var viewAppeared = false
    
    // Source list of words rendered around the ring. Override to customise.
    var words: [String] = "Hermione, Naruto, Gandalf, Vegeta, Gojo, Scarlet, Mickey, Donkey, Thanos, Panther, Yamcha, Beyoncé, Aladdin, Voldemort, Batman, Wolverine, Hawkeye, Rihanna, Optimus, Megatron, Bumblebee, Garfield, Groot, Itachi, Genie, Scarface, Mufasa, Merida, Stitch, Paddington, Simpsons, Simone, Harley, Poison, Maleficent, Cruella, Saitama, Zoroark, Arceus, Rorschach, Gambit, Mystique, Galactus, Grendel, Hellboy, Manhunter, Riddler, Aslan, Eeyore, Rapunzel, Flounder".components(separatedBy: ",")
    
    
    // MARK: - Views
    var body: some View {
        ZStack {
            // GeometryReader gives us container size so we can clamp the
            // ring radius to the smaller of width/height and keep it
            // centered via `midX` / `midY` offsets.
            GeometryReader { proxy in
                let midX = Int(proxy.size.width / 2.0)
                let midY = Int(proxy.size.height / 2.0)
                ZStack {
                    Color.clear
                    ZStack {
                        Color.clear
                        // Render each word in one of two layouts:
                        //  - compact circle: evenly rotated around center
                        //  - scattered:     random offsets + rotation
                        // `matchedGeometryEffect` interpolates between them.
                        ForEach(Array(self.words.enumerated()), id: \.offset) { index, word in
                            if compactCircle {
                                RowView(word: word, width: CGFloat(min(midX, midY)), isOpened: $compactCircle, keyword: $keyword, viewAppeared: $viewAppeared)
                                    .matchedGeometryEffect(id: index, in: animation)
                                    .frame(width: min(proxy.size.width, proxy.size.height))
                                    .foregroundColor(index % 2 == 0 ? Color.label.opacity(0.4) : Color.blue)
                                    .rotationEffect(.degrees(Double(index) / Double(self.words.count)) * 360)
                                    .rotationEffect(viewAppeared ? .zero : .degrees(45))
                                    .opacity(viewAppeared ? 1 : 0)
                            } else {
                                let opacity = CGFloat.random(in: 0.2...1.0)
                                RowView(word: word, width: CGFloat(min(midX, midY)), isOpened: $compactCircle, keyword: $keyword, viewAppeared: $viewAppeared)
                                    .matchedGeometryEffect(id: index, in: animation)
                                    .frame(width: min(proxy.size.width, proxy.size.height))
                                    .foregroundColor(index % 2 == 0 ? Color.label.opacity(0.4) : Color.blue)
                                    .rotationEffect(Angle(degrees: CGFloat(Int.random(in: 0...270))))
                                    .offset(x: CGFloat(Int.random(in: -midX...midX)),
                                            y: CGFloat(Int.random(in: -midY...midY)))
                                    .scaleEffect(index % 2 == 0 ? opacity * 3.0 : opacity * 5.0)
                                    .opacity(opacity)
                            }
                        }
                        .rotationEffect(angle)
                        
                        Text(keyword)
                            .font(ClashGrotestk.semibold.font(size: 24))
                            .contentTransition(.numericText())
                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 0)
                            .animation(.easeInOut(duration: 0.24), value: keyword)
                    }
                }
                .offset(y: -40)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if #available(iOS 18.0, *) {
                    Image(systemName: "arrow.counterclockwise")
                        .symbolEffect(.rotate.counterClockwise, value: animationCount)
                        .onTapGesture {
                            reset()
                        }
                } else {
                    Image(systemName: "arrow.counterclockwise")
                        .onTapGesture {
                            reset()
                        }
                }
            }
        }
        .contentShape(Rectangle())
        // Tap to trigger the swirl: scatter the words, pick a fresh
        // center keyword, and slowly rotate the ring for extra motion.
        .onTapGesture {
            withAnimation(.bouncy(duration: 2.0)) {
                compactCircle = false
                keyword = self.words[Int.random(in: 0..<self.words.count)]
            }
            withAnimation(.easeInOut(duration: 3.0)) {
                angle = Angle(degrees: CGFloat(Int.random(in: 0...270)))
            }
        }
        .onAppear() {
            withAnimation(.smooth(duration: 1)) {
                viewAppeared.toggle()
            }
        }
        .padding()
    }
    
    
    // MARK: - Functions
    // Return the words to the neat circular layout and nudge the ring to a
    // new angle. `animationCount` drives the toolbar symbol effect.
    func reset() {
        withAnimation(.snappy(duration: 2.0)) {
            compactCircle = true
            animationCount += 1
        }
        
        withAnimation(.easeInOut(duration: 0.25)) {
            angle = Angle(degrees: CGFloat(Int.random(in: 0...180)))
        }
    }
    
    
    
    private func getCircularValue(_ current: Double, _ total: Double) -> CGFloat {
        let x = Double(current) / Double(total)
        let y = (sin(-1 * .pi * x - (.pi / 1)) + 1) / 2.0
        return y
    }
    
    private func getFontSize(_ proxy: GeometryProxy) -> CGFloat {
        return proxy.size.width / 3 * 0.1
    }
}

// A single "spoke" on the ring: a word, a line, and a dot. The word's opacity
// changes when it matches the current `keyword`, giving a subtle highlight.
struct RowView: View {
    
    // MARK: - Variables
    let word: String
    let width: CGFloat
    
    // Bound to the parent's `compactCircle` so appearance tracks layout state.
    @Binding var isOpened: Bool
    // The currently highlighted word in the center.
    @Binding var keyword: String
    // Gates the initial fade-in of the word text.
    @Binding var viewAppeared: Bool
    
    // MARK: - Views
    var body: some View {
        HStack {
            Text(word)
                .font(ClashGrotestk.medium.font(size: 14))
                .fixedSize()
                .opacity(!isOpened ? (keyword == word && !isOpened ? 1 : 0.7) : 1)
                .animation(.smooth, value: keyword)
                .opacity(viewAppeared ? 1 : 0)
            
            Rectangle()
                .frame(width: width, height: 1)
                .opacity(!isOpened ? 0.2 : 0.25)
            
            Circle()
                .frame(width: 5, height: 5)
                .offset(x: -3)
                .opacity(!isOpened ? 0.2 : 0.8)
                .animation(.smooth, value: isOpened)
            
            Spacer()
        }
    }
}

#Preview {
    TextSwirlView()
}
