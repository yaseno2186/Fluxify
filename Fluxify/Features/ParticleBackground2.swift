import SwiftUI
internal import Combine

struct ParticleBackground2: View {
    @State private var particles: [Particle2] = []
    
    // Timer für die Animation
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Color.white, Color(white: 0.97)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size)
                        .position(
                            x: particle.position.x + CGFloat(sin(Date().timeIntervalSince(particle.creationTime) * 1.2)) * particle.xOffset,
                            y: particle.position.y
                        )
                        .blur(radius: 1.2)
                        .opacity(particle.opacity)
                }
            }
            .onReceive(timer) { _ in
                updateAnimation(in: geometry.size)
            }
        }
    }
    
    // Animation
    
    private func updateAnimation(in size: CGSize) {
        createParticle(screenWidth: size.width)
        updateParticles(screenHeight: size.height)
    }
    
    private func createParticle(screenWidth: CGFloat) {
        if Int.random(in: 0...100) < 5 {
            let newParticle = Particle2(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: -30
                ),
                color: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.2),
                    Color.cyan.opacity(0.2),
                    Color.indigo.opacity(0.15)
                ].randomElement() ?? .blue.opacity(0.3),
                size: CGFloat.random(in: 5...15),
                speed: CGFloat.random(in: 0.6...1.4),
                opacity: 0.0,
                xOffset: CGFloat.random(in: 15...40),
                creationTime: Date()
            )
            particles.append(newParticle)
        }
    }
    
    private func updateParticles(screenHeight: CGFloat) {
        particles = particles.compactMap { particle in
            var p = particle
            p.position.y += p.speed
            
            if p.position.y < 120 {
                p.opacity = min(p.opacity + 0.015, 0.6)
            } else if p.position.y > screenHeight * 0.75 {
                p.opacity -= 0.004
            }
            
            if p.opacity > 0 && p.position.y < screenHeight + 40 {
                return p
            } else {
                return nil
            }
        }
    }
}


// struct Particle liegt schon in einer anderen Datei vor bei ParticleBackground1 deswegen habe ich es hier angepasst

struct Particle2: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
    var xOffset: CGFloat   // Fehlte
    var creationTime: Date // Fehlte
}

#Preview {
    ParticleBackground2()
}
