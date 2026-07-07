import SwiftUI

struct ThemeModeService {
    static func isDarkMode() -> Bool {
        @AppStorage("isDarkMode") var isDarkMode = false
        
        return isDarkMode
    }
}
