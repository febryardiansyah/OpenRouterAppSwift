//
//  ChatView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 02/07/26.
//

import SwiftUI

struct ChatView: View {
    @State var inputText = ""
    
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
                    .foregroundColor(.blue)
                Spacer()
                HStack {
                    Text("Claude 3.5")
                    Image(systemName: "chevron.down")
                }
                Spacer()
                Image(systemName: "plus.message")
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

#Preview {
    ChatView()
}
