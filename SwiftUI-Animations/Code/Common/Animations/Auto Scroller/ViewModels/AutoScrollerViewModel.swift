//
//  AutoScrollerViewModel.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

/// Source of truth for the Auto Scroller carousel — owns the list of cards shown.
@Observable
class AutoScrollerViewModel {

    // MARK: - variables
    var cards: [WalletCard] = [
        WalletCard(cardNumber: "9094 5242 1231 2324", cardHolderName: "Shubham Singh", cardBank: .axis, security: "712", balance: 0, validity: "10/29", cardType: .credit, providerType: .mastercard, cardDesign: .metalBlack),
        WalletCard(cardNumber: "4123 5952 3912 5978", cardHolderName: "Shubham Singh", cardBank: .axis, security: "123", balance: 0, validity: "04/32", cardType: .credit, providerType: .mastercard, cardDesign: .metalWhite),
        WalletCard(cardNumber: "8923 2329 4023 4012", cardHolderName: "Shubham Singh", cardBank: .icici, security: "491", balance: 0, validity: "04/28", cardType: .credit, providerType: .mastercardLimited, cardDesign: .purple)
    ]
}
