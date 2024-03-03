//
//  MemoryGame.swift
//  MemorizeApp
//
//  Created by Vakhtang Saginadze on 13.02.2024.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    
    init(numberOfPairsOfCards: Int, contentFactory: (Int) -> CardContent) {
        cards = []
        for idx in 0..<numberOfPairsOfCards {
            let content = contentFactory(idx)
            cards.append(Card(content: content, id: "\(idx)a"))
            cards.append(Card(content: content, id: "\(idx)b"))
        }
    }
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
            get { cards.indices.filter { idx in cards[idx].isFaceUp }.only }
            set { cards.indices.forEach { idx in cards[idx].isFaceUp = (idx == newValue) } }
        }
        
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        
                        score += 2 + cards[chosenIndex].bonus
                        + cards[potentialMatchIndex].bonus
                                    
                    } else {
                        if (cards[chosenIndex].hasBeenSeen ||
                            cards[potentialMatchIndex].hasBeenSeen
                        ) {
                            score -= 1
                        }
                    }
                } else {
                    indexOfOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Identifiable, Equatable, CustomDebugStringConvertible {
        let content: CardContent
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var hasBeenSeen: Bool = false
        
        var id: String
        var debugDescription: String {
             """
            __\(id): \(content) \(isFaceUp ? "up" : "down")
            \(isMatched ? "matched" : "not fucking matched")__
            """
        }
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

struct Theme {
    let name: String
    let emojis: [String]
    let numberOfPairsOfCards: Int
    let color: String
    
    private let themes: [String: [String]] = [
        "Nature": ["🌿", "🌻", "🌺", "🌳", "🌼", "🌸", "🍃", "🌷", "🌹", "🍀", "🌱", "🏵️", "💐", "🥀", "🌾", "🌷"], // Nature Theme
        "Food": ["🍔", "🍕", "🍟", "🥗", "🍦", "🍩", "🍪", "🍫", "🥤", "🍹", "🍭", "🍬", "🥪", "🍔", "🍟"], // Food Theme
        "Weather": ["🌞", "🌧️", "❄️", "⛈️", "🌈", "🌤️", "🌪️", "🌊", "🌫️", "🌨️", "🌦️", "🌥️", "🌬️", "🌪️", "🌩️"], // Weather Theme
        "Animal": ["🐶", "🐱", "🐰", "🐼", "🐵", "🐨", "🦁", "🐯", "🐮", "🐷", "🐸", "🐙", "🐢", "🐍", "🐳"], // Animal Theme
        "Travel": ["✈️", "🚗", "🚢", "🚀", "🚲", "🚁", "🚂", "🏍️", "🚒", "🚎", "🛵", "🚆", "🛳️", "🚤"], // Travel Theme
        "Celebration": ["🎉", "🎊", "🎈", "🎂", "🎁", "🎀", "🎇", "🎆", "🎄", "🎍", "🎏", "🎃", "🎐", "🎑"] // Celebration Theme
    ]
    
    private let colors: [String: String] = [
        "Nature": "Green",
        "Food": "Orange",
        "Weather": "Blue",
        "Animal": "Gray",
        "Travel": "Purple",
        "Celebration": "Red"
    ]
    
    init(name: String, numberOfPairsOfCards: Int) {
        self.name = name
        self.numberOfPairsOfCards = numberOfPairsOfCards
        
        if let emojis = themes[self.name] {
            if numberOfPairsOfCards < emojis.count {
                self.emojis = emojis.shuffled()
            } else {
                self.emojis = emojis
            }
        } else {
            self.emojis = themes["Nature"]!
        }
        
        self.color = colors[self.name] ?? "Green"
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
