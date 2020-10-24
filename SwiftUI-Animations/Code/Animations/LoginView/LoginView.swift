//
//  LoginView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct PlusPosition: Identifiable, Hashable {
    var id: Int
    var color: Color
    
    var offsetX: CGFloat
    var offsetY: CGFloat
    var delay: TimeInterval
    
    var scale: CGFloat
    var opacity: Double
    var degree: Angle
}


struct LoginView: View {
    
    // MARK:- variables
    @State var viewAppeared: Bool = false
    @State var bounceAnimation: Bool = false
    @State var loginButtonPressed: Bool = false
    @State var showProfileImage: Bool = false
    @State var switchCircles: Bool = false
    
    @State var circleTrackerDegree: Angle = Angle.degrees(0)
    @State var circleTrackStart: CGFloat = 0
    @State var circleTrackEnd: CGFloat = 0
    @State var blurRadius: CGFloat = 0
    
    @State var loginButtonHeight: CGFloat = 0
    @State var loginButtonYOffset: CGFloat = 24
    
    
    var positions: [PlusPosition] = []
    let animationDuration: TimeInterval = 0.75
    let offsetDifference: CGFloat = 100
    
    let gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.circleRoundStart, Color.circleRoundEnd]), startPoint: .leading, endPoint: .trailing)
    
    // MARK:- initializers
    init() {
        self.positions = self.getRandomPositions()
    }
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .fill(Color.circleRoundStart)
                        HStack {
                            Image("face")
                                .frame(width: 28, height: 28)
                                .scaleEffect(0.8)
                            Text("Sign in with Facebook")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(Color.white)
                        }
                    }.scaleEffect(x: self.bounceAnimation ? 0.98 : 1, y: 1, anchor: .center)
                    .frame(height: loginButtonHeight)
                    .onTapGesture {
                        self.loginButtonPressed.toggle()
                        
                        withAnimation(Animation.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1).delay(0.15)) {
                            self.bounceAnimation.toggle()
                        }
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                            withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.85, blendDuration: 1)) {
                                self.bounceAnimation.toggle()
                            }
                            rotateCircles()
                            
                            withAnimation(Animation.easeIn(duration: 0.3).delay(0.2)) {
                                self.loginButtonHeight = 0
                                self.loginButtonYOffset = 24
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                            self.showProfileImage.toggle()
                        }
                        
                        // Replace by view transition
                        Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false) { _ in
                            withAnimation(Animation.default) {
                                self.blurRadius = 6
                            }
                        }
                    }
                }.offset(y: loginButtonYOffset)
                ZStack {
                    Triangle()
                        .fill(Color.circleRoundStart)
                        .cornerRadius(24)
                        .frame(width: 300, height: self.bounceAnimation ? 48 : 0, alignment: .center)
                        .offset(y: -4)
                        .animation(Animation.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 1)
                                    .delay(0.05))
                    Circle()
                        .fill(Color.circleRoundStart)
                        .frame(width: self.loginButtonHeight > 0 ? 20 : 0 )
                        .scaleEffect(self.loginButtonPressed ? 1 : 0.75)
                        .offset(y:  self.loginButtonPressed ? -UIScreen.main.bounds.height * 0.31 - offsetDifference : 20)
                        .opacity(self.switchCircles ? 0 : 1)
                        .animation(Animation.easeOut(duration: 0.3).delay(0.2))
                }.offset(y: UIScreen.main.bounds.height / 2 - UIScreen.main.bounds.height * 0.09)
                ZStack {
                    Bolt()
                        .trim(from: 0, to: viewAppeared ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 4))
                        .scale(2)
                        .offset(y: offsetDifference)
                        .fill(gradient)
                        .animation(Animation.easeOut(duration: 0.7))
                    Text("Bolt")
                        .font(.system(size: 38, weight: .semibold, design: .monospaced))
                        .foregroundColor(Color.white)
                        .padding(.top, offsetDifference)
                }.opacity(loginButtonPressed ? 0 : 1)
                .animation(Animation.easeOut(duration: 0.35))
                ZStack {
                    ForEach(positions, id: \.self) { position in
                        ShrinkingPlus(position: position)
                            .offset(x: position.offsetX, y: position.offsetY)
                    }
                    Image("medium")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .scaleEffect(self.showProfileImage ? 1 : 0)
                        .animation(Animation.spring())
                        .blur(radius: self.showProfileImage ? 0 : 3)
                        .animation(Animation.spring().delay(animationDuration / 1.5))
                        .mask(Circle()
                                .frame(width: 160, height: 160)
                                .shadow(color: .white, radius: 5)
                        )
                    Circle()
                        .trim(from: circleTrackStart, to: circleTrackEnd)
                        .rotation(.degrees(90))
                        .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .fill(gradient)
                        .frame(width: 185, height: 185)
                    
                    Circle()
                        .fill(Color.circleRoundStart)
                        .frame(width: 20)
                        .offset(y: 90)
                        .rotationEffect(circleTrackerDegree)
                        .opacity(self.switchCircles ? 1 : 0)
                    
                    Text("Hello, Shubham")
                        .foregroundColor(Color.white)
                        .font(.system(size: 30, weight: .semibold, design: .monospaced))
                        .padding(.top, 32)
                        .offset(y: offsetDifference * 1.25)
                        .opacity(self.showProfileImage ? 1 : 0)
                        .animation(Animation.easeOut(duration: animationDuration).delay(animationDuration * 1.75))
                }.offset(y: -offsetDifference)
                .blur(radius: self.blurRadius)
            }.edgesIgnoringSafeArea(.all)
        }.onAppear() {
            withAnimation(Animation.easeIn(duration: 0.3)) {
                self.loginButtonHeight = UIScreen.main.bounds.height * 0.095
                self.loginButtonYOffset = 0
            }
            self.viewAppeared.toggle()
        }
    }
    
    // MARK:- functions
    func rotateCircles() {
        self.switchCircles.toggle()
        circleLines()
        Timer.scheduledTimer(withTimeInterval: animationDuration * 4, repeats: true) { rotationTimer in
            // stop and transition to a new view here
            if (self.blurRadius == 6) {
                rotationTimer.invalidate()
                return
            }
            self.circleTrackStart = 0
            self.circleTrackEnd = 0
            self.circleTrackerDegree = .degrees(0)
            circleLines()
        }
    }
    
    func circleLines() {
        withAnimation(Animation.easeIn(duration: animationDuration).delay(0.45)) {
            self.circleTrackerDegree = .degrees(360)
        }
        withAnimation(Animation.easeIn(duration: animationDuration).delay(0.5)) {
            self.circleTrackEnd = 1
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2, repeats: false) { _ in
            withAnimation(Animation.easeIn(duration: animationDuration).delay(0.25)) {
                self.circleTrackStart = 1
            }
            self.circleTrackerDegree = .degrees(0)
            withAnimation(Animation.easeIn(duration: animationDuration).delay(0.25)) {
                self.circleTrackerDegree = .degrees(360)
            }
        }
    }
    
    func getRandomPositions() -> [PlusPosition] {
        var positions = [PlusPosition]()
        positions.append(PlusPosition(id: 0, color: Color.white, offsetX: -92, offsetY: -100, delay: 0.2, scale: 0.8, opacity: 1, degree: Angle(degrees: 43)))
        positions.append(PlusPosition(id: 1, color: Color.white, offsetX: 72, offsetY: -100, delay: 0.1, scale: 0.5, opacity: 0.8, degree: Angle(degrees: -43)))
        positions.append(PlusPosition(id: 2, color: Color.circleRoundEnd, offsetX: -42, offsetY: -50, delay: 0.225, scale: 0.5, opacity: 1, degree: Angle(degrees: -43)))
        positions.append(PlusPosition(id: 3, color: Color.circleRoundEnd, offsetX: 110, offsetY: -20, delay: 0.135, scale: 0.25, opacity: 0.95, degree: Angle(degrees: 43)))
        positions.append(PlusPosition(id: 4, color: Color.white, offsetX: -130, offsetY: 82, delay: 0.075, scale: 1.1, opacity: 0.85, degree: Angle(degrees: 43)))
        positions.append(PlusPosition(id: 5, color: Color.white, offsetX: -150, offsetY: 32, delay: 0.15, scale: 0.3, opacity: 0.45, degree: Angle(degrees: 43)))
        positions.append(PlusPosition(id: 6, color: Color.circleRoundEnd, offsetX: 120, offsetY: 102, delay: 0.2, scale: 0.65, opacity: 0.85, degree: Angle(degrees: 43)))
        
        
        return positions
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
