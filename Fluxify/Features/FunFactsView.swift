//
//  FunFactsView.swift
//  Fluxify
//
//  Created by Yass on 22.04.26.
//
import SwiftUI

struct FunFactsView: View {
    
    let facts: [DeviceFact] = [
        DeviceFact(
            title: "Mikrowelle",
            icon: "microwave.fill",
            color: .orange,
            facts: [
                "Eine halbe Traube in der Mikrowelle erzeugt kurzzeitig echtes Plasma , Feuer aus Licht!",
                "Wasser kann sich überhitzen: Es sieht ruhig aus, kocht aber nicht. Rührst du um, explodiert es dir ins Gesicht.",
                "Ein Ei in der Schale wird zur Handgranate: Der Dampf findet kein Loch und sprengt die Schale mit lautem Knall.",
                "Metallbeschichtete Objekte funkeln und können Brände auslösen , auch wenn es keine Gabel ist.",
                "Die Mikrowelle hat heiße und kalte Stellen: Ein Marshmallow-Test zeigt dir genau, wo die stehenden Wellen sind."
            ]
        ),
        DeviceFact(
            title: "Kühlschrank",
            icon: "refrigerator",
            color: .mint,
            facts: [
                "Tomaten im Kühlschrank verlieren ihr Aroma für immer , der Kälteschock zerstört ihre Aromastoffe.",
                "Heißes Essen direkt hineinstellen ist sicherer als abkühlen lassen: Bakterien lieben Raumtemperatur.",
                "Die Tür ist der wärmste Ort: Milch dort hält deutlich kürzer als hinten im Regal.",
                "Gefrierbrand ist keine Kälte, sondern Austrocknung: Das Eis verdampft direkt ins Trockene.",
                "Ein voller Gefrierschrank verbraucht weniger Strom als ein leerer: Die gefrorene Masse speichert Kälte als Puffer."
            ]
        ),
        DeviceFact(
            title: "Induktion",
            icon: "heater.vertical",
            color: .red,
            facts: [
                "Ein leerer Topf auf Induktion kann so heiß werden, dass er zu glühen beginnt und das Glasfeld beschädigt.",
                "Ein Löffel, der am Topfrand lehnt, kann durch das Streufeld heiß werden , ohne dass du es merkst.",
                "Kreditkarten mit Magnetstreifen direkt auf der Platte werden unwiderruflich gelöscht.",
                "Dein Smartphone auf der Platte kann durch die Magnetfelder dauerhaften Schaden nehmen.",
                "Menschen mit Herzschrittmacher sollten sich nicht direkt über aktive Induktionsplatten beugen."
            ]
        ),
        DeviceFact(
            title: "GPS",
            icon: "globe.americas",
            color: .blue,
            facts: [
                "Dein Handy ortet dich im Flugmodus trotzdem: GPS-Satelliten brauchen kein Mobilfunknetz.",
                "Stahlbrücken oder Parkhäuser können die GPS-Uhrzeit um Millisekunden verfälschen , genug, um die Navigation zu irritieren.",
                "Starke Sonnenstürme können das GPS-Signal für Minuten komplett verschwinden lassen.",
                "Dein Telefon nutzt beim Start nicht nur Satelliten, sondern auch Mobilfunkmasten, um den Fix zu beschleunigen.",
                "Ein reines GPS-Gerät funktioniert in manchen Städten schlechter als ein Smartphone, weil Handys GLONASS, Galileo und GPS gleichzeitig nutzen."
            ]
        )
    ]
    
    @State private var selectedPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Compact Header
            VStack(spacing: 4) {
                Text("Wusstest du schon?")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Wische nach links oder rechts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Swipeable Cards
            TabView(selection: $selectedPage) {
                ForEach(Array(facts.enumerated()), id: \.offset) { index, device in
                    DeviceFactCard(device: device)
                        .tag(index)
                        .padding(.horizontal, 24)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            Spacer(minLength: 20)
        }
        .background(Color(.systemBackground))   // ← FIXED: was systemGroupedBackground
        .navigationBarHidden(true)
    }
}

// MARK: - Data Model
struct DeviceFact: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let facts: [String]
}

// MARK: - Card Component
struct DeviceFactCard: View {
    let device: DeviceFact
    
    var body: some View {
        VStack(spacing: 0) {
            // Top color banner
            HStack(spacing: 12) {
                Image(systemName: device.icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                Text(device.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(device.color)
            
            // Facts list
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(Array(device.facts.enumerated()), id: \.offset) { index, fact in
                        HStack(alignment: .top, spacing: 14) {
                            Text("\(index + 1)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(device.color)
                                .clipShape(Circle())
                            
                            Text(fact)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(UIColor.systemGray6))
                        )
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(device.color.opacity(0.3), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Preview
struct FunFactsView_Previews: PreviewProvider {
    static var previews: some View {
        FunFactsView()
    }
}
