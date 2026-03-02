import Foundation

struct Lesson: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var iconName: String
}