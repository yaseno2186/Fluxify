
//
//  ContentView.swift
//  Fluxify
//
//  Created by TA638 on 16.01.26.
//


import SwiftUI

struct HomeView: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Circle().fill(Color.blue).frame(width: 12, height: 12)
                    Text("Home").font(.headline)
                }.padding(.leading, 20)
                Spacer()
            }.padding(.top, 10)

            // SUCHLEISTE
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Gerät suchen...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal, 20)

            // 4 THEMEN-KACHELN
            VStack(spacing: 15) {
                TopicCard("flame",           "Wärmelehre")          { print("Wärmelehre") }
                TopicCard("circle.grid.3x3", "Mechanik")            { print("Mechanik") }
                TopicCard("minus.plus.batteryblock", "Elektromagnetismus") { print("Elektromagnetismus") }
                TopicCard("triangle",        "Optik")               { print("Optik") }
            }
            .padding(.horizontal, 20)

            // 2 INFO-KACHELN
            VStack(spacing: 15) {
                ClickableCard(text: "Experten - Geräte",
                              icon: "graduationcap.fill",
                              iconColor: .blue,
                              bg: .blue.opacity(0.1),
                              stroke: .blue) { print("Experten-Geräte") }

                ClickableCard(text: "Wusstest du schon ?",
                              icon: "star.fill",
                              iconColor: .yellow,
                              bg: .yellow.opacity(0.2),
                              stroke: .yellow) { print("Wusstest-du-schon") }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
    }

    // MARK: - Wiederverwendbare Themen-Kachel
    private func TopicCard(_ icon: String, _ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).foregroundColor(.black)
                Text(title).foregroundColor(.black)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
            .scaleEffect(1)          // visuelles Feedback
            .animation(.easeInOut(duration: 0.08), value: 1)
        }
        .buttonStyle(PlainButtonStyle()) // entfernt Standard-Button-Hintergrund
    }

    // MARK: - Wiederverwendbare farbige Info-Kachel
    private func ClickableCard(text: String,
                               icon: String,
                               iconColor: Color,
                               bg: Color,
                               stroke: Color,
                               action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon).foregroundColor(iconColor)
                Text(text).foregroundColor(.black)
                Spacer()
            }
            .padding()
            .background(bg)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(stroke, lineWidth: 2))
            .scaleEffect(1)
            .animation(.easeInOut(duration: 0.08), value: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View { HomeView() }
}
