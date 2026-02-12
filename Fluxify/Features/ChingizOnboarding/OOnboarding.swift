//
//  Onboarding.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI


struct Onboarding: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userAge") var userAge: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    
    // Initialisiere den Manager hier
   
    
    private enum AppTab: Hashable { case home, settings }
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Tab 1: Home
            NavigationStack {
                HomeView()
                    // Falls HomeView eine Liste ist, ist dieser Modifikator hier richtig:
                    .scrollContentBackground(.hidden)
            }
            .tag(AppTab.home)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // Tab 2: Settings
            NavigationStack {
                SettingsView1(
                    userName: userName,
                    userEmail: userEmail,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
            }
            .tag(AppTab.settings)
            .tabItem {
                Label("Einstellungen", systemImage: "gear")
            }
        }
        // Das EnvironmentObject wird hier an den gesamten TabView-Baum weitergegeben
       
        
        // Onboarding-Overlay
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            // Stelle sicher, dass "OnboardingView" eine ANDERE View ist als "Onboarding"
            OnboardingView(
                shouldShowOnboarding: $shouldShowOnboarding,
                userName: $userName,
                userAge: $userAge,
                userEmail: $userEmail
            )
        }
    }
}

#Preview {
    Onboarding()
}
