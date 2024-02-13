//
//  MemorizeAppApp.swift
//  MemorizeApp
//
//  Created by Vakhtang Saginadze on 13.02.2024.
//

import SwiftUI

@main
struct MemorizeAppApp: App {
    @StateObject var game: EmojiMemoryGame = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
