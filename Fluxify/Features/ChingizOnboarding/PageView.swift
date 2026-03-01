//
//  PageView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//



import SwiftUI
internal import Combine
import Foundation

struct PageView: View {
    let text: String
    let subtitle: String
    let imageName: String
    // Steuert, ob der "Los geht's" Button angezeigt wird.
    let showDismissButton: Bool
    // Steuert, ob Eingabefelder angezeigt werden.
    let showInput: Bool
    // Optionaler Action-Handler für den "Weiter"-Button
    var nextAction: (() -> Void)? = nil
    
    @Binding var shouldShowOnboarding: Bool
    @Binding var userName: String
    @Binding var userAge: String
    @Binding var userEmail: String
    
    // Lokale Fehler-States für Validierung
    @State private var nameError: String?
    @State private var ageError: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
            
            Text(text).font(.largeTitle).bold().foregroundColor(.black)
            Text(subtitle).font(.body).multilineTextAlignment(.center).padding(.horizontal).foregroundColor(.black.opacity(0.8))
            
            if showInput {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Dein Name", text: $userName)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(nameError != nil ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .onChange(of: userName) { _, newValue in
                                if newValue.rangeOfCharacter(from: .decimalDigits) != nil {
                                    nameError = "Der Name darf keine Zahlen enthalten."
                                } else {
                                    nameError = nil
                                }
                            }
                        if let error = nameError {
                            Text(error).font(.caption).foregroundColor(.red).padding(.leading, 5)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Dein Alter", text: $userAge)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ageError != nil ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .onChange(of: userAge) { _, newValue in
                                if !newValue.allSatisfy({ $0.isNumber }) {
                                    ageError = "Das Alter darf nur Zahlen enthalten."
                                } else {
                                    ageError = nil
                                }
                            }
                        if let error = ageError {
                            Text(error).font(.caption).foregroundColor(.red).padding(.leading, 5)
                        }
                    }
                    
                    TextField("Deine E-Mail", text: $userEmail)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                    
                    // Weiter-Button
                    Button(action: {
                        nextAction?()
                    }) {
                        Text("Weiter")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .frame(maxWidth: 300)
                .foregroundColor(.black)
            }
            
            if showDismissButton {
                Button(action: {
                    // Hier wird das Cover geschlossen
                    withAnimation(.easeInOut) {
                        shouldShowOnboarding = false
                    }
                }) {
                    Text("Los geht's")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.top, 20)
            }
        }
        .padding()
    }
}
