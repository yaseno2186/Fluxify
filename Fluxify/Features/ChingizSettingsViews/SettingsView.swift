import SwiftUI

struct SettingsView1: View {
    @Binding var shouldShowOnboarding: Bool

    @State private var showLogoutAlert = false
    @State private var user: User? = nil
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ZStack {
          //      ParticleBackground2()
          //          .ignoresSafeArea()

                if isLoading {
                    ProgressView("Laden...")
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 30) {

                            // Header Bereich
                            VStack(spacing: 15) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.black)

                                VStack(spacing: 4) {
                                    Text(user?.name ?? "Gast")
                                        .font(.title).bold()

                                    if let email = user?.email, !email.isEmpty {
                                        Text(email)
                                            .font(.subheadline).foregroundColor(.secondary)
                                    }
                                    Text("Das ist deine Startseite.")
                                        .font(.subheadline).foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)

                            // SEKTION: ALLGEMEINES
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Allgemeines")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)

                                VStack(spacing: 12) {
                                    SettingRow(icon: "person.fill", title: "Profil", destination: AnyView(ProfileDetailView()))
                                    SettingRow(icon: "bell.fill", title: "Benachrichtigung", destination: AnyView(NotificationSettingsView()))
                                }
                            }

                            // SEKTION: ÜBER UNS
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Über Uns")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)

                                VStack(spacing: 12) {
                                    SettingRow(icon: "info.circle.fill", title: "Über uns", destination: AnyView(AAboutUsView()))
                                    SettingRow(icon: "hand.raised.fill", title: "Kontakt aufnehmen", destination: AnyView(ContactView()))
                                }
                            }

                            // SEKTION: KONTO / AKTIONEN
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Konto")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 5)

                                Button(action: {
                                    showLogoutAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .font(.system(size: 20))
                                            .frame(width: 30)

                                        Text("Abmelden")
                                            .font(.system(size: 18, weight: .bold))

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .foregroundColor(.red)
                                    .background(Color(UIColor.systemGray4).opacity(0.8))
                                    .cornerRadius(12)
                                }
                                .alert("Abmelden", isPresented: $showLogoutAlert) {
                                    Button("Abbrechen", role: .cancel) { }
                                    Button("Abmelden", role: .destructive) {
                                        BackendService.shared.logout {
                                            shouldShowOnboarding = true
                                        }
                                    }
                                } message: {
                                    Text("Möchtest du dich wirklich abmelden?")
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                    }
                    .background(Color.clear)
                }
            }
            .navigationTitle("Einstellungen")
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                BackendService.shared.fetchUserProfile { fetchedUser in
                    self.user = fetchedUser
                    self.isLoading = false
                }
            }
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 30)

                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(UIColor.systemGray4).opacity(0.8))
            .cornerRadius(12)
        }
    }
}

#Preview {
    SettingsView1(shouldShowOnboarding: .constant(false))
}
