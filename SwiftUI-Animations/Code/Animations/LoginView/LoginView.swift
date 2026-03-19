//
//  LoginView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 24/10/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Layout descriptor for a single `ShrinkingPlus` particle in `LoginView`.
///
/// Each instance defines the position, color, animation timing, scale, and rotation
/// of one `+` symbol in the decorative background particle layer.
struct PlusPosition: Identifiable, Hashable {
    var id: Int
    /// Color of the `+` stroke — typically white or the gradient accent color.
    var color: Color

    /// Horizontal offset from the center of the login view.
    var offsetX: CGFloat
    /// Vertical offset from the center of the login view.
    var offsetY: CGFloat
    /// Stagger delay before this `+` begins its shrink animation.
    var delay: TimeInterval

    /// Scale of the `+` symbol in its visible state.
    var scale: CGFloat
    /// Opacity of the `+` symbol (allows dimmer particles for depth).
    var opacity: Double
    /// Rotation angle of the `+` symbol — typically ±43° for a tilted ✕ look.
    var degree: Angle
}


/// A multi-phase "Sign in with Facebook" login screen animation.
///
/// **On appear:** The login button slides up from below and a `Bolt` lightning icon draws itself in.
///
/// **On tap:**
/// 1. Button bounces (spring squeeze) then slides off-screen.
/// 2. A gradient arc circle traces around a profile image placeholder.
/// 3. After 3 s the profile image pops in (spring scale).
/// 4. After 6.5 s the view blurs, simulating a screen transition away.
///
/// Seven `ShrinkingPlus` particles float around the profile image as decorative background elements.
struct LoginView: View {

    // MARK: - Variables

    /// `true` after the view appears — triggers the Bolt draw-in animation.
    @State var viewAppeared: Bool = false
    /// Briefly `true` during button tap to trigger the spring squeeze animation.
    @State var bounceAnimation: Bool = false
    /// `true` after button is tapped — hides the button and starts the circle/profile sequence.
    @State var loginButtonPressed: Bool = false
    /// `true` after 3 s — reveals the profile image with a spring scale animation.
    @State var showProfileImage: Bool = false
    /// Swaps which circle tracker is visible when `rotateCircles()` starts.
    @State var switchCircles: Bool = false

    /// Rotation angle of the orbiting small circle dot around the profile ring.
    @State var circleTrackerDegree: Angle = .degrees(0)
    /// Trim start of the arc gradient around the profile image.
    @State var circleTrackStart: CGFloat = 0
    /// Trim end of the arc gradient — grows from 0 → 1 then collapses as the arc loops.
    @State var circleTrackEnd: CGFloat = 0
    /// Applied to the whole center ZStack at `t = 6.5 s` to signal a screen transition.
    @State var blurRadius: CGFloat = 0

    /// Height of the login button — 0 before appear/after tap, `9.5% × screenHeight` otherwise.
    @State var loginButtonHeight: CGFloat = 0
    /// Y-offset of the login button — starts at 24 (off-position), animates to 0 on appear.
    @State var loginButtonYOffset: CGFloat = 24

    /// Seven hardcoded `PlusPosition` descriptors placed around the profile image.
    var positions: [PlusPosition] = []
    /// Base duration shared by the circle arc and profile image animations.
    let animationDuration: TimeInterval = 0.75
    /// Pixel distance used to position the profile ZStack above center and the button below.
    let offsetDifference: CGFloat = 100

