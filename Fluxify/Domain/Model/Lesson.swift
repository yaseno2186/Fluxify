// Created By Yass

import Foundation
import SwiftUI

struct Lesson: Identifiable {
    let id = UUID()
    var title: String
    var iconName: String
    var category: LessonCategory
}

enum LessonCategory: String, CaseIterable {
    case waermelehre = "Wärmelehre"
    case elektromagnetismus = "Elektromagnetismus"
    case mechanik = "Mechanik"
    case optik = "Optik"
    case experten = "Experten Geräte"
    
    var color: Color {
        switch self {
        case .waermelehre: return .orange
        case .elektromagnetismus: return .red
        case .mechanik: return .mint
        case .optik: return .purple
        case .experten: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .waermelehre: return "flame.fill"
        case .elektromagnetismus: return "bolt.fill"
        case .mechanik: return "gearshape.2.fill"
        case .optik: return "triangle.fill"
        case .experten: return "graduationcap.fill"
        }
    }
}
