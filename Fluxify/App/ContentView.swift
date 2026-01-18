//
//  ContentView.swift
//  Fluxify
//
//  Created by TA638 on 16.01.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            CosmicBackgroundView()
                .ignoresSafeArea()
            
            SettingsView()
            
            
        }
        
        
        
        
       
    }
}

#Preview {
    ContentView()
}
