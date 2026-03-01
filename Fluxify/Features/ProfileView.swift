//
//  Untitled.swift
//  Fluxify
//
//  Created by Chingiz on 18.01.26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        ZStack{
            
            
            ParticleBackground1()
                .ignoresSafeArea()
            
            Text("Profil")
                .foregroundStyle(Color.white)
                .font(.largeTitle)
                
            
        }
        
    }
    
}

#Preview {
    ProfileView()
}
