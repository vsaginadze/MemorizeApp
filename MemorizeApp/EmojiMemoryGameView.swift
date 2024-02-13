//
//  ContentView.swift
//  MemorizeApp
//
//  Created by Vakhtang Saginadze on 13.02.2024.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    @ObservedObject var viewModel: EmojiMemoryGame
    let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            cards
                .animation(.default, value: viewModel.cards)
            
            shuffleButton
        }
        .padding()
    }
    
    private var cards: some View {
        AspectViewGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundStyle(.orange)
    }

    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
        .buttonStyle(.borderedProminent)
        .font(.title2)
    }
    
    private struct CardView: View {
        let card: Card
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                
                Group {
                    base.fill(.white)
                    base.stroke(lineWidth: 2)
                    
                    Text(card.content)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                }
                .opacity(card.isFaceUp ? 1 : 0)
                
                base
                    .fill(.orange)
                    .opacity(card.isFaceUp ? 0 : 1)
            }
        }
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
