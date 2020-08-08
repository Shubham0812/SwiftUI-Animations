//
//  ChatBarView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 08/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct ChatBarView: View {
    
    // MARK:- variables
    @State var addAttachment: Bool = false
    @State var rotateBar: Bool = false
    @Binding var message: String
    
    var chatBarHeight: CGFloat = 86
    
    // MARK:- views
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            ZStack {
                Color.chatBackground
                HStack {
                    AttachmentButton(needsRotation: $rotateBar, iconName: "plus", iconSize: 24, action: {
                        self.rotateBar.toggle()
                        self.addAttachment.toggle()
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (Timer) in
                            self.addAttachment.toggle()
                        }
                    })
                    Spacer()
                    ZStack {
                        ZStack {
                            HStack(alignment: .center, spacing: 20) {
                                AttachmentButton(needsRotation: .constant(false), iconName: "camera", action: {})
                                AttachmentButton(needsRotation: .constant(false), iconName: "video.fill", action: {})
                                AttachmentButton(needsRotation: .constant(false), iconName: "rectangle.stack.person.crop", action: {})
                            }
                            .rotationEffect(!self.rotateBar ? .degrees(90) : .degrees(0), anchor: .zero)
                            .offset(y: !self.rotateBar ? 72 : 0)
                            .animation(Animation.spring())
                        }
                        ZStack {
                            TextField("Message", text: self.$message)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .disableAutocorrection(true)
                                .foregroundColor(Color.white)
                                .accentColor(Color.white)
                                .frame(height: 50)
                                .padding(.leading, 36)
                                .background(
                                    Color.buttonBackground.opacity(0.5)
                                        .cornerRadius(24)
                                        .padding(.leading)
                            )
                        }
                        .rotationEffect(self.rotateBar ? .degrees(-120) : .degrees(0), anchor: .zero)
                        .animation(Animation.spring())
                    }
                } .padding()
                    .padding([.leading, .trailing], 8)
            }
            .frame(height: self.chatBarHeight)
            .cornerRadius(self.chatBarHeight / 2)
            .padding()
            .padding([.leading, .trailing], 24)
            .shadow(radius: 10)
            .rotationEffect(self.getBarRotationDegree(), anchor: .leading)
            .animation(
                Animation.interpolatingSpring(mass: 2, stiffness: 14, damping: 10, initialVelocity: 5)
                    .delay(0.1)
            )
        }
    }
    
    func getBarRotationDegree() -> Angle {
        if (self.rotateBar && self.addAttachment) {
            return .degrees(-3)
        } else if (self.addAttachment) {
            return .degrees(3)
        } else {
            return .degrees(0)
        }
    }
}

struct ChatBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBarView(message: .constant(""))
    }
}
