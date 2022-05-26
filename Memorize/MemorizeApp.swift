//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Владимир Сухих on 27.08.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            MainView(ViewModel: game)
        }
    }
}
