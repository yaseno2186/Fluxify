//
//  SavedItemsView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI

// Hintergrund
struct AnimatedGradientBackground: View {
    let colors: [Color]
    
    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 1, y: 1)
    
    // Ein Zähler, um durch verschiedene Positionen zu schalten
    @State private var step = 0
    
    var body: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .ignoresSafeArea()
            .onAppear {
                // Wir starten eine Kette von Animationen
                animateMovement()
            }
    }
    
    func animateMovement() {
        // Dauer auf 10-12 Sekunden hochgesetzt -> sehr entspannt
        withAnimation(.easeInOut(duration: 10)) {
            switch step {
            case 0:
                start = UnitPoint(x: 1, y: -0.5)
                end = UnitPoint(x: 0, y: 1.5)
            case 1:
                start = UnitPoint(x: 1.5, y: 1)
                end = UnitPoint(x: -0.5, y: 0)
            case 2:
                start = UnitPoint(x: 0, y: 1.5)
                end = UnitPoint(x: 1, y: -0.5)
            default:
                start = UnitPoint(x: -0.5, y: 0)
                end = UnitPoint(x: 1.5, y: 1)
            }
        }
        
        // Nach Ablauf der Zeit rufen wir die Funktion wieder auf (Rekursion)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            step = (step + 1) % 4
            animateMovement()
        }
    }
}




#Preview {
    AnimatedGradientBackground(colors: [.purple, .red, .mint])
}
