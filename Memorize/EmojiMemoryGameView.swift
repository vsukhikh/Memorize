//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Владимир Сухих on 27.08.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    shuffle
                    deckBody
                    restart
                }
                .frame(height: 40, alignment: .center)
                .padding()
            }
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.game.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.game.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.game.Card) -> Animation {
        var delay = 0.0
        if let index = game.model.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (1.0 / Double(game.model.cards.count))
        }
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.game.Card) -> Double {
        -Double(game.model.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.model.cards, aspectRatio: 1/1) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .zIndex(zIndex(of: card))
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
                }
            }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach (game.model.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .identity))
            }
        }
        .foregroundColor(.blue)
        .onTapGesture {
            for card in game.model.cards {
                withAnimation(dealAnimation(for: card )) {
                    deal(card)
                }
            }
        }
    }
    
    
    var shuffle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 40.0)
                .onTapGesture {
                    withAnimation {
                        game.shuffle()
                    }
                }
                .foregroundColor(.blue)
            Text("Shuffle!")
                .multilineTextAlignment(.center)
                .scaledToFit()
        }
    }
    
    @State private var isPressed = false
    var restart: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 40.0)
                .onTapGesture {
                        isPressed = true
                }
                .foregroundColor(.blue)
            Text("Restart")
                .multilineTextAlignment(.center)
                .scaledToFit()
        }
        .alert(isPresented: $isPressed) {
            Alert(
                title: Text("Are you sure?"),
                primaryButton: .default(Text("Yes"), action: {
                    withAnimation {
                        dealt = []
                        game.restart()
                    }
                  }),
                secondaryButton: .destructive(Text("Cancel")))
        }
    }
}



struct CardView: View {
    let card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View{
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining) * 360 - 90))
                            .onAppear(){
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining) * 360 - 90))
                    }
                }
                    .frame(width: geometry.size.width * DrawingConstants.littleCircle, height: geometry.size.height * DrawingConstants.littleCircle, alignment: .center)
                    .opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1))
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let littleCircle: CGFloat = 0.7
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 100
    }
}

