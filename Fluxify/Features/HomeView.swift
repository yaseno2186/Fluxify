//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//
//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//

import SwiftUI
internal import Combine
import Foundation

// MARK: - 1. Datenmodell
struct Geraet: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let kategorie: String
    let icon: String
}

// MARK: - 2. Farblogik Erweiterung
// Hiermit bestimmen wir zentral, welche Kategorie welche Farbe bekommt
extension Geraet {
    var kategorieFarbe: Color {
        switch kategorie {
        case "Mechanik": return .mint
        case "Elektromagnetismus": return .red
        case "Wärmelehre": return .orange
        case "Optik": return .cyan // In deiner HomeView nutzt du .cyan für Optik
        case "Experten Geräte": return .blue
        default: return .gray
        }
    }
}

// MARK: - 3. Manager
class SavedGeraeteManager: ObservableObject {
    @Published var savedGeraete: [Geraet] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(savedGeraete) {
                UserDefaults.standard.set(encoded, forKey: "savedGeraete")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "savedGeraete"),
           let decoded = try? JSONDecoder().decode([Geraet].self, from: data) {
            savedGeraete = decoded
        }
    }
    
    func toggle(_ geraet: Geraet) {
        if savedGeraete.contains(where: { $0.id == geraet.id }) {
            savedGeraete.removeAll { $0.id == geraet.id }
        } else {
            savedGeraete.append(geraet)
        }
    }
    
    func isSaved(_ geraet: Geraet) -> Bool {
        savedGeraete.contains { $0.id == geraet.id }
    }
}

// MARK: - 4. Home View
struct HomeView: View {
    @StateObject private var manager = SavedGeraeteManager()
    @State private var searchText = ""
    
    let geraete = [
        Geraet(name: "Auto", kategorie: "Mechanik", icon: "car.fill"),
        Geraet(name: "Fahrrad", kategorie: "Mechanik", icon: "bicycle"),
        Geraet(name: "Flaschenzug", kategorie: "Mechanik", icon: "arrow.down.circle.fill"),
        
        Geraet(name: "Generator", kategorie: "Elektromagnetismus", icon: "bolt.batteryblock.fill"),
        Geraet(name: "Radio", kategorie: "Elektromagnetismus", icon: "radio.fill"),
        Geraet(name: "Lautsprecher", kategorie: "Elektromagnetismus", icon: "speaker.wave.2.fill"),
        
        Geraet(name: "Heizung", kategorie: "Wärmelehre", icon: "thermometer.sun.fill"),
        Geraet(name: "Herd", kategorie: "Wärmelehre", icon: "flame.fill"),
        Geraet(name: "Kühlschrank", kategorie: "Wärmelehre", icon: "snowflake"),
        
        Geraet(name: "Fotoapparat", kategorie: "Optik", icon: "camera.fill"),
        Geraet(name: "Spiegel", kategorie: "Optik", icon: "rectangle.fill"),
        Geraet(name: "Taschenlampe", kategorie: "Optik", icon: "flashlight.on.fill"),
        
        Geraet(name: "Ultraschallgerät", kategorie: "Experten Geräte", icon: "waveform"),
        Geraet(name: "Zentrifuge", kategorie: "Experten Geräte", icon: "rotate.3d")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Platzhalter für deinen Hintergrund
                ParticleBackground1().ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        
                        Text("Home")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 50)
                        
                        SuchLeiste(searchText: $searchText, geraete: geraete)
                        
                        if searchText.isEmpty {
                            VStack(spacing: 16) {
                                NavigationLink(destination: GespeicherteListeView(manager: manager)) {
                                    SpecialFeatureCard(title: "Gespeichert", icon: "bookmark.fill", color: .indigo, borderColor: .indigo.opacity(0.8))
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Mechanik", farbe: .mint, geraete: geraete.filter { $0.kategorie == "Mechanik" }, manager: manager)) {
                                    FeatureCard(title: "Mechanik", icon: "gearshape.2.fill", color: .mint)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Elektromagnetismus", farbe: .red, geraete: geraete.filter { $0.kategorie == "Elektromagnetismus" }, manager: manager)) {
                                    FeatureCard(title: "Elektromagnetismus", icon: "minus.plus.batteryblock.fill", color: .red)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Wärmelehre", farbe: .orange, geraete: geraete.filter { $0.kategorie == "Wärmelehre" }, manager: manager)) {
                                    FeatureCard(title: "Wärmelehre", icon: "flame.fill", color: .orange)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Optik", farbe: .cyan, geraete: geraete.filter { $0.kategorie == "Optik" }, manager: manager)) {
                                    FeatureCard(title: "Optik", icon: "triangle.fill", color: .cyan)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            
                            VStack(spacing: 16) {
                                NavigationLink(destination: ExpertenListeView(geraete: geraete.filter { $0.kategorie == "Experten Geräte" }, manager: manager)) {
                                    SpecialFeatureCard(title: "Experten Geräte", icon: "graduationcap.fill", color: .blue, borderColor: .blue.opacity(0.8))
                                }
                                
                                NavigationLink(destination: WusstestDuSchonView()) {
                                    SpecialFeatureCard(title: "Wusstest du schon?", icon: "lightbulb.fill", color: .yellow, borderColor: .yellow.opacity(0.8))
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - 5. Sub-Views & Components

struct FeatureCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.8))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer().frame(width: 56)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray5)))
    }
}

