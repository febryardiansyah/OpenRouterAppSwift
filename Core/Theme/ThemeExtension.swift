import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct CardTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.appSecondarySystemBackground)
            )
    }
}

extension Color {
    static var appSystemBackground: Color {
#if canImport(UIKit)
        return Color(uiColor: .systemBackground)
#elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
#else
        return .white
#endif
    }

    static var appSecondarySystemBackground: Color {
#if canImport(UIKit)
        return Color(uiColor: .secondarySystemBackground)
#elseif canImport(AppKit)
        return Color(nsColor: .controlBackgroundColor)
#else
        return .gray.opacity(0.08)
#endif
    }

    static var appTertiarySystemFill: Color {
#if canImport(UIKit)
        return Color(uiColor: .systemGray5)
#elseif canImport(AppKit)
        return Color(nsColor: .separatorColor).opacity(0.2)
#else
        return .gray.opacity(0.2)
#endif
    }
}

extension View {
    func cardTheme() -> some View {
        modifier(CardTheme())
    }
}
