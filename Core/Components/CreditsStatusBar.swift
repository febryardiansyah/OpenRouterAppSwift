import SwiftUI

struct CreditsStatusBar: View {
    @StateObject private var remainingCredit = RemainingCreditsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if remainingCredit.isLoading {
                ProgressView()
            } else if let err = remainingCredit.errorMessage {
                Text(err)
                    .foregroundStyle(.red)
            }
            
            if let data = remainingCredit.data {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color(red: 0.05, green: 0.38, blue: 0.92))
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("OpenRouter")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                        Text("Total Credits")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer(minLength: 0)
                }
                
                Text("$\(data.totalCredits.formattedCredit)")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Divider()
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Usage")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        Text("$\(data.totalUsage.formattedCredit)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Left")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                        Text("$\((data.totalCredits - data.totalUsage).formattedCredit)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
            }
            
            Divider()
            
#if os(macOS)
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")#endif
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            Task {
                await remainingCredit.fetchRemainingCredits()
            }
        }
    }
}

#Preview {
    CreditsStatusBar()
}
