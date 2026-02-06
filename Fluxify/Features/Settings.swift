//
//  Settings.swift
//  MyApp
//
//  Created by Chingiz on 18.01.26.
//


// list
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                
                ParticleBackground()
                    .ignoresSafeArea()
                
                VStack {
                    ZStack{
                      
                        
                    }
                    Spacer()
                    
                    PrimaryButton(
                        title: "heart",
                        icon: "person.fill",
                        destination: AnyView(DetailView())
                    )
                    
                    PrimaryButton(
                        title: "Benachrichtigung",
                        icon: "bell.fill",
                        destination: AnyView(DetailView())
                    )
                    
                    PrimaryButton(
                        title: "Gespeichert",
                        icon: "heart.fill",
                        destination: AnyView(DetailView())
                    )
                    
                    PrimaryButton(
                        title: "Hey",
                        icon: "hand.wave.fill",
                        destination: AnyView(DetailView())
                    )
                    
                    
                    Spacer()
                }
                
            }.navigationTitle("Einstellungen")
            
            
        }
  
            
    }
    
}

struct PrimaryButton: View {
    let title: String
    let icon: String
    let destination: AnyView

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 20) {

                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)

                Text(title)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.white)
                
                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(width: 300, height: 60, alignment: .leading)
            .padding(.trailing, 20)
            .padding(.leading, 20)
            .background(Color.gray.opacity(0.8))
            .cornerRadius(8)
        }
    }
}




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
    SettingsView()
}

