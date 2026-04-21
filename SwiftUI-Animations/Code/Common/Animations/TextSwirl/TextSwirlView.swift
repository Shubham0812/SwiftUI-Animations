//
//  TextSwirlView.swift
//  SwiftUI-Animations
//
//  Created by Shubham on 21/04/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

struct TextSwirlView: View {
    
    // MARK: - Variables
    @Namespace private var animation
    
    @State private var compactCircle: Bool = true
    @State private var angle: Angle = .zero
    @State private var keyword: String = "Batman"
    
    @State var animationCount: Int = 1
    
    @State var viewAppeared = false
    
    var words: [String] = "Hermione, Naruto, Gandalf, Vegeta, Gojo, Scarlet, Mickey, Donkey, Thanos, Panther, Yamcha, Beyoncé, Aladdin, Voldemort, Batman, Wolverine, Hawkeye, Rihanna, Optimus, Megatron, Bumblebee, Garfield, Groot, Itachi, Genie, Scarface, Mufasa, Merida, Stitch, Paddington, Simpsons, Simone, Harley, Poison, Maleficent, Cruella, Saitama, Zoroark, Arceus, Rorschach, Gambit, Mystique, Galactus, Grendel, Hellboy, Manhunter, Riddler, Aslan, Eeyore, Rapunzel, Flounder".components(separatedBy: ",")
    
    
    // MARK: - Views
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    let midX = Int(proxy.size.width / 2.0)
                    let midY = Int(proxy.size.height / 2.0)
                    ZStack {
                        Color.clear
                        ZStack {
                            Color.clear
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
    }
    
    
    // MARK: - Functions
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

struct RowView: View {
    
    // MARK: - Variables
    let word: String
    let width: CGFloat
    
    @Binding var isOpened: Bool
    @Binding var keyword: String
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
