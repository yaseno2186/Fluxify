//
//  ProfileDataView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI

struct ProfileDetailView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userEmail") var userEmail: String = ""

    @State private var editingField: String?
    @FocusState private var focusedField: String?

    // Holds the loaded user from BackendService
    @State private var user: User?
    // Draft for username edits before saving
    @State private var draftUsername: String = ""
    @State private var isUpdatingUsername: Bool = false
    @State private var updateMessage: String?

    var body: some View {
        Form {
            Section(header: Text("Benutzerdaten"), footer: Text("Doppeltippen, um Daten zu ändern.")) {
                // Name
                if editingField == "name" {
                    TextField("Name", text: $userName)
                        .focused($focusedField, equals: "name")
                        .onSubmit { editingField = nil }
                } else {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(userName.isEmpty ? "Nicht angegeben" : userName)
                            .foregroundColor(userName.isEmpty ? .gray : .primary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        editingField = "name"
                        focusedField = "name"
                    }
                }

                // E-Mail
                if editingField == "email" {
                    TextField("E-Mail", text: $userEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: "email")
                        .onSubmit { editingField = nil }
                } else {
                    HStack {
                        Text("E-Mail")
                        Spacer()
                        Text(userEmail.isEmpty ? "Nicht angegeben" : userEmail)
                            .foregroundColor(userEmail.isEmpty ? .gray : .primary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        editingField = "email"
                        focusedField = "email"
                    }
                }
            }

            // Username section — loaded from BackendService
            if let user = user {
                Section(header: Text("Benutzername"), footer: Text("Doppeltippen, um Benutzernamen zu ändern.")) {
                    if editingField == "username" {
                        HStack {
                            TextField("Benutzername", text: $draftUsername)
                                .focused($focusedField, equals: "username")
                                .onSubmit { saveUsername() }
                            if isUpdatingUsername {
                                ProgressView()
                            }
                        }
                    } else {
                        HStack {
                            Text("Benutzername")
                            Spacer()
                            Text(user.username)
                                .foregroundColor(.primary)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture(count: 2) {
                            draftUsername = user.username
                            editingField = "username"
                            focusedField = "username"
                        }
                    }

                    if let message = updateMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Profil")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Fertig") {
                    if editingField == "username" {
                        saveUsername()
                    }
                    focusedField = nil
                    editingField = nil
                }
            }
        }
        .onAppear {
            loadUserProfile()
        }
    }

    // MARK: - Backend

    private func loadUserProfile() {
        BackendService.shared.fetchUserProfile { fetchedUser in
            self.user = fetchedUser
        }
    }

    private func saveUsername() {
        guard !draftUsername.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isUpdatingUsername = true
        BackendService.shared.updateUsername(draftUsername) { success in
            isUpdatingUsername = false
            if success {
                user?.username = draftUsername
                updateMessage = "Benutzername erfolgreich aktualisiert."
            } else {
                updateMessage = "Aktualisierung fehlgeschlagen. Bitte erneut versuchen."
            }
            editingField = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                updateMessage = nil
            }
        }
    }
}

#Preview {
    ProfileDetailView()
}
