//  FluxifyApp.swift
//  Fluxify
//
//  Starter scaffold – matches Figma screens
//

import SwiftUI
internal import Combine
@main
struct FluxifyApp: App {
    // 1. simple offline user state
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                Onboarding()
            }
        }
    }
}


struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("", systemImage: "house") }
        }
        
    }
    
}

