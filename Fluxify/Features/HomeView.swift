//
//  NewHome.swift
//  Fluxify
//
//  Created by Bahinaz on 29.01.26.
//


import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    let geraete = [
        Geraet(name: "Auto", kategorie: "Mechanik", icon: "car.fill"),
        Geraet(name: "Fahrrad", kategorie: "Mechanik", icon: "bicycle"),
        Geraet(name: "Flaschenzug", kategorie: "Mechanik", icon: "arrow.down.circle.fill"),
        Geraet(name: "Generator", kategorie: "Elektromagnetismus", icon: "bolt.batteryblock.fill"),
        Geraet(name: "Heizung", kategorie: "Wärmelehre", icon: "thermometer.sun.fill"),
        Geraet(name: "Herd", kategorie: "Wärmelehre", icon: "flame.fill"),
        Geraet(name: "Kühlschrank", kategorie: "Wärmelehre", icon: "snowflake"),
        Geraet(name: "Lautsprecher", kategorie: "Elektromagnetismus", icon: "speaker.wave.2.fill"),
        Geraet(name: "Radio", kategorie: "Elektromagnetismus", icon: "radio.fill"),
        Geraet(name: "Fotoapparat", kategorie: "Optik", icon: "camera.fill"),
        Geraet(name: "Spiegel", kategorie: "Optik", icon: "rectangle.fill"),
        Geraet(name: "Taschenlampe", kategorie: "Optik", icon: "flashlight.on.fill"),
        Geraet(name: "Ultraschallgerät", kategorie: "Experten Geräte", icon: "waveform"),
        Geraet(name: "Zentrifuge", kategorie: "Experten Geräte", icon: "rotate.3d")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 1. Hintergrund ganz unten
                ParticleBackground1()
                    .ignoresSafeArea()
                
                // 2. Die ScrollView muss transparent sein
                ScrollView {
                    VStack(spacing: 15) {
                        
                        // Header
                        Text("Home")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 50)
                        
                        // Suchleiste
                        SuchLeiste(searchText: $searchText, geraete: geraete)
                        
                        if searchText.isEmpty {
                            // Themen-Kacheln
                            VStack(spacing: 16) {
                                NavigationLink(destination: ThemaDetailView(titel: "Mechanik", farbe: .mint, geraete: geraete.filter { $0.kategorie == "Mechanik" })) {
                                    FeatureCard(title: "Mechanik", icon: "gearshape.2.fill", color: .mint)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Elektromagnetismus", farbe: .red, geraete: geraete.filter { $0.kategorie == "Elektromagnetismus" })) {
                                    FeatureCard(title: "Elektromagnetismus", icon: "minus.plus.batteryblock.fill", color: .red)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Wärmelehre", farbe: .orange, geraete: geraete.filter { $0.kategorie == "Wärmelehre" })) {
                                    FeatureCard(title: "Wärmelehre", icon: "flame.fill", color: .orange)
                                }
                                
                                NavigationLink(destination: ThemaDetailView(titel: "Optik", farbe: .purple, geraete: geraete.filter { $0.kategorie == "Optik" })) {
                                    FeatureCard(title: "Optik", icon: "triangle.fill", color: .cyan)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            
                            // Untere Kacheln
                            VStack(spacing: 16) {
                                NavigationLink(destination: ExpertenListeView(geraete: geraete.filter { $0.kategorie == "Experten Geräte" })) {
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
               
                .background(Color.clear) // ScrollView transparent
            }
            .navigationBarHidden(true)
            // .background(Color(.systemBackground)) weg
        }
    }
}

// Standard Feature Card (für Themen)
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
            
            Spacer()
                .frame(width: 56)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
    }
}

//  farbige Rahmen für Experten & Wusstest du schon)
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
            
            Spacer()
                .frame(width: 56)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: 3) // Farbige Umrandung
        )
    }
}

// Suchleiste
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
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Gerät suchen...", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
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
                            Image(systemName: geraet.icon)
                                .frame(width: 30)
                            Text(geraet.name)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            Spacer()
                            Text(geraet.kategorie)
                                .font(.caption)
                                .foregroundColor(.gray)
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

// Thema View
struct ThemaDetailView: View {
    let titel: String
    let farbe: Color
    let geraete: [Geraet]
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
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
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
                                showProgress: true
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

// Experten Liste
struct ExpertenListeView: View {
    let geraete: [Geraet]
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
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
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

// Kacheln
struct GerätKachel: View {
    let geraet: Geraet
    let hintergrundFarbe: Color
    let showProgress: Bool
    
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

struct ExpertenKachel: View {
    let geraet: Geraet
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: geraet.icon)
                        .font(.system(size: 22))
                        .foregroundColor(.blue.opacity(0.8))
                )
            
            Text(geraet.name)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(0..<3) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.blue.opacity(0.8))
                }
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

// Views
struct GerätDetailView: View {
    let geraet: Geraet
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 70)
            .padding(.leading, 16)
            
            Spacer()
            
            Image(systemName: geraet.icon)
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            Text(geraet.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
            
            Text(geraet.kategorie)
                .font(.system(size: 20))
                .foregroundColor(.black.opacity(0.6))
            
            Spacer()
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct WusstestDuSchonView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 70)
            .padding(.leading, 16)
            
            Spacer()
            
            Text("Wusstest du schon?")
                .font(.largeTitle.bold())
                .foregroundColor(.black)
            
            Text("Hier kommen interessante Fakten...")
                .foregroundColor(.black.opacity(0.6))
                .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// Daten
struct Geraet: Identifiable {
    let id = UUID()
    let name: String
    let kategorie: String
    let icon: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
