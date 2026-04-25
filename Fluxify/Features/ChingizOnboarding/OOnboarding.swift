//
//  Onboarding.swift
//  Fluxify
//
//  Created by Chingiz
//

import SwiftUI

struct Onboarding: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userAge") var userAge: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    
    @State private var selectedTab: AppTab = .home
    @Namespace private var animation
    @StateObject private var tabBarVisibility = TabBarVisibility.shared
    
    private enum AppTab: String, CaseIterable {
        case home = "house.fill"
        case funfacts = "lightbulb.fill"
        case settings = "gear"
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .funfacts: return "Fun Facts"
            case .settings: return "Einstellungen"
            }
        }
        
        var color: Color {
            switch self {
            case .home: return .blue
            case .funfacts: return .yellow
            case .settings: return .gray
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // MARK: - Content Bereich
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView()
                            .scrollContentBackground(.hidden)
                    }
                case .settings:
                    NavigationStack {
                        SettingsView1(
                            userName: userName,
                            userEmail: userEmail,
                            shouldShowOnboarding: $shouldShowOnboarding
                        )
                    }
                case .funfacts:
                    NavigationStack {
                        FunFactsView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // MARK: - Custom TabBar
            HStack(spacing: 8) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.rawValue)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                                .frame(width: 80, height: 50)
                                .background(
                                    ZStack {
                                        if selectedTab == tab {
                                            Capsule()
                                                .fill(tab.color)
                                                .matchedGeometryEffect(id: "bubble", in: animation)
                                        }
                                    }
                                )
                            
                            if selectedTab == tab {
                                Text(tab.title)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(tab.color)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.bottom, -20)
            .opacity(tabBarVisibility.isVisible ? 1 : 0)
            .offset(y: tabBarVisibility.isVisible ? 0 : 120)
            .animation(.easeInOut(duration: 0.3), value: tabBarVisibility.isVisible)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        // Onboarding-Overlay
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
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
