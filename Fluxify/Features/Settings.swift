import SwiftUI

struct SettingsView: View {
    var body: some View {

        NavigationStack {
            ZStack {
                CosmicBackgroundView()
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
                                    iconColor: .white,
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
                            
                                .padding(.horizontal)
                        }
                    

                        //Über uns
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ÜBER UNS")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.leading)

                            VStack(spacing: 0) {
                                settingsRow(
                                    icon: "info.circle",
                                    iconColor: .white,
                                    title: "Über uns",
                                    destination: AboutView()
                                )

                                divider()
                                    
                                .padding()
                            }
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.5), radius: 5)
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("")
            .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Einstellungen")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
        }
    }

    //Helper Views

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
                    .foregroundColor(.white)
                    .font(.system(size: 25))

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }

    func divider() -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 1)
            .padding(.leading, 0)
    }
}



#Preview {
    SettingsView()
    
}
//
// .navigationtitle
// toolbar
