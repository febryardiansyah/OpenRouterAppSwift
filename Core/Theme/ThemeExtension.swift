import SwiftUI

struct CardTheme: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
    }
}

extension View {
    func cardTheme() -> some View {
        modifier(CardTheme())
    }
}
