//
//  Cardify.swift
//  Memorize
//
//  Created by Владимир Сухих on 23.09.2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {
        
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double //in degrees
    
    func body(content: Content) -> some View {
        let shape = Circle()
        ZStack{
            if rotation < 90 {
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(.blue)
            } else {
                shape.fill().foregroundColor(.blue)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (0, 1, 0)
        )
    }
    
    private struct DrawingConstants {
        static let lineWidth: CGFloat = 5
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
