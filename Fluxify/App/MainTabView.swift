//
//  MainTabView.swift
//  Fluxify
//
//  Created by TA638 on 26.01.26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    enum Tab {
        case einstellungen
        case favorite
        case home
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content view based on selected tab
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .favorite:
                    FavoriteView()
                case .einstellungen:
                    SettingsView()
                }
            }

            // Bottom Navigation Bar
            VStack(spacing: 0) {
                Divider()

                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "house.fill",
                        label: "Home",
                        isSelected: selectedTab == .home,
                        action: { selectedTab = .home }
                    )

                    Spacer()

                    TabBarButton(
                        icon: "heart.fill",
                        label: "Favorite",
                        isSelected: selectedTab == .favorite,
                        action: { selectedTab = .favorite }
                    )

                    Spacer()

                    TabBarButton(
                        icon: "gear",
                        label: "Einstellungen",
                        isSelected: selectedTab == .einstellungen,
                        action: { selectedTab = .einstellungen }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))

                Text(label)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}

#Preview {
    MainTabView()
}