struct SpecialFeatureCard: View {
    let title: String
    let icon: String
    let color: Color
    let borderColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.8))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer().frame(width: 56)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(borderColor, lineWidth: 3))
    }
}

struct SuchLeiste: View {
    @Binding var searchText: String
    let geraete: [Geraet]
    
    var gefilterteGeraete: [Geraet] {
        if searchText.isEmpty { return [] }
        return geraete.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Gerät suchen...", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
            .padding(.horizontal, 24)
            
            if !gefilterteGeraete.isEmpty {
                ForEach(gefilterteGeraete) { geraet in
                    NavigationLink(destination: GerätDetailView(geraet: geraet)) {
                        HStack {
                            Image(systemName: geraet.icon).frame(width: 30)
                            Text(geraet.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Text(geraet.kategorie).font(.caption).foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}

// MARK: - 6. Detail Views

struct ThemaDetailView: View {
    let titel: String
    let farbe: Color
    let geraete: [Geraet]
    @ObservedObject var manager: SavedGeraeteManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(farbe)
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        ZStack(alignment: .center) {
                            HStack {
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
                            Text(titel)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(height: 50)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .frame(height: 180)
                }
                .frame(height: 160)
                
                LazyVStack(spacing: 16) {
                    ForEach(geraete) { geraet in
                        NavigationLink(destination: GerätDetailView(geraet: geraet)) {
                            GerätKachel(
                                geraet: geraet,
                                hintergrundFarbe: farbe.opacity(0.1),
                                showProgress: true,
                                manager: manager
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 25)
                Spacer(minLength: 50)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}



// MARK: - Kacheln & Detail

struct GerätKachel: View {
    let geraet: Geraet
    let hintergrundFarbe: Color
    let showProgress: Bool
    @ObservedObject var manager: SavedGeraeteManager
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(hintergrundFarbe)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: geraet.icon)
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                )
            
            Text(geraet.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    manager.toggle(geraet)
                }
            } label: {
                Image(systemName: manager.isSaved(geraet) ? "bookmark.fill" : "bookmark")
                    .font(.title3)
                    .foregroundColor(manager.isSaved(geraet) ? .blue : .gray)
                    .scaleEffect(manager.isSaved(geraet) ? 1.2 : 1.0)
                    .padding(8)
            }
            
            if showProgress {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 6)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 2)
        )
    }
}

struct ExpertenListeView: View {
    let geraete: [Geraet]
    @ObservedObject var manager: SavedGeraeteManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.blue.opacity(0.8))
                        .frame(height: 200)
                        .offset(y: -40)
                    
                    VStack(spacing: 0) {
                        Spacer().frame(height: 25)
                        ZStack(alignment: .center) {
                            HStack {
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
                            Text("Experten Geräte")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        .padding(.top, 60)
                        Spacer()
                    }
                    .frame(height: 180)
                }
                .frame(height: 160)
                
                LazyVStack(spacing: 16) {
                    ForEach(geraete) { geraet in
                        NavigationLink(destination: GerätDetailView(geraet: geraet)) {
                            ExpertenKachel(geraet: geraet)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 25)
                Spacer(minLength: 50)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ExpertenKachel: View {
    let geraet: Geraet
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: geraet.icon).font(.system(size: 22)).foregroundColor(.blue))
            
            Text(geraet.name).font(.system(size: 18, weight: .semibold)).foregroundColor(.black)
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<3) { _ in Image(systemName: "star.fill").font(.system(size: 12)).foregroundColor(.blue) }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(radius: 5))
    }
}

struct GerätDetailView: View {
    let geraet: Geraet
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left").padding(12).background(Color.gray.opacity(0.2)).clipShape(Circle())
                }.padding(.leading, 16)
                Spacer()
            }.padding(.top, 60)
            Spacer()
            Image(systemName: geraet.icon).font(.system(size: 100)).foregroundColor(.blue)
            Text(geraet.name).font(.largeTitle.bold())
            Text(geraet.kategorie).foregroundColor(.gray)
            Spacer()
        }.navigationBarHidden(true)
    }
}

struct WusstestDuSchonView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Button("Zurück") { presentationMode.wrappedValue.dismiss() }.padding()
            Spacer()
            Text("Wusstest du schon?").font(.title)
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
