
import Foundation
internal import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func login() {
        BackendService.shared.login(email: email, password: password) { [weak self] user in
            DispatchQueue.main.async {
                if user != nil {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                } else {
                    self?.isAuthenticated = false
                    self?.errorMessage = "Invalid email or password."
                }
            }
        }
    }
}
