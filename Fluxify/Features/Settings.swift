//
//  Settings.swift
//  MyApp
//
//  Created by Chingiz on 18.01.26.
//

import SwiftUI

struct SetttingsView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                
                ParticleBackground1()
                    .ignoresSafeArea()
                //CosmicBackgroundView()
                
                ScrollView{
                    
                    VStack {
                        //           ZStack{
                        //               Color(.systemGray)
                        //                   .frame(width: 350, height: //100,alignment: .center)
                        //                   .cornerRadius(10)
                        //                   .opacity(0.95)
                        //               Text("Einstellungen")
                        //                   .font(.largeTitle)
                        //                   .bold()
                        //                   .foregroundColor(.white)
                        //                   .frame(width: 300, height: //100,alignment: .center)
                        //                   .padding(.bottom, 10)
                        //
                        //           }
                        //           .padding(.top, 40)
                        
                        // Abstand nach der Überschrift
                        Spacer(minLength: 50)
                        
                        
                        
                        Text("Allgemeines")
                            .font(.system(size: 18, weight: .thin))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                        
                        
                        
                        PrimaryButton(
                            title: "Profil",
                            icon: "person.fill",
                            iconColor: .gray,
                            destination: AnyView(DetailView())
                        )
                        
                        PrimaryButton(
                            title: "Benachrichtigung",
                            icon: "bell.fill",
                            iconColor: .gray,
                            destination: AnyView(DetailView())
                        )
                        
                        PrimaryButton(
                            title: "Gespeichert",
                            icon: "bookmark.fill",
                            iconColor: .gray,
                            destination: AnyView(DetailView())
                        )
                        
                        
                        Text("Über Uns")
                            .padding(.top, 20)
                            .font(.system(size: 18, weight: .thin))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                        
                        PrimaryButton(
                            title: "About Us",
                            icon: "info.circle.fill",
                            iconColor: .black,
                            destination: AnyView(DetailView())
                        )
                        
                        PrimaryButton(
                            title: "Contact",
                            icon: "hand.wave.fill",
                            iconColor: .white,
                            destination: AnyView(DetailView())
                        )
                        Spacer()
                    }
                } .navigationTitle("Einstellungen")
                
            }
            
            
        }
        
        
        
    }
    
}

struct PrimaryButton: View {
    let title: String
    let icon: String
    let iconColor: Color        // Farbe für das Icon
    let destination: AnyView
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 20) {
                
                // Icon mit individuell übergebener Farbe
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(iconColor)
                
                // Text bleibt weiß
                Text(title)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                // Pfeil rechts (bewusst neutral gehalten)
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: 300, height: 60, alignment: .leading)
            .padding(.horizontal, 20)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(8)
        }
    }
}



// Button
//Button("Tap me") {
//    print("Button gedrückt")
//}
//.font(.system(size: 20))
//.padding(.horizontal, 32)
//.padding(.vertical, 14)
//.background(Color.blue)
//.foregroundColor(.white)
//.cornerRadius(8)
//





#Preview {
    SetttingsView()
}

