import Foundation



struct DailyFact: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let imageName: String?
}
