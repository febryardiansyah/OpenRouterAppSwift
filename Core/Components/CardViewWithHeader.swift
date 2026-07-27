import SwiftUI

struct CardWithHeader<Content: View>: View {
    let headerTitle: String
    let content: Content
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    
    init(_ headerTitle: String,spacing: CGFloat = 0, alignment: HorizontalAlignment = .leading, @ViewBuilder content: () -> Content) {
        self.headerTitle = headerTitle
        self.content = content()
        self.spacing = spacing
        self.alignment = alignment
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(headerTitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .tracking(1)
            
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
            .cardTheme()
        }
    }
}
