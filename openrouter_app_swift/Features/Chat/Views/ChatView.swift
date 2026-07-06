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
    @State var selectedModel: AIModel? = nil
    
    @State var chatMessages: [ChatMessage] = []
    
    @StateObject private var sendMessageViewModel = SendMessageViewModel()
    
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
                        Text(selectedModel?.name ?? "Choose Model")
                            .lineLimit(1)
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
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack (spacing: 16) {
                        ForEach(chatMessages) { chat in
                            if chat.role != "user" {
                                BotChatView(chat.content)
                            } else {
                                UserChatView(chat.content)
                            }
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "plus")
                        .padding(.trailing)
                    TextField("",text: $inputText, prompt: Text("What's your thoughts"))
                        .onSubmit {
                            Task {
                                await sendMessage()
                            }
                            
                            withAnimation {
                                if let lastId = chatMessages.last?.id {
                                    proxy.scrollTo(lastId, anchor: .bottom)
                                }
                            }
                        }
                    Image(systemName: "microphone")
                        .padding(.leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.gray.opacity(0.2))
                )
            }
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            BottomSheetContentView(
                selectedModel: $selectedModel,
                onClicked: { model in
                    selectedModel = model
                }
            )
            .presentationDetents([.large])
        }
    }
    
    private func sendMessage() async {
        chatMessages.append(
            ChatMessage(content: inputText, role: "user")
        )
        
        inputText = ""
        
        guard let selectedModelId = selectedModel?.id else {
            return
        }
        
        let chatRequest = ChatRequest(
            model: selectedModelId,
            messages: chatMessages
        )
        
        chatMessages.append(
            ChatMessage(content: "Answering..", role: "assistant")
        )
        
        do {
            try await sendMessageViewModel.sendMessage(chatRequest: chatRequest)
            
            if let message = sendMessageViewModel.data?.message {
                chatMessages.remove(at: chatMessages.count - 1)
                chatMessages.append(
                    message
                )
            }
        } catch {
            chatMessages.remove(at: chatMessages.count - 1)
            chatMessages.append(
                ChatMessage(content: "Failed to send message \(error)", role: "assistant")
            )
            print("Failed to send message \(error)")
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

private struct BottomSheetContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchInput = ""
    @Binding var selectedModel: AIModel?
    
    @StateObject private var viewModel = AIModelViewModel()
    
    let onClicked: (AIModel?) -> Void
    
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
                    .onSubmit {
                        Task {
                            await viewModel.fetchModels(query: searchInput)
                        }
                    }
            }
            .padding(10)
            .background(.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if let model = selectedModel {
                ModelItem(
                    name: model.name,
                    description: model.description,
                    isSelected: true,
                )
                .onTapGesture {
                    selectedModel = nil
                    onClicked(selectedModel)
                    dismiss()
                }
            }
            
            Group {
                if viewModel.isLoading {
                    ProgressView("Fetching models")
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red)
                } else {
                    ScrollView {
                        VStack() {
                            ForEach(viewModel.modelList.filter { $0.id != selectedModel?.id}) { item in
                                ModelItem(
                                    name: item.name,
                                    description: item.description,
                                    isSelected: selectedModel?.id == item.id
                                )
                                .onTapGesture {
                                    selectedModel = item
                                    onClicked(item)
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .task {
            await viewModel.fetchModels(query: searchInput)
        }
    }
    
    private struct ModelItem: View {
        let name: String
        let description: String
        let isSelected: Bool
        
        var body: some View {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.blue)
                    .padding(6)
                    .background(.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.system(.headline))
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(isSelected ? .blue: .white, lineWidth: 3)
            )
        }
    }
}

#Preview {
    ChatView()
}
