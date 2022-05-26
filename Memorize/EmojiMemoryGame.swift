//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Vladimir Sukhikh on 30.08.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias game = MemoryGame<String>
    
    private static let emojis = ["💋","😍","😘","🐶","🦷", "💄","👩🏻‍🎤","💦","🍌","🧁","🎺","🚁","🏩","💿","🩸","🦠","📕","🅰️","🚾","🔔","🏳️"]
    
    private static func createMemoryGame() -> game {
        game(numberOfPairsOfCards: 6) {pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private(set) var model = createMemoryGame()
    
    
    // MARK: - Intent(s)
    
    func choose(_ card: game.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
    

