import Foundation

struct Task: Identifiable {
    let id = UUID()
    let question: String
    let imageName: String?
    let options: [String]
    let correctAnswer: String
}
