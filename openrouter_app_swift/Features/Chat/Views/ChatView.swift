//
//  ChatView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 02/07/26.
//

import SwiftUI

struct ChatView: View {
    @State var inputText = ""
    @State var showSheet = false
    
    struct ChatMessage: Identifiable {
        var id: UUID
        var message: String
        var isBot: Bool
    }
    
    let chatMessages: [ChatMessage] = [
        ChatMessage(id: UUID(), message: "Hi", isBot: false),
        ChatMessage(id: UUID(), message: "Meeting Management - Tanggal Agenda Tidak disable Saat edit Agenda In Progress", isBot: true),
        ChatMessage(id: UUID(), message: "Custom images don’t provide a text baseline guide, so the bottom of the image aligns to the text view’s baseline", isBot: false),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    showSheet.toggle()
                }) {
                    HStack {
                        Text("Claude 3.5")
                        Image(systemName: "chevron.down")
                    }
                }
                .foregroundStyle(.black)
                .buttonStyle(GrowingButtonStyle())
                Spacer()
                Image(systemName: "plus.message")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            ScrollView {
                VStack (spacing: 16) {
                    ForEach(chatMessages) { chat in
                        if chat.isBot {
                            BotChatView(chat.message)
                        } else {
                            UserChatView(chat.message)
                        }
                    }
                }
            }
            
            HStack {
                Image(systemName: "plus")
                    .padding(.trailing)
                TextField("",text: $inputText, prompt: Text("What's your thoughts"))
                Image(systemName: "microphone")
                    .padding(.leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.gray.opacity(0.2))
            )
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            BottomSheetContentView(
                onClicked: { model in
                    
                }
            )
                .presentationDetents([.large])
        }
    }
    
    struct BotChatView: View {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        var body: some View {
            HStack(alignment: .bottom) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.blue.opacity(0.2))
                    Image(systemName: "lasso.badge.sparkles")
                        .foregroundColor(.blue)
                }
                Text(message)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.opacity(0.2))
                    )
                Spacer()
            }
            .padding(.trailing)
        }
    }
    
    struct UserChatView: View {
        let message: String
        
        init(_ message: String) {
            self.message = message
        }
        
        var body: some View {
            HStack {
                Spacer()
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    )
            }
            .padding(.leading)
        }
    }
}

struct AIModel: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.description = description
    }
}

private struct BottomSheetContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchInput = ""
    @State private var selectedModel: AIModel?
    
    let onClicked: (AIModel) -> Void
    
    private let modelList: [AIModel] = [
        AIModel(title: "GPT 4", description: "Fastest, most capable model"),
        AIModel(title: "GPT 4", description: "Fastest, most capable model"),
        AIModel(title: "GPT 4", description: "Fastest, most capable model"),
        AIModel(title: "GPT 4", description: "Fastest, most capable model"),
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Select Model")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.gray.opacity(0.3)))
                }
                .buttonStyle(GrowingButtonStyle())
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                TextField("", text: $searchInput, prompt: Text("Search models.."))
            }
            .padding(10)
            .background(.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack() {
                ForEach(modelList) { item in
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.blue)
                            .padding(6)
                            .background(.blue.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(.headline))
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        if selectedModel?.id == item.id {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(selectedModel == item ? .blue: .white, lineWidth: 3)
                    )
                    .onTapGesture {
                        selectedModel = item
                        onClicked(item)
                        dismiss()
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
//    BottomSheetContentView()
    ChatView()
}
