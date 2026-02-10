//
//  SavedItemsView.swift
//  Fluxify
//
//  Created by Chingiz on 07.02.26.
//

import SwiftUI

struct SavedItemsView: View {
    // Zugriff auf den Manager, um gespeicherte Posts anzuzeigen.
    @EnvironmentObject var manager: SavedPostsManager
    
    var body: some View {
        List {
            if manager.savedPosts.isEmpty {
                Text("Keine gespeicherten Beiträge")
                    .foregroundColor(.gray)
            } else {
                ForEach(manager.savedPosts) { post in
                    HStack {
                        Image(systemName: post.icon)
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        Text(post.title)
                    }
                }
                // Ermöglicht das Löschen durch Wischen (Swipe-to-Delete).
                .onDelete { indexSet in
                    manager.savedPosts.remove(atOffsets: indexSet)
                }
            }
        }
        .navigationTitle("Gespeichert")
    }
}



import SwiftUI
internal import Combine
import Foundation

struct Post: Identifiable, Codable, Hashable {
    // Eindeutige ID für Identifiable (wichtig für Listen/ForEach)
    // Erzeugt automatisch eine einzigartige Id für jeden Beitrag, damit SwiftUI weiß um welchen Beitrag es sich handelt
    let id: String
    // Titel des Beitrags
    let title: String
    // Name des SF Symbols (Icon)
    let icon: String
    // Beschreibungstext
    let text: String
}

class SavedPostsManager: ObservableObject {
    // @Published informiert beobachtende Views über Änderungen, damit sie sich neu zeichnen.
    // didSet wird ausgeführt, sobald sich der Wert von 'savedPosts' ändert.
    @Published var savedPosts: [Post] = [] {
        didSet {
            // 'didSet' ist ein Property Observer. Er wird automatisch aufgerufen, NACHDEM sich der Wert geändert hat.
            // Warum hier? Damit wir nicht manuell eine 'save()'-Funktion aufrufen müssen.
            // Egal wo in der App wir einen Post hinzufügen oder entfernen, dieser Block sorgt sofort für die Speicherung.
            // Wir kodieren das Array zu JSON und speichern es in den UserDefaults.
            if let encoded = try? JSONEncoder().encode(savedPosts) {
                UserDefaults.standard.set(encoded, forKey: "savedPosts")
            }
        }
    }
    
    // Initializer: Wird beim Erstellen der Instanz aufgerufen.
    init() {
        // 'init()' ist der Konstruktor. Er wird genau einmal ausgeführt, wenn 'SavedPostsManager()' erstellt wird.
        // Warum hier? Wenn die App startet, ist das Array 'savedPosts' im Arbeitsspeicher leer.
        // Wir müssen also direkt beim Start nachsehen, ob auf der Festplatte (UserDefaults) Daten liegen,
        // und diese laden, damit der Nutzer seine gespeicherten Beiträge sieht.
        // Versucht, gespeicherte Daten aus UserDefaults zu laden.
        if let data = UserDefaults.standard.data(forKey: "savedPosts"),
           // Dekodiert die JSON-Daten zurück in ein Array von Post-Objekten.
           let decoded = try? JSONDecoder().decode([Post].self, from: data) {
            savedPosts = decoded
        }
    }
    
    // Funktion zum Umschalten des Speicherstatus (Hinzufügen/Entfernen).
    func toggle(_ post: Post) {
        // Prüft, ob der Post schon im Array ist.
        if savedPosts.contains(where: { $0.id == post.id }) {
            // Wenn ja: Entfernen.
            savedPosts.removeAll { $0.id == post.id }
        } else {
            // Wenn nein: Hinzufügen.
            savedPosts.append(post)
        }
    }
    
    // Hilfsfunktion: Gibt true zurück, wenn der Post gespeichert ist.
    func isSaved(_ post: Post) -> Bool {
        savedPosts.contains { $0.id == post.id }
    }
}


// Hintergrund
struct AnimatedGradientBackground: View {
    let colors: [Color]
    // Start- und Endpunkte für den Gradienten, die animiert werden.
    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 1, y: 1)
    
    var body: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .onAppear {
                // .onAppear wird aufgerufen, sobald diese View auf dem Bildschirm sichtbar wird.
                // Warum hier? Wir wollen die Animation starten, sobald der Hintergrund geladen ist.
                // Endlosschleife der Animation (hin und zurück).
                withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
                    start = UnitPoint(x: 1, y: 1)
                    end = UnitPoint(x: 0, y: 0)
                }
            }
    }
}

#Preview {
    Onboarding()
}
