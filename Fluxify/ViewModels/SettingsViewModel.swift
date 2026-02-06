
import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoggedOut = false
    @Published var selectedLanguage: Language = .english {
        didSet {
            Bundle.setLanguage(selectedLanguage.code)
            UserDefaults.standard.set([selectedLanguage.code], forKey: "AppLanguage")
        }
    }
    let languages = Language.allCases
    private var cancellable: AnyCancellable?

    init() {
        // Load saved language preference
        if let savedLanguageCode = UserDefaults.standard.string(forKey: "AppLanguage") {
            if let language = Language.allCases.first(where: { $0.code == savedLanguageCode }) {
                selectedLanguage = language
                Bundle.setLanguage(savedLanguageCode)
            }
        } else {
            // Try to get system language
            if let languageCode = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first {
                if let language = Language.allCases.first(where: { $0.code == languageCode }) {
                    selectedLanguage = language
                    Bundle.setLanguage(languageCode)
                }
            }
        }
    }

    func fetchUserProfile() {
        BackendService.shared.fetchUserProfile { [weak self] user in
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }

    func logout() {
        BackendService.shared.logout { [weak self] in
            DispatchQueue.main.async {
                // In a real app, you would clear any stored user session data here.
                self?.isLoggedOut = true
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
