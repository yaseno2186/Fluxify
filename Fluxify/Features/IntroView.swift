//
//  IntroView.swift
//  Fluxify
//
//  Created by Senior Dev on 18.03.26.
//

import SwiftUI
internal import Combine

// MARK: - Intro View
struct IntroView: View {
    @Binding var isComplete: Bool
    
    // MARK: Animation States
    @State private var atomScale: CGFloat = 0.0
    @State private var titleOpacity: Double = 0.0
    @State private var subtitleOffset: CGFloat = 20.0
    @State private var buttonOffset: CGFloat = 100.0
    @State private var orbitRotation: Double = 0.0
    @State private var isAnimating: Bool = false
    
    // MARK: Timer
    private let orbitTimer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            backgroundLayer
            particleLayer
            contentLayer
        }
        .ignoresSafeArea()
        .onAppear(perform: startAnimationSequence)
        .onReceive(orbitTimer) { _ in
            guard isAnimating else { return }
            orbitRotation += 1.5
        }
    }
}

// MARK: - View Components
private extension IntroView {
    
    var backgroundLayer: some View {
        MeshGradientBackground()
    }
    
    var particleLayer: some View {
        ParticleField(isActive: $isAnimating)
            .opacity(0.6)
    }
    
    var contentLayer: some View {
        VStack(spacing: 40) {
            Spacer()
            
            AtomLogo(
                scale: atomScale,
                rotation: orbitRotation
            )
            .frame(height: 200)
            
            titleSection
            
            Spacer()
            
            actionSection
        }
        .padding(.bottom, 50)
    }
    
    var titleSection: some View {
        VStack(spacing: 12) {
            Text("Fluxify")
                .font(.system(size: 52, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .cyan.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(titleOpacity)
                .scaleEffect(0.8 + (titleOpacity * 0.2))
            
            Text("Physics made interactive")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .offset(y: subtitleOffset)
                .opacity(titleOpacity)
        }
    }
    
    var actionSection: some View {
        VStack(spacing: 16) {
            IntroActionButton(
                title: "Get Started",
                icon: "arrow.right",
                action: completeIntro
            )
            .offset(y: buttonOffset)
            
            Button(action: completeIntro) {
                Text("Skip")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .opacity(buttonOffset == 0 ? 1 : 0)
        }
    }
}

// MARK: - Animation Control
private extension IntroView {
    
    func startAnimationSequence() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            atomScale = 1.0
        }
        
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.8)) {
                titleOpacity = 1.0
                subtitleOffset = 0
            }
            SoundManager.instance.playSound(sound: .tada)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                buttonOffset = 0
            }
            isAnimating = true
        }
    }
    
    func completeIntro() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        SoundManager.instance.playSound(sound: .guitar)
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isComplete = true
        }
    }
}

// MARK: - Atom Logo Component
struct AtomLogo: View {
    let scale: CGFloat
    let rotation: Double
    
    var body: some View {
        ZStack {
            // Glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.cyan.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
            
            // Core
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.cyan, .blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .shadow(color: .cyan.opacity(0.8), radius: 20)
            
            // Orbits
            ForEach(0..<3) { index in
                ElectronOrbit(
                    index: index,
                    rotation: rotation,
                    radius: 70,
                    tilt: [0.0, 60.0, 120.0][index]
                )
            }
        }
        .scaleEffect(scale)
    }
}

// MARK: - Electron Orbit
struct ElectronOrbit: View {
    let index: Int
    let rotation: Double
    let radius: CGFloat
    let tilt: Double
    
    private var angle: Double {
        (rotation + Double(index * 120)) * .pi / 180
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 2)
                .frame(width: radius * 2, height: radius * 2)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .cyan],
                        center: .center,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 16, height: 16)
                .shadow(color: .cyan.opacity(0.8), radius: 10)
                .offset(
                    x: cos(angle) * radius,
                    y: sin(angle) * radius * 0.3
                )
        }
        .rotation3DEffect(.degrees(tilt), axis: (x: 1, y: 0, z: 0))
    }
}

// MARK: - Mesh Gradient Background
struct MeshGradientBackground: View {
    @State private var phase: Bool = false
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.1)) { _ in
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [Float(phase ? 0.8 : 0.2), Float(phase ? 0.2 : 0.8)], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ],
                colors: [
                    .purple.opacity(0.8), .blue.opacity(0.6), .cyan.opacity(0.8),
                    .indigo.opacity(0.9), .purple, .blue.opacity(0.9),
                    .black.opacity(0.8), .purple.opacity(0.7), .indigo.opacity(0.8)
                ]
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                phase.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Particle Field
struct ParticleField: View {
    @Binding var isActive: Bool
    @State private var particles: [IntroParticle] = []
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.016)) { _ in
            Canvas { context, size in
                for particle in particles {
                    let rect = CGRect(
                        x: particle.x,
                        y: particle.y,
                        width: particle.size,
                        height: particle.size
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particle.color.opacity(particle.opacity))
                    )
                }
            }
        }
        .onAppear {
            let bounds = UIScreen.main.bounds
            particles = (0..<25).map { _ in
                IntroParticle.random(in: bounds)
            }
        }
        .onChange(of: isActive) { _, active in
            if active {
                let center = CGPoint(
                    x: UIScreen.main.bounds.midX,
                    y: UIScreen.main.bounds.midY - 100
                )
                for i in particles.indices {
                    particles[i].burst(from: center)
                }
                withAnimation(.easeOut(duration: 2)) {
                    for i in particles.indices {
                        particles[i].opacity = 0
                    }
                }
            }
        }
    }
}

// MARK: - Particle Model
struct IntroParticle {
    var x: CGFloat
    var y: CGFloat
    var velocityX: CGFloat
    var velocityY: CGFloat
    var size: CGFloat
    var color: Color
    var opacity: Double
    
    static func random(in bounds: CGRect) -> IntroParticle {
        IntroParticle(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: 0...bounds.height),
            velocityX: CGFloat.random(in: -0.5...0.5),
            velocityY: CGFloat.random(in: -0.5...0.5),
            size: CGFloat.random(in: 2...6),
            color: [.cyan, .blue, .purple, .white].randomElement() ?? .cyan,
            opacity: Double.random(in: 0.3...0.7)
        )
    }
    
    mutating func burst(from center: CGPoint) {
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let speed = CGFloat.random(in: 2...5)
        x = center.x
        y = center.y
        velocityX = cos(angle) * speed
        velocityY = sin(angle) * speed
        size = CGFloat.random(in: 4...12)
        opacity = 1.0
    }
}

// MARK: - Intro Action Button
struct IntroActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.black)
            .frame(width: 280, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [.white, .cyan.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(
                        color: .cyan.opacity(0.5),
                        radius: isPressed ? 10 : 20,
                        x: 0,
                        y: isPressed ? 5 : 10
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

#Preview {
    IntroView(isComplete: .constant(false))
}
