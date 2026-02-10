//
//  ProfileDataView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//


import SwiftUI

struct ProfileDetailView: View {
    // Greift auf dieselben gespeicherten Daten zu wie die Haupt-View.
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userAge") var userAge: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    
    // State für das aktuell bearbeitete Feld
    @State private var editingField: String?
    // FocusState für automatischen Fokus beim Bearbeiten
    @FocusState private var focusedField: String?
    
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
                
                // Alter
                if editingField == "age" {
                    TextField("Alter", text: $userAge)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: "age")
                        .onSubmit { editingField = nil }
                } else {
                    HStack {
                        Text("Alter")
                        Spacer()
                        Text(userAge.isEmpty ? "Nicht angegeben" : userAge)
                            .foregroundColor(userAge.isEmpty ? .gray : .primary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        editingField = "age"
                        focusedField = "age"
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
        }
        .navigationTitle("Profil")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Fertig") {
                    focusedField = nil
                    editingField = nil
                }
            }
        }
    }
}
