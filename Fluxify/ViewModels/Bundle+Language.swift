import Foundation

private var bundleKey: UInt8 = 0

private final class LanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        // Use the custom language bundle if set; otherwise fall back to super
        if let custom = objc_getAssociatedObject(Bundle.main, &bundleKey) as? Bundle {
            return custom.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}

public extension Bundle {
    static func setLanguage(_ language: String) {
        // Swap the main bundle class once to intercept localizedString lookups
        if object_getClass(Bundle.main) !== LanguageBundle.self {
            object_setClass(Bundle.main, LanguageBundle.self)
        }
        // Find the path for the requested language's lproj inside the main bundle
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            // Associate the language bundle with the main bundle
            objc_setAssociatedObject(Bundle.main, &bundleKey, langBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        } else {
            // Clear association to fall back to base localization
            objc_setAssociatedObject(Bundle.main, &bundleKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// Note: Call `Bundle.setLanguage(code)` early (e.g., app launch) to apply changes to `NSLocalizedString` and SwiftUI Text initializations.
