//
//  ContentView.swift
//  Fluxify
//
//  Created by TA638 on 16.01.26.
//
import Foundation
import SwiftUI

struct ContentView: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userAge") var userAge: String = ""
    @AppStorage("userEmail") var userEmail: String = ""
    var body: some View {
        
        ZStack {
            
          
            ParticleBackground1()
                .ignoresSafeArea()
            
            SettingsView1(userName: userName, userEmail: userEmail, shouldShowOnboarding: $shouldShowOnboarding)
            
            
            
        }
        
        
        
        
       
    }
}

#Preview {
    ContentView()
}
