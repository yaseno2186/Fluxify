import Foundation

struct Hints: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let imageName: String?
    let connectioWithTask: Task.ID = UUID()
    let lock: Bool = true
    
}
