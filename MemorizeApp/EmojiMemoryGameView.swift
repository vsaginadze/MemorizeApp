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
    
    let aspectRatio: CGFloat = 4/5
    let size = 200
    let minimumScaleFactor = 0.01
    let lineWidth = 2
    
    let colors: [String: Color] = [
        "Green": .green,
        "Orange": .orange,
        "Blue": .blue,
        "Gray": .gray,
        "Purple": .purple,
        "Red": .red
    ]
    
    
    var body: some View {
        VStack {
            header
            
            cards
                .animation(.default, value: viewModel.cards)
            
            footer
        }
        .padding()
    }
    
    private var footer: some View {
        HStack {
            newGameButton
            
            Spacer()
            
            shuffleButton
        }
    }
    
    private var header: some View {
        HStack {
            Text("\(viewModel.theme.name)")
                .font(.title2)
            Text(viewModel.theme.emojis[0])
                .font(.title)
            
            Spacer()
            
            Text("Score: \(viewModel.model.score)")
                .font(.title2)
        }
        .padding(.horizontal)
    }
    
    private var cards: some View {
        let color: Color = colors[viewModel.theme.color] ?? .green
        
        return AspectViewGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card, color)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        .foregroundStyle(color)
    }
    
    private var newGameButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 170, height: 50)
            
            Button {
                viewModel.startNewGame()
            } label: {
                Text("New Game")
                Image(systemName: "return")
            }
            .font(.title2)
            .foregroundStyle(.white)
        }
    }
    
    private var shuffleButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 125, height: 50)
            
            Button {
                withAnimation {
                    viewModel.shuffle()
                }
            } label: {
                Text("Shuffle")
                Image(systemName: "shuffle")
            }
            .font(.title2)
            .foregroundStyle(.white)
        }
    }
    
    private struct CardView: View {
        let card: Card
        let color: Color
        
        init(_ card: Card, _ color: Color) {
            self.card = card
            self.color = color
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
                    .fill(color)
                    .opacity(card.isFaceUp ? 0 : 1)
            }
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
        }
    }
}


#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
