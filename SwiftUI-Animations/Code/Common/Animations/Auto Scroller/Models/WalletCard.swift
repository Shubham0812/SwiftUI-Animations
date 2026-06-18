//
//  WalletCard.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 18/06/26.
//  Copyright © 2026 Shubham Singh. All rights reserved.
//

import SwiftUI

// MARK: - Usage
// Data model for a single card in the Auto Scroller carousel. `WalletCardDesign`
// selects one of the three styled card faces (metal black / metal white / purple)
// via `cardView()`. Renamed from the source `Card`/`CardDesign` to avoid clashing
// with the Bank Card and Cards Swap animations that already define those names.

enum WalletCardType: String {
    case credit = "Credit"
    case debit = "Debit"
}

struct WalletCard: Identifiable {

    enum CardProvider: String {
        case visa
        case mastercard
        case mastercardLimited
    }

    enum CardBank {
        case axis
        case icici
    }

    var id: String = UUID().uuidString

    let cardNumber: String
    let cardHolderName: String
    let cardBank: CardBank
    let security: String

    let balance: Double
    let validity: String

    let cardType: WalletCardType
    let providerType: CardProvider

    var cardDesign: WalletCardDesign

    var lastFour: String {
        let components = cardNumber.components(separatedBy: " ")
        return "\(components[components.count - 1])"
    }
}

enum WalletCardDesign: CaseIterable, Identifiable {
    var id: Self { self }

    case metalBlack
    case metalWhite
    case purple

    @ViewBuilder
    func cardView() -> some View {
        switch self {
        case .metalBlack:
            MetalCard()
        case .metalWhite:
            CardWhite()
        case .purple:
            PurpleCard()
        }
    }

    func needsDarkText() -> Bool {
        switch self {
        case .metalWhite:
            return true
        default:
            return false
        }
    }
}
