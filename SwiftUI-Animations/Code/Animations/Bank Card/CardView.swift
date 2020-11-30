//
//  CardView.swift
//  SwiftUI-Animations
//
//  Created by Shubham Singh on 29/11/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    // MARK:- variables
    let animationDuration: TimeInterval = 0.3
    let displayWidth: CGFloat = UIScreen.main.bounds.width * 0.85
    
    @State var card: Card
    
    @State var cardFlipped: Bool = false
    @State var userCards: [Card] = []
    
    @State var UIState: UIStateModel
    @State var cardBalance: Double = 0
    @State var selectedIndex: Int = 0
    
    // MARK:- views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Balance")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Text("₹\(cardBalance.clean(places: 2))")
                            .font(.system(size: 24, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .animation(Animation.spring())
                    }
                    Spacer()
                }.padding()
                Text(self.cardFlipped ? "Tap on the card again to flip it back" : "Tap on the card to view the security code")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(32)
                    .animation(.default)
                Canvas() {
                    Carousel(numberOfItems: CGFloat(userCards.count), spacing: 0, widthOfHiddenCards: 0) {
                        ForEach(userCards) { card in
                            Item(_id: card.id, spacing: 0, widthOfHiddenCards: 0, cardWidth: displayWidth, selectedIndex: .constant(1)) {
                                ZStack {
                                    CardFrontView(width: displayWidth, card: card)
                                        .rotation3DEffect(.degrees(firstViewDegree), axis: (x: 0, y: firstViewYAxis, z: 0), anchor: firstViewAnchor, anchorZ: 0, perspective: perspective)
                                        .offset(x: firstViewOffset)
                                        .onTapGesture {
                                            self.cardFlipped.toggle()
                                            withAnimation(Animation.easeInOut(duration: animationDuration)) {
                                                self.setValuesOnState(rotation1: .finalTrailing, rotation2: .finalLeading)
                                            }
                                        }
                                    CardBackView(width: displayWidth, card: card)
                                        .rotation3DEffect(.degrees(secondViewDegree), axis: (x: 0, y: secondViewYAxis, z: 0), anchor: secondViewAnchor, anchorZ: 0, perspective: perspective)
                                        .offset(x: secondViewOffset)
                                        .onTapGesture {
                                            self.cardFlipped.toggle()
                                            withAnimation(Animation.easeInOut(duration: animationDuration)) {
                                                self.setValuesOnState(rotation1: .initialTrailing, rotation2: .initialLeading)
                                            }
                                        }
                                }.padding(.top, 12)
                            }
                            .transition(AnyTransition.slide)
                            .animation(.spring())
                        }
                    }
                    .environmentObject( self.UIState )
                }
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        Text("@Shubham_iosdev")
                            .foregroundColor(.white)
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .opacity(0.3)
                    }.padding(.trailing, 16)
                }
            }.padding()
            .onAppear() {
                self.userCards = AppConstants.cards
                self.cardBalance = Double(userCards[selectedIndex].balance) ?? 0
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    if (self.UIState.activeCard != selectedIndex) {
                        self.selectedIndex = self.UIState.activeCard
                        guard let balance = Double(userCards[selectedIndex].balance) else { return }
                        self.cardBalance = balance
                    }
                }
            }
        }
    }
    
    // Rotations // Trailpoints
    let perspective: CGFloat = 1
    @State var firstViewDegree: Double = CardState.initialTrailing.rotationValues.0
    @State var firstViewOffset: CGFloat = CardState.initialTrailing.rotationValues.1
    @State var firstViewAnchor: UnitPoint = CardState.initialTrailing.rotationValues.2
    @State var firstViewYAxis: CGFloat = CardState.initialTrailing.rotationValues.3
    
    @State var secondViewDegree:Double = CardState.initialLeading.rotationValues.0
    @State var secondViewOffset:CGFloat = CardState.initialLeading.rotationValues.1
    @State var secondViewAnchor: UnitPoint = CardState.initialLeading.rotationValues.2
    @State var secondViewYAxis: CGFloat = CardState.initialLeading.rotationValues.3
    
    // MARK:- functions
    func setValuesOnState(rotation1: CardState, rotation2: CardState) {
        self.firstViewDegree = rotation1.rotationValues.0
        self.firstViewOffset = rotation1.rotationValues.1
        self.firstViewAnchor = rotation1.rotationValues.2
        self.firstViewYAxis = rotation1.rotationValues.3
        
        self.secondViewDegree = rotation2.rotationValues.0
        self.secondViewOffset = rotation2.rotationValues.1
        self.secondViewAnchor = rotation2.rotationValues.2
        self.secondViewYAxis = rotation2.rotationValues.3
    }
    
    enum CardState: CaseIterable {
        case initialLeading
        case finalLeading
        case initialTrailing
        case finalTrailing
        
        
        // Degree, Offset, Anchor, Axis
        var rotationValues: (Double, CGFloat, UnitPoint, CGFloat) {
            switch self {
            case .initialLeading:
                return (90, UIScreen.main.bounds.width * 0.85, UnitPoint.leading, 0.1)
            case .finalLeading:
                return (0, 0, UnitPoint.leading, 1)
            case .initialTrailing:
                return (0, 0,UnitPoint.trailing, -1)
            case .finalTrailing:
                return (180, -UIScreen.main.bounds.width * 0.85 ,UnitPoint.trailing, -1)
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: AppConstants.cards[0], UIState: UIStateModel())
    }
}
