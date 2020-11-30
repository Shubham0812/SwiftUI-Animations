//
//  DummyData.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct AppConstants {
    static var cards = [
        Card(id: 0, cardNumber: "4231 5161 3694 2135", cardHolderName: "Shubham Singh", security: "137", balance: "32134.35", validity: "05/24", cardPalatte: palattes[0], cardType: .debit),
        Card(id: 2, cardNumber: "3512 6909 1223 1960", cardHolderName: "Shubham Singh", security: "819", balance: "7424.12", validity: "12/20", cardPalatte: palattes[1], cardType: .debit),
        Card(id: 3, cardNumber: "8656 1457 5421 8900", cardHolderName: "Shubham Singh", security: "591", balance: "51236.69", validity: "05/22", cardPalatte: palattes[2], cardType: .credit),
    ]
    
    static var palattes: [CardPalatte] = [
        CardPalatte(colorOne: Color(hex: "fbc2eb"), colorTwo: Color(hex: "a6c1ee")),
        CardPalatte(colorOne: Color(hex: "43cea2"), colorTwo: Color(hex: "185a9d")),
        CardPalatte(colorOne: Color(hex: "fa709a"), colorTwo: Color(hex: "fee140"))
    ]
}
