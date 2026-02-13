//
//  HintView.swift
//  Fluxify
//
//  Created by Kami on 13.02.26.
//


import SwiftUI

struct HintView: View {
    let page: Int
    @State private var showAlertFood = false
    @State private var showAlertDrinks = false
    @State private var showAlertRainbow = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - App Bar
            HStack(spacing: 12) {
                
                // Weißer Pfeil
                if page == 1 {
                    NavigationLink(destination: HintView(page: 2)) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                } else {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                }

                Text("Wusstest du schon?")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background(
                Color.yellow
                    .ignoresSafeArea(edges: .top)
            )
            
            
            // MARK: - Content
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.yellow)
                            .frame(maxWidth: .infinity)
                            .frame(height: 420)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 60)
                        
                        VStack {
                            
                            // Button 1
                            Button(action: {
                                showAlertFood = true
                            }) {
                                Text(page == 2 ? "  heißes Wasser  " : "  Essen kühlen   ")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                            .alert("", isPresented: $showAlertFood) {
                                Button("ZURÜCK", role: .cancel) { }
                            } message: {
                                Text(page == 2 ?
                                     "Um aufschäumendes Wasser davon abzuhalten über den Topfrand zu kommen, muss man einen Holzlöffel in den Topf reinlegen. Die Blasen zerplatzen, wenn sie in Berührung mit der rauen Oberfläche des Holzlöffels kommen."
                                     :
                                     "Damit dein Essen schneller abkühlt, muss es eine größere Oberfläche haben. Je mehr Oberfläche das Essen hat, desto schneller kühlt es ab.")
                            }
                            .padding()
                            
                            
                            // Button 2
                            Button(action: {
                                showAlertDrinks = true
                            }) {
                                Text("Kühle Getränke")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                            .alert("", isPresented: $showAlertDrinks) {
                                Button("ZURÜCK", role: .cancel) { }
                            } message: {
                                Text("Wickle ein feuchtes Küchenpapier um ein Getränk und stelle es in den Gefrierschrank. So bleibt es länger gekühlt.")
                            }
                            .padding()
                            
                            
                            // Button 3
                            Button(action: {
                                showAlertRainbow = true
                            }) {
                                Text("  Regenbogen    ")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                            }
                            .alert("", isPresented: $showAlertRainbow) {
                                Button("ZURÜCK", role: .cancel) { }
                            } message: {
                                Text("Um einen Regenbogen zu erschaffen, musst du an einem sonnigen Ort gehen und dort einen Wassersprüher aufstellen.")
                            }
                            .padding()
                        }
                        
                        
                        // Gelber Pfeil unten im Kasten
                        if page == 1 {
                            NavigationLink(destination: HintView(page: 2)) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            .padding(.trailing, 28)
                        } else {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.yellow)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 28)
                        }
                    }
                    
                    
                    // Icons unten
                    HStack(spacing: 28) {
                        
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 64, height: 64)
                            Image(systemName: "house.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.yellow.opacity(0.6))
                                .frame(width: 64, height: 64)
                            Image(systemName: "drop.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 64, height: 64)
                            Image(systemName: "person.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 80)
            }
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    NavigationStack {
        HintView(page: 1)
    }
}
