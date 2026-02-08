

//
//  Particle.swift
//  MyApp
//
//  Created by Chingiz on 18.01.26.
//

import SwiftUI
import Combine



struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
}


struct ParticleBackground1: View {
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View{
        
        ZStack{
            Color(.white)
                .ignoresSafeArea()
            //SettingsView()
            
            
            ForEach(particles) {particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
            
            
            
        }    .onReceive(timer) { _ in
            createParticle()
            updateParticles()
        }
    }
    
    
    
    private func createParticle() {
        // 20% Chance pro Tick, dass ein Partikel erstellt wird
        if Int.random(in: 0...100) < 30 {
            let newParticle = Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -60
                ),
                color: [.blue, .purple, .white].randomElement()!,
                size: CGFloat.random(in: 2...8),
                speed: CGFloat.random(in: 1...3),
                opacity: 3.2
            )
            particles.append(newParticle)
        }
    }


    
    private func updateParticles() {
        particles = particles.compactMap({ particle in var updateParticles = particle
            updateParticles.position.y += updateParticles.speed
            updateParticles.opacity -= 0.01
            return updateParticles.opacity > 0 ? updateParticles : nil
        })
    }
    
}

#Preview {
    ParticleBackground1()
}
