//
//  DetailView.swift
//  MyApp
//
//  Created by Chingiz on 18.01.26.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        
        ZStack{
            ParticleBackground()
            Text("Hello")
                .font(.system(size: 24))
                .foregroundStyle(Color.black)
            
        }
        
    }
}
