

//
//  Particle.swift
//  MyApp
//
//  Created by Chingiz on 18.01.26.
//

import SwiftUI
internal import Combine

struct Particle1: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
}

struct ParticleBackground1: View {
    @State private var particles: [Particle1] = []
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // GeometryReader verhindert die Nutzung von UIScreen.main
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onReceive(timer) { _ in
                // Wir übergeben die aktuelle Größe an die Logik-Funktionen
                createParticle(in: geometry.size)
                updateParticles(in: geometry.size)
            }
        }
    }
    
    // MARK: - Logik
    
    private func createParticle(in size: CGSize) {
        // 30% Chance pro Tick
        if Int.random(in: 0...100) < 10 {
            let newParticle = Particle1(
                position: CGPoint(
                    // Nutzt die Breite aus der Geometrie statt UIScreen.main
                    x: CGFloat.random(in: 0...size.width),
                    y: -60
                ),
                color: [.blue, .purple, .cyan].randomElement() ?? .blue,
                size: CGFloat.random(in: 2...8),
                speed: CGFloat.random(in: 1...2),
                opacity: 4.0 // Start-Opacity korrigiert (3.2 war über dem Maximum von 1.0)
            )
            particles.append(newParticle)
        }
    }
    
    private func updateParticles(in size: CGSize) {
        particles = particles.compactMap { particle in
            var updated = particle
            updated.position.y += updated.speed
            updated.opacity -= 0.01
            
            // Entfernen, wenn unsichtbar oder weit aus dem Bild geflogen
            if updated.opacity > 0 && updated.position.y < size.height + 100 {
                return updated
            } else {
                return nil
            }
        }
    }
}

#Preview {
    ParticleBackground1()
}
