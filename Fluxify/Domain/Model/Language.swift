
import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "English"
    case german = "German"

    var id: String { self.rawValue }

    var code: String {
        switch self {
        case .english:
            return "en"
        case .german:
            return "de"
        }
    }
}