    /// Gradient used for the Bolt icon stroke and the profile arc.
    let gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.circleRoundStart, Color.circleRoundEnd]), startPoint: .leading, endPoint: .trailing)

    // MARK: - Initializers
    init() {
        positions = getRandomPositions()
    }

    // MARK: - Views
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
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
                                .foregroundStyle(.white)
                        }
                    }.scaleEffect(x: bounceAnimation ? 0.98 : 1, y: 1, anchor: .center)
                    .animation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1).delay(0.15), value: bounceAnimation)
                    .frame(height: loginButtonHeight)
                    .onTapGesture {
                        loginButtonPressed.toggle()

                        withAnimation(.spring(response: 0.25, dampingFraction: 0.85, blendDuration: 1).delay(0.15)) {
                            bounceAnimation.toggle()
                        }
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.85, blendDuration: 1)) {
                                bounceAnimation.toggle()
                            }
                            rotateCircles()

                            withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                                loginButtonHeight = 0
                                loginButtonYOffset = 24
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                            showProfileImage.toggle()
                        }

                        // Replace by view transition
                        Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false) { _ in
                            withAnimation(.default) {
                                blurRadius = 6
                            }
                        }
                    }
                }.offset(y: loginButtonYOffset)
                ZStack {
                    Triangle()
                        .fill(Color.circleRoundStart)
                        .cornerRadius(24)
                        .frame(width: 300, height: bounceAnimation ? 48 : 0, alignment: .center)
                        .offset(y: -4)
                        .animation(.spring(response: 0.35, dampingFraction: 0.75, blendDuration: 1).delay(0.05), value: bounceAnimation)
                    Circle()
                        .fill(Color.circleRoundStart)
                        .frame(width: loginButtonHeight > 0 ? 20 : 0)
                        .scaleEffect(loginButtonPressed ? 1 : 0.75)
                        .offset(y: loginButtonPressed ? -UIScreen.main.bounds.height * 0.31 - offsetDifference : 20)
                        .opacity(switchCircles ? 0 : 1)
                        .animation(.easeOut(duration: 0.3).delay(0.2), value: loginButtonPressed)
                }.offset(y: UIScreen.main.bounds.height / 2 - UIScreen.main.bounds.height * 0.09)
                ZStack {
                    Bolt()
                        .trim(from: 0, to: viewAppeared ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 4))
                        .scale(2)
                        .offset(y: offsetDifference)
                        .fill(gradient)
                        .animation(.easeOut(duration: 0.7), value: viewAppeared)
                    Text("Bolt")
                        .font(.system(size: 38, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.top, offsetDifference)
                }.opacity(loginButtonPressed ? 0 : 1)
                .animation(.easeOut(duration: 0.35), value: loginButtonPressed)
                ZStack {
                    ForEach(positions, id: \.self) { position in
                        ShrinkingPlus(position: position)
                            .offset(x: position.offsetX, y: position.offsetY)
                    }
                    Image("medium")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .scaleEffect(showProfileImage ? 1 : 0)
                        .animation(.spring(), value: showProfileImage)
                        .blur(radius: showProfileImage ? 0 : 3)
                        .animation(.spring().delay(animationDuration / 1.5), value: showProfileImage)
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
                        .opacity(switchCircles ? 1 : 0)

                    Text("Hello, Shubham")
                        .foregroundStyle(.white)
                        .font(.system(size: 30, weight: .semibold, design: .monospaced))
                        .padding(.top, 32)
                        .offset(y: offsetDifference * 1.25)
                        .opacity(showProfileImage ? 1 : 0)
                        .animation(.easeOut(duration: animationDuration).delay(animationDuration * 1.75), value: showProfileImage)
                }.offset(y: -offsetDifference)
                .blur(radius: blurRadius)
            }.ignoresSafeArea()
        }.onAppear {
            withAnimation(.easeIn(duration: 0.3)) {
                loginButtonHeight = UIScreen.main.bounds.height * 0.095
                loginButtonYOffset = 0
            }
            viewAppeared.toggle()
        }
    }

    // MARK: - Functions

    /// Starts the profile arc animation loop.
    ///
    /// Switches the visible circle tracker, begins `circleLines()`, then repeats
    /// every `animationDuration × 4` until `blurRadius == 6` (screen transition).
    func rotateCircles() {
        switchCircles.toggle()
        circleLines()
        Timer.scheduledTimer(withTimeInterval: animationDuration * 4, repeats: true) { rotationTimer in
            // stop and transition to a new view here
            if blurRadius == 6 {
                rotationTimer.invalidate()
                return
            }
            circleTrackStart = 0
            circleTrackEnd = 0
            circleTrackerDegree = .degrees(0)
            circleLines()
        }
    }

    /// Animates one arc cycle: grows `circleTrackEnd` from 0 → 1 while rotating the tracker dot,
    /// then after `animationDuration × 2` collapses `circleTrackStart` from 0 → 1 to erase the arc.
    func circleLines() {
        withAnimation(.easeIn(duration: animationDuration).delay(0.45)) {
            circleTrackerDegree = .degrees(360)
        }
        withAnimation(.easeIn(duration: animationDuration).delay(0.5)) {
            circleTrackEnd = 1
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2, repeats: false) { _ in
            withAnimation(.easeIn(duration: animationDuration).delay(0.25)) {
                circleTrackStart = 1
            }
            circleTrackerDegree = .degrees(0)
            withAnimation(.easeIn(duration: animationDuration).delay(0.25)) {
                circleTrackerDegree = .degrees(360)
            }
        }
    }

    /// Returns the seven hardcoded `PlusPosition` descriptors for the decorative `+` particles.
    ///
    /// Each position is hand-tuned with a unique color, scale, rotation, opacity, and delay
    /// so the particles appear organically scattered rather than evenly distributed.
    func getRandomPositions() -> [PlusPosition] {
        var positions = [PlusPosition]()
        positions.append(PlusPosition(id: 0, color: Color.white, offsetX: -92, offsetY: -100, delay: 0.2, scale: 0.8, opacity: 1, degree: .degrees(43)))
        positions.append(PlusPosition(id: 1, color: Color.white, offsetX: 72, offsetY: -100, delay: 0.1, scale: 0.5, opacity: 0.8, degree: .degrees(-43)))
        positions.append(PlusPosition(id: 2, color: Color.circleRoundEnd, offsetX: -42, offsetY: -50, delay: 0.225, scale: 0.5, opacity: 1, degree: .degrees(-43)))
        positions.append(PlusPosition(id: 3, color: Color.circleRoundEnd, offsetX: 110, offsetY: -20, delay: 0.135, scale: 0.25, opacity: 0.95, degree: .degrees(43)))
        positions.append(PlusPosition(id: 4, color: Color.white, offsetX: -130, offsetY: 82, delay: 0.075, scale: 1.1, opacity: 0.85, degree: .degrees(43)))
        positions.append(PlusPosition(id: 5, color: Color.white, offsetX: -150, offsetY: 32, delay: 0.15, scale: 0.3, opacity: 0.45, degree: .degrees(43)))
        positions.append(PlusPosition(id: 6, color: Color.circleRoundEnd, offsetX: 120, offsetY: 102, delay: 0.2, scale: 0.65, opacity: 0.85, degree: .degrees(43)))
        return positions
    }
}

#Preview {
    LoginView()
}
