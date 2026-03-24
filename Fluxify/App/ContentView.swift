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
    @AppStorage("userEmail") var userEmail: String = ""
    var body: some View {
        
        ZStack {

            
            SettingsView1(shouldShowOnboarding: $shouldShowOnboarding)
            
            
            
        }
        
        
        
        
       
    }
}

#Preview {
    ContentView()
}
