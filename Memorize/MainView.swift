//
//  MainView.swift
//  Memorize
//
//  Created by Владимир Сухих on 27.08.2021.
//

import SwiftUI

struct MainView: View {
    var ViewModel: EmojiMemoryGame
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmojiMemoryGameView(game: ViewModel)) {Text("Emoji")} 
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        MainView(ViewModel: game).preferredColorScheme(.dark).previewDevice("iPhone 12 Pro")
    }
}
