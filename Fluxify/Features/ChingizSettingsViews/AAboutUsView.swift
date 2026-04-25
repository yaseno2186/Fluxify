//
//  AAboutUsView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//
import SwiftUI

struct AAboutUsView: View {
    @State private var contentTextSize: CGFloat = 20
    @StateObject private var tabBarVisibility = TabBarVisibility.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                VorwortSection(contentTextSize: contentTextSize)
                NaturwissenschaftenSection(contentTextSize: contentTextSize)
                FluxifyMissionSection(contentTextSize: contentTextSize)
                VisionSection(contentTextSize: contentTextSize)
                ZitatSection()
            }
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("About Us")
        .onAppear {
            tabBarVisibility.isVisible = false
        }
        .onDisappear {
            tabBarVisibility.isVisible = true
        }
    }
}

private struct VorwortSection: View {
    let contentTextSize: CGFloat
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Vorwort")
                .font(.system(size: contentTextSize))
                .fontWeight(.light)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 8) {
                Text("„Ich habe keine besondere Begabung, sondern bin nur leidenschaftlich neugierig\"")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .italic()

                Text("Albert Einstein")
                    .font(.body)
                    .italic()
                    .foregroundColor(.gray)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 20)
        }
    }
}

private struct NaturwissenschaftenSection: View {
    let contentTextSize: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            TornPaperShape()
                .fill(Color.orange.opacity(0.7))
                .frame(width: 200, height: 200)
                .overlay(
                    Text("Naturwissenschaften begegnen uns jeden Tag, doch oft bleibt unklar, wie sie eigentlich funktionieren.")
                        .font(.system(size: contentTextSize))
                        .foregroundColor(.black)
                        .padding(16)
                        .fixedSize(horizontal: false, vertical: true)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

            VulkanView()
        }
        .padding(.horizontal, 20)
    }
}

private struct VulkanView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.05))
                .frame(width: 115, height: 115)

            VStack(spacing: 0) {
                Circle()
                    .fill(Color.orange.opacity(0.8))
                    .frame(width: 49, height: 33)
                    .offset(y: 10)

                Triangle()
                    .fill(Color.red.opacity(0.8))
                    .frame(width: 39, height: 33)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.blue.opacity(0.6))
                    .frame(width: 71, height: 9)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 60, height: 38)
            }
        }
    }
}

private struct FluxifyMissionSection: View {
    let contentTextSize: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            GluehbirneView()
                .frame(width: 115, height: 130)

            TornPaperShape()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 230, height: 260)
                .overlay(
                    Text("Fluxify wurde genau aus diesem Grund entwickelt: um die natürliche Neugier von Kindern und Jugendlichen aufzugreifen und sie in echtes Verständnis zu verwandeln.")
                        .font(.system(size: contentTextSize))
                        .foregroundColor(.black)
                        .padding(16)
                        .fixedSize(horizontal: false, vertical: true)
                )
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
}

private struct GluehbirneView: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                .frame(width: 95, height: 95)

            VStack(spacing: 2) {
                Circle()
                    .fill(Color.yellow.opacity(0.3))
                    .frame(width: 39, height: 39)

                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 16, height: 9)

                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 20, height: 7)
            }

            HStack(spacing: -8) {
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 20, height: 20)
                    .offset(y: 22)
                Capsule()
                    .fill(Color.blue.opacity(0.8))
                    .frame(width: 24, height: 30)
                    .offset(y: 35)

                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 20, height: 20)
                    .offset(y: 22)
                Capsule()
                    .fill(Color.orange.opacity(0.8))
                    .frame(width: 24, height: 30)
                    .offset(y: 35)
            }
            .offset(y: 10)
        }
    }
}

private struct VisionSection: View {
    let contentTextSize: CGFloat
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Unsere Vision")
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(.gray)

            VisionCircles()
                .frame(height: 140)

            VStack(spacing: 16) {
                TornPaperShape()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 300, height: 200)
                    .overlay(
                        Text("Fluxify verbindet wissenschaftliche Inhalte mit Animationen, Simulationen und interaktiven Modellen.")
                            .font(.system(size: contentTextSize))
                            .foregroundColor(.black)
                            .padding(16)
                            .fixedSize(horizontal: false, vertical: true)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

                TornPaperShape()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 300, height: 250)
                    .overlay(
                        Text("Nutzerinnen und Nutzer können selbst erforschen, wie Alltagsgeräte funktionieren, wie physikalische Prozesse ablaufen oder welche naturwissenschaftlichen Konzepte dahinterstehen.")
                            .font(.system(size: contentTextSize))
                            .foregroundColor(.black)
                            .padding(16)
                            .fixedSize(horizontal: false, vertical: true)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct VisionCircles: View {
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            // Statische Ringe
            ForEach(0..<4) { i in
                Circle()
                    .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 85 + CGFloat(i * 25), height: 85 + CGFloat(i * 25))
            }
            
            // Fester Mittelpunkt
            Circle()
                .fill(Color.green.opacity(0.6))
                .frame(width: 22, height: 22)
            
            // Pulsierender Kreis (radial nach außen)
            Circle()
                .stroke(Color.green, lineWidth: 2.5)
                .frame(width: 22, height: 22)
                .scaleEffect(pulse ? 7.2 : 1.0)
                .opacity(pulse ? 0 : 0.7)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 4.0).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

private struct ZitatSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("„See your world through science\"")
                .font(.system(size: 40))
                .italic()

            Text("Yass, Bahinaz, Kamila, Chingiz")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
        }
        .padding(.bottom, 32)
    }
}

// MARK: - Shapes

struct TornPaperShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height

        path.move(to: CGPoint(x: 0, y: 8))

        let step: CGFloat = 20
        var x: CGFloat = 0
        var toggle = true

        while x < w {
            x = min(x + step, w)
            path.addLine(to: CGPoint(x: x, y: toggle ? 6 : 10))
            toggle.toggle()
        }

        path.addLine(to: CGPoint(x: w, y: h - 8))

        x = w
        toggle = true
        while x > 0 {
            x = max(x - step, 0)
            path.addLine(to: CGPoint(x: x, y: toggle ? h - 6 : h - 10))
            toggle.toggle()
        }

        path.closeSubpath()
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    AAboutUsView()
}
