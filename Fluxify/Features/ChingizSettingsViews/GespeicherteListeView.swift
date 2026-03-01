//
//  GespeicherteListeView.swift
//  Fluxify
//
//  Created by Chingiz on 12.02.26.
//
//
//  GespeicherteListeView.swift
//  Fluxify
//
//  Created by Chingiz on 12.02.26.
//

import SwiftUI
import Foundation

struct GespeicherteListeView: View {
    @ObservedObject var manager: SavedGeraeteManager
    @Environment(\.presentationMode) var presentationMode
    
    // Diese "computed property" teilt die flache Liste der Geräte in Gruppen auf.
    // Das Ergebnis ist ein Dictionary, z.B.: ["Mechanik": [Auto, Fahrrad], "Optik": [Spiegel]]
    private var gruppierteGeraete: [String: [Geraet]] {
        Dictionary(grouping: manager.savedGeraete, by: { $0.kategorie })
    }
    
    // Hier holen wir uns die Namen der Kategorien (Mechanik, Optik, etc.) und sortieren sie alphabetisch.
    // Das brauchen wir, damit die Reihenfolge in der Liste nicht ständig hin- und herpumpt.
    private var sortierteKategorien: [String] {
        gruppierteGeraete.keys.sorted()
    }
    

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header Bereich
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.indigo)
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        HStack {
                            // Zurück-Button
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .padding(.leading, 16)
                            Spacer()
                        }
                        .frame(height: 50)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .frame(height: 180)
                    .overlay(
                        Text("Gespeichert")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                    )
                }
                .frame(height: 160)
                
                // MARK: - Inhalts Bereich
                if manager.savedGeraete.isEmpty {
                    // Anzeige, wenn die Liste komplett leer ist
                    VStack(spacing: 20) {
                        Image(systemName: "bookmark.slash").font(.system(size: 50)).foregroundColor(.gray)
                        Text("Noch nichts gespeichert").foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                } else {
                    //LazyVStack für Performance
                    LazyVStack(spacing: 25) {
                        
                        // Wir gehen jede gefundene Kategorie einzeln durch
                        ForEach(sortierteKategorien, id: \.self) { kategorie in
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                // TRENNELEMENT: Der Text für das Themengebiet
                                Text(kategorie.uppercased())
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(.secondary) // Ein dezentes Grau
                                    .padding(.leading, 4)
                                
                                // 2. SCHLEIFE: Wir zeigen alle Geräte an, die zu DIESER Kategorie gehören
                                ForEach(gruppierteGeraete[kategorie] ?? []) { geraet in
                                    NavigationLink(destination: GerätDetailView(geraet: geraet)) {
                                        // Die Kachel erhält automatisch ihre Farbe über die Geraet-Extension
                                        GerätKachel(
                                            geraet: geraet,
                                            hintergrundFarbe: geraet.kategorieFarbe.opacity(0.1),
                                            showProgress: false,
                                            manager: manager
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                }
                
                Spacer(minLength: 50)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}
