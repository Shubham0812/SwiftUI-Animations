//
//  ShirtView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 05/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

enum ShirtState {
    case origin
    case top
    case end
    
    var scale: CGFloat {
        switch self {
        case .origin:
            return 0.2
        case .top:
            return 1
        case .end:
            return 0.5
        }
    }
    
    var opacity: Double {
        switch self {
        case .end:
            return 0
        default:
            return 1
        }
    }
}

struct ShirtView: View {
    @Binding var itemAdded: Bool
    
    @State var iconOffset: CGFloat = -12
    @State var changeShirtColor: Bool = false
    @State var shirtState: ShirtState = .origin
    
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            Image(self.changeShirtColor ? "shirt-black" : "shirt-white")
                .resizable()
                .frame(width: 27, height: 27)
                .scaleEffect(self.itemAdded ? self.shirtState.scale : 0.15)
                .animation(Animation.spring().speed(0.6))
                .offset(y: self.iconOffset)
                .animation(Animation.easeOut(duration: 0.35))
                .opacity(self.shirtState.opacity)
                .animation(Animation.default.delay(0.15))
                .onAppear() {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                        if (self.itemAdded) {
                            checkingTimer.invalidate()
                            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false) { (Timer) in
                                self.iconOffset = -120
                                self.shirtState = .top
                            }
                            Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false) { (Timer) in
                                self.changeShirtColor.toggle()
                                self.shirtState = .end
                            }
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                                self.iconOffset = -6
                            }
                        }
                    }
            }
        }
    }
}

struct ShirtView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
            ShirtView(itemAdded: .constant(false))
        }
    }
}
