//
//  ContactView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI

struct ContactView: View {
    // Daten aus dem Profil laden (AppStorage nutzt die auf dem Handy gespeicherten Werte)
    @AppStorage("userName") var storedUserName: String = "Gast"
    @AppStorage("userEmail") var storedUserEmail: String = "Nicht hinterlegt"
    
    @State private var subject: String = ""
    @State private var message: String = ""
    @State private var isSending: Bool = false
    @State private var showSuccessAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                // --- ABSENDER INFORMATION ---
                VStack(alignment: .leading, spacing: 8) {
                    Text("Absender")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(storedUserName)
                                .font(.system(size: 16, weight: .bold))
                            Text(storedUserEmail)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("Profil-Daten")
                            .font(.caption2)
                            .padding(5)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(5)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                }

                // --- FORMULAR ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Deine Nachricht")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    VStack(spacing: 15) {
                        TextField("Betreff", text: $subject)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                        
                        TextEditor(text: $message)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .overlay(alignment: .topLeading) {
                                if message.isEmpty {
                                    Text("Wie können wir helfen?")
                                        .foregroundColor(.gray.opacity(0.5))
                                        .padding(12)
                                }
                            }
                        
                        Button(action: sendMessage) {
                            HStack {
                                if isSending {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Nachricht senden")
                                    Image(systemName: "paperplane.fill")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(subject.isEmpty || message.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(subject.isEmpty || message.isEmpty || isSending)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray4))
                    .cornerRadius(15)
                }
                
                // --- DIREKTKONTAKT ZEILEN ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Andere Wege")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    VStack(spacing: 12) {
                        // Hier rufen wir die ContactDetailRow auf (Definition siehe unten)
                        ContactDetailRow(icon: "phone.fill", title: "Anrufen", detail: "+49 123 456 789", color: .green) {
                            openURL("tel:0123456789")
                        }
                        
                        ContactDetailRow(icon: "safari.fill", title: "Webseite", detail: "www.deineapp.de", color: .purple) {
                            openURL("https://www.deineapp.de")
                        }
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
        }
        .navigationTitle("Contact")
        .background(Color.white)
        .alert("Gesendet!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func sendMessage() {
        isSending = true
        print("NACHRICHT VON: \(storedUserName) (\(storedUserEmail))")
        print("BETREFF: \(subject)")
        print("INHALT: \(message)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSending = false
            showSuccessAlert = true
            subject = ""
            message = ""
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - HIER IST DIE FEHLENDE KOMPONENTE
// Diese Struktur muss außerhalb der ContactView, aber in der gleichen Datei stehen.
struct ContactDetailRow: View {
    let icon: String
    let title: String
    let detail: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // Das Icon im farbigen Quadrat
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(color.gradient)
                    .cornerRadius(10)
                
                // Text-Informationen
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(detail)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Kleiner Pfeil nach rechts
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding()
            .background(Color(UIColor.systemGray4))
            .cornerRadius(12)
        }
    }
}
