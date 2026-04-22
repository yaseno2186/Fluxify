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
                "Die Mikrowelle nutzt exakt die gleiche Frequenz wie WLAN: 2,45 GHz!",
                "Das Magnetron ist eine Vakuumröhre und das Herzstück jeder Mikrowelle.",
                "Mikrowellen dringen nur 2–3 cm tief ins Essen ein – der Rest wird durch Wärmeleitung erwärmt.",
                "Der Drehteller sorgt für gleichmäßige Hitze, weil stehende Wellen heiße und kalte Stellen erzeugen.",
                "Eier platzen, weil sich Wasserdampf in der Schale staut – immer anstechen!"
            ]
        ),
        DeviceFact(
            title: "Kühlschrank",
            icon: "refrigerator",
            color: .mint,
            facts: [
                "Ein Kühlschrank ist eigentlich eine Wärmepumpe: Er pumpt Wärme aus dem Inneren nach außen.",
                "Der Kompressor verdichtet das Kältemittel – dadurch wird es heiß.",
                "Im Verdampfer wird das Kältemittel wieder kalt und nimmt Wärme aus dem Kühlschrank auf.",
                "-18°C ist der optimale Standard für Gefrierschränke.",
                "Jeder Grad über -18°C verbraucht ca. 6% mehr Energie!"
            ]
        ),
        DeviceFact(
            title: "Induktion",
            icon: "heater.vertical",
            color: .red,
            facts: [
                "Induktionsherde erzeugen ein hochfrequentes magnetisches Wechselfeld.",
                "Das Topfmaterial muss ferromagnetisch sein – deshalb funktioniert Aluminium nicht.",
                "Die Platte selbst wird nicht heiß, nur der Topf!",
                "Wirbelströme im Topfboden erzeugen die Hitze durch elektrischen Widerstand.",
                "Ein Magnet-Test zeigt sofort, ob ein Topf induktionsgeeignet ist."
            ]
        ),
        DeviceFact(
            title: "GPS",
            icon: "globe.americas",
            color: .blue,
            facts: [
                "GPS steht für Global Positioning System und wurde 1973 von der US-Regierung entwickelt.",
                "Mindestens 4 Satelliten werden für eine 3D-Position benötigt.",
                "Das GPS-System besteht aus 24–32 Satelliten in der Umlaufbahn.",
                "GPS-Satelliten senden auf zwei Frequenzen, um atmosphärische Störungen zu korrigieren.",
                "Deine Uhr wird durch GPS präziser als durch Funk gestellt!"
            ]
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Wusstest du schon?")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                
                Text("Interessante Fakten über deine Alltagsgeräte")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                
                // Facts by device
                LazyVStack(spacing: 24) {
                    ForEach(facts) { device in
                        DeviceFactCard(device: device)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemBackground))
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
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(device.color.opacity(0.2))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: device.icon)
                            .font(.system(size: 22))
                            .foregroundColor(device.color)
                    )
                
                Text(device.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Facts list
            VStack(spacing: 12) {
                ForEach(Array(device.facts.enumerated()), id: \.offset) { index, fact in
                    HStack(alignment: .top, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(device.color)
                            .clipShape(Circle())
                        
                        Text(fact)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(device.color.opacity(0.2), lineWidth: 2)
        )
    }
}

// MARK: - Preview
struct FunFactsView_Previews: PreviewProvider {
    static var previews: some View {
        FunFactsView()
    }
}
