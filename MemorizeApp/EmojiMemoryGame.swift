//
//  EmojiMemoryGame.swift
//  MemorizeApp
//
//  Created by Vakhtang Saginadze on 13.02.2024.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private let numberOfPairsOfCards = 10
    private let themes = ["Nature", "Food", "Weather", "Animal", "Travel", "Celebration"]
    
    init() {
        theme = Theme(name: themes.randomElement() ?? "Nature", numberOfPairsOfCards: numberOfPairsOfCards)
        model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
        shuffle()
    }
    
    private static func createMemoryGame(withTheme theme: Theme) -> MemoryGame<String> {
        MemoryGame(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            if theme.emojis.indices.contains(pairIndex) {
                return theme.emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published var model: MemoryGame<String>
    var theme: Theme
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: Intents
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func startNewGame() {
        let themeName = themes.randomElement() ?? "Nature"
        print(themeName)
        theme = Theme(name: themeName, numberOfPairsOfCards: numberOfPairsOfCards)
        model = EmojiMemoryGame.createMemoryGame(withTheme: theme)
        shuffle()
    }
}
