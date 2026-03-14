//
//  GameOverView.swift
//  Fluxify
//
//  Created by Yass on 14.03.26.
//
import SwiftUI

struct GameOverView: View {
    let score: Int
    let totalQuestions: Int
    let onRetry: () -> Void
    let onHome: () -> Void
    
    @State private var showAnimation = false
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Red gradient background for failure
            LinearGradient(
                colors: [.red.opacity(0.4), Color(UIColor.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Broken heart animation
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.red, .red.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                        .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "heart.slash.fill")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(showAnimation ? 1 : 0)
                        .rotationEffect(.degrees(showAnimation ? 0 : 45))
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showAnimation)
                }
                .padding(.bottom, 30)
                
                // Game Over text
                Text("Game Over!")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.red)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
                
                // Score
                Text("Score: \(score)/\(totalQuestions)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: showContent)
                
                // Message
                Text("Du hast alle Herzen verloren. Versuche es erneut!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: showContent)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Retry button
                    Button(action: onRetry) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Erneut versuchen")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.red)
                        )
                    }
                    
                    // Home button
                    Button(action: onHome) {
                        HStack(spacing: 8) {
                            Image(systemName: "house")
                            Text("Zurück zur Startseite")
                                .font(.subheadline)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemGroupedBackground))
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.6), value: showContent)
            }
        }
        .onAppear {
            withAnimation {
                showAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showContent = true
            }
        }
    }
}

#Preview {
    GameOverView(
        score: 2,
        totalQuestions: 8,
        onRetry: {},
        onHome: {}
    )
}
