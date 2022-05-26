//
//  CardView.swift
//  Memorize
//
//  Created by Владимир Сухих on 27.08.2021.
//

//import SwiftUI
//
//struct CardView: View {
//    let card: MemoryGame<String>.Card
//
//    var body: some View{
//        GeometryReader { geometry in
//            let shape = Circle()
//            ZStack{
//                if card.isFaceUp{
//                        shape.fill().foregroundColor(.blue)
//                    Text(card.content).font(.system(size: min(geometry.size.width, geometry.size.height) * 0.6))
//                        shape.strokeBorder(lineWidth: 3)
//                } else if card.isMatched {
//                    shape.opacity(0)
//                } else {
//                    shape.fill().foregroundColor(.blue)
//                }
//            }
//        }
//    }
//}

