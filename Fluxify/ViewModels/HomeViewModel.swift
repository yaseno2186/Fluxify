
import Foundation
internal import Combine

class HomeViewModel: ObservableObject {
    @Published var lessons = [Lesson]()
    
    func fetchLessons() {
        BackendService.shared.fetchLessons { [weak self] lessons in
            DispatchQueue.main.async {
                self?.lessons = lessons
            }
        }
    }
}
