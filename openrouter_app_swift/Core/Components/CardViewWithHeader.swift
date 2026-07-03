import SwiftUI

struct CardWithHeader<Content: View>: View {
    let headerTitle: String
    let content: Content
    
    init(_ headerTitle: String, @ViewBuilder content: () -> Content) {
        self.headerTitle = headerTitle
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(headerTitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .tracking(1)
            
            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .cardTheme()
        }
    }
}
