//
//  ProgressBar.swift
//  Fluxify
//
//  Created by Yass on 07.03.26.
//
import SwiftUI

struct ProgressBar: View {
    let progress: Double 
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Hintergrund
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                
                // Fortschrittsbalken
                RoundedRectangle(cornerRadius: 3)
                    .fill(color)
                    .frame(width: max(0, geometry.size.width * CGFloat(progress)), height: 6)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 6)
    }
}
