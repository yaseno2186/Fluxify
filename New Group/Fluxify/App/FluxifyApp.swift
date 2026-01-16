//  FluxifyApp.swift
//  Fluxify
//
//  Starter scaffold – matches Figma screens
//

import SwiftUI
import Combine

@main
struct FluxifyApp: App {
    // 1. simple offline user state
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                    AnyView(MainTabView())          // ← wrapped
            }
            .preferredColorScheme(.dark)
        }
    }
}


struct MainTabView: View {
    var body: some View {
 //       TabView {
 //           HomeView()
 //               .tabItem { Label("", systemImage: "house") }
 //           TipsListView()
 //               .tabItem { Label("", systemImage: "star") }
 //           SettingsView()
 //               .tabItem { Label("", systemImage: "gearshape")}
 //       }
    }
        
    }
