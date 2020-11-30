//
//  CardFrontView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CardFrontView: View {
    
    // MARK:- variables
    let width: CGFloat
    
    let ratioConstant: CGFloat = 1.593
    let visaRatio: CGFloat = 2.095
    
    var card: Card
    
    @State var rotationAngle: Double = 0
    
    // MARK:- views
    var body: some View {
        ZStack {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                LinearGradient(gradient: Gradient(colors: [card.cardPalatte.colorOne, card.cardPalatte.colorTwo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay(
                        ZStack {
                            Circle()
                                .frame(width: 400)
                                .offset(x: 180, y: -10)
                                .opacity(0.05)
                                .rotationEffect(.degrees(-40))
                            CardPatternOneView()
                                .opacity(0.075)
                                .offset(x: -width * 0.3)
                                .scaleEffect(1.4)
                                .rotationEffect(.degrees(-27.5))
                        }
                    )
                    .animation(Animation.easeOut(duration: 0.3))
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(card.cardType.rawValue) Card")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.white)
                        Spacer()
                        ZStack {
                            Image("axis")
                                .resizable()
                        }.frame(width: 34, height: 34)
                        
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text(card.cardNumber)
                            .font(.system(size: width * 0.065, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white)
                            .offset(y: 15)
                            .frame(minHeight: 29)
                            .animation(Animation.default)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("VALID THRU")
                            .font(.system(size: 09, weight: .semibold, design: .monospaced))
                            .foregroundColor(Color.white.opacity(0.6))
                        Text(card.validity)
                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                            .foregroundColor(Color.white)
                    }.offset(y: 8)
                    HStack {
                        Text(card.cardHolderName)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .textCase(.uppercase)
                            .foregroundColor(Color.white)
                        Spacer()
                            Image("visa")
                                .resizable()
                                .frame(width: 72, height: 72 / visaRatio)
                    }
                }.padding()
                .shadow(radius: 5)
            }
        }
        .cornerRadius(20)
        .frame(width: width, height: width / ratioConstant)
        .rotation3DEffect(
            .degrees(rotationAngle),
            axis: (x: 1.0, y: 0, z: 0.0)
        )
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CardFrontView(width: 370, card: AppConstants.cards[0])
        }    }
}
