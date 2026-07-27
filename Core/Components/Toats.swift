import SwiftUI

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    var icon: String
    var message: String
    var tint: Color
    var duration: Double = 3.0
}

struct ToastView: View {
    var toast: ToastMessage
    var onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.icon)
                .foregroundColor(toast.tint)
                .font(.title3)
            
            Text(toast.message)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer(minLength: 0)
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: ToastMessage?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.overlay(alignment: .bottom) {
                if let toast {
                    ToastView(toast: toast, onDismiss: {
                        dismissToast()
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
                    .zIndex(1)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toast)
            .onChange(of: toast) { _, newValue in
                if newValue != nil {
                    scheduleDismissal()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func scheduleDismissal() {
           guard let toast else { return }
           workItem?.cancel()
           
           let task = DispatchWorkItem {
               dismissToast()
           }
           workItem = task
           DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
       }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func showToast(toast: Binding<ToastMessage?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    ToastView(toast: ToastMessage(icon: "trash", message: "message", tint: .secondary), onDismiss: {})
}
