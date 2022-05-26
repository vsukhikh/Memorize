//
//  MemoryGame.swift
//  Memorize
//
//  Created by Владимир Сухих on 30.08.2021.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOnlyAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
//            Тоже самое, что и наверху
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
        }
        set {
            cards.indices.forEach({cards[$0].isFaceUp = ($0 == newValue)})
//            for index in cards.indices {
//                if index != newValue {
//                    cards[index].isFaceUp = false
//                } else {
//                    cards[index].isFaceUp = true
//                }
//            }
        }
    }

    
    mutating func choose(_ card: Card) {
        if  let choozenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[choozenIndex].isFaceUp, !cards[choozenIndex].isMatched {
            
            if let potencialMatchIndex = indexOfTheOnlyAndOnlyFaceUpCard {
                if cards[potencialMatchIndex].content == cards[choozenIndex].content {
                    cards[choozenIndex].isMatched = true
                    cards[potencialMatchIndex].isMatched = true
                }
                cards[choozenIndex].isFaceUp = true
            } else {
                indexOfTheOnlyAndOnlyFaceUpCard = choozenIndex
            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable  {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int
    
        
        
        
        
    //MARK: - Bonis Time
        
    //  this could give matching bonus points
    //  if the user matches the cards
    //  before a certain amount of time passes during which the card is face up
        
    //  Can be zero which means "No bonus available" for his card
        var bonusTimeLimit: TimeInterval = 6
        
    //    How long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
    //  the last time the card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}


extension Array {
    var oneAndOnly: Element?{
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
