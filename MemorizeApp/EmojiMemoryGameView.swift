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
    
    var body: some View {
        VStack {
            cards
                .animation(.default, value: viewModel.cards)
            
            shuffleButton
        }
        .padding()
    }
    
    var cards: some View {
        GeometryReader { geometry in
            let widthThatFits = gridItemWidthThatFits(
                count: viewModel.cards.count,
                size: geometry.size,
                atAspectRatio: 2/3)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatFits), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
            .foregroundStyle(.orange)
        }
    }
    
    var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
        .buttonStyle(.borderedProminent)
        .font(.title2)
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
    
    struct CardView: View {
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
