//
//  OnboardingViews.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//


import SwiftUI
internal import Combine
import Foundation


struct OnboardingView: View {
    // Bindings zu den Werten in der Haupt-View (Onboarding struct).
    @Binding var shouldShowOnboarding: Bool
    @Binding var userName: String
    @Binding var userAge: String
    @Binding var userEmail: String
    // Lokaler State für die aktuelle Seite im TabView.
    @State private var selectedPage = 0
    
    var body: some View {
        ZStack {
            AnimatedGradientBackground(colors: [.blue.opacity(0.8), .purple.opacity(0.5)])
                .ignoresSafeArea()
            
            VStack {
                // Fortschrittsbalken basierend auf der aktuellen Seite.
                ProgressView(value: Double(selectedPage + 1), total: 4)
                    .progressViewStyle(LinearProgressViewStyle(tint: .black))
                    .padding(.horizontal, 40)
                    .padding(.top, 60)
                
                // TabView als Pager (Swipe-Navigation).
                TabView(selection: $selectedPage) {
                    PageView(text: "Willkommen", subtitle: "Entdecke Fluxify.", imageName: "sparkles", showDismissButton: false, showInput: false, shouldShowOnboarding: $shouldShowOnboarding, userName: $userName, userAge: $userAge, userEmail: $userEmail).tag(0)
                    
                    PageView(text: "Lerne", subtitle: "Interaktive Simulationen.", imageName: "atom", showDismissButton: false, showInput: false, shouldShowOnboarding: $shouldShowOnboarding, userName: $userName, userAge: $userAge, userEmail: $userEmail).tag(1)
                    
                    PageView(text: "Deine Daten", subtitle: "Erzähl uns etwas über dich.", imageName: "person.fill.badge.plus", showDismissButton: false, showInput: true, nextAction: {
                        withAnimation { selectedPage += 1 }
                    }, shouldShowOnboarding: $shouldShowOnboarding, userName: $userName, userAge: $userAge, userEmail: $userEmail).tag(2)
                    
                    PageView(text: "Alles bereit!", subtitle: "Starte jetzt deine Reise.", imageName: "paperplane.fill", showDismissButton: true, showInput: false, shouldShowOnboarding: $shouldShowOnboarding, userName: $userName, userAge: $userAge, userEmail: $userEmail).tag(3)
                }
                // Versteckt die Standard-Punkte unten, da wir oben eine ProgressView haben.
                // Warum .tabViewStyle(.page)? Das macht aus der TabView (normalerweise Tabs unten)
                // einen "Pager", durch den man seitlich wischen kann (wie bei einem Buch oder Tutorial).
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}
