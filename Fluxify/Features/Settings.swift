//
//  Settings.swift
//  Fluxify
//
//  Created by TA638 on 17.01.26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {

        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // Profil Header
                        VStack(spacing: 5) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color(.systemGray5))
                                .clipShape(Circle())

                            Text("Bobby Water")
                                .font(.title2)
                                .bold()

                            Text("bobby.water@")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(0.1), radius: 8)
                        .padding(.horizontal)

                        //Allgemein
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ALLGEMEIN")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading)

                            VStack(spacing: 0) {
                                settingsRow(
                                    icon: "person.fill",
                                    iconColor: .gray,
                                    title: "Profil",
                                    destination: ProfileView()
                                )

                                divider()

                                settingsRow(
                                    icon: "bell.fill",
                                    iconColor: .blue,
                                    title: "Benachrichtigung",
                                    destination: NotificationView()
                                )

                                divider()

                                settingsRow(
                                    icon: "bookmark.fill",
                                    iconColor: .orange,
                                    title: "Gespeichert",
                                    destination: SavedView()
                                )

                                divider()

                                settingsRow(
                                    icon: "key.fill",
                                    iconColor: .black,
                                    title: "Passwort",
                                    destination: PasswordView()
                                )
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                        }

                        // Über uns
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ÜBER UNS")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading)

                            VStack(spacing: 0) {
                                settingsRow(
                                    icon: "info.circle",
                                    iconColor: .black,
                                    title: "About Us",
                                    destination: AboutView()
                                )

                                divider()

                                HStack {
                                    Text("App Version")
                                    Spacer()
                                    Text("2.2")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Einstellungen")
        }
    }

    // Views

    func settingsRow<Destination: View>(
        icon: String,
        iconColor: Color,
        title: String,
        destination: Destination
    ) -> some View {

        NavigationLink {
            destination
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 30)

                Text(title)
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }

    func divider() -> some View {
        Divider()
            .padding(.leading, 50)
    }
}

#Preview {
    SettingsView()
}
