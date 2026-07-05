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
    
    struct LocalChatMessage: Identifiable {
        var id: UUID
        var message: String
        var isBot: Bool
    }
    
    let chatMessages: [LocalChatMessage] = [
        LocalChatMessage(id: UUID(), message: "Hi", isBot: false),
        LocalChatMessage(id: UUID(), message: "Meeting Management - Tanggal Agenda Tidak disable Saat edit Agenda In Progress", isBot: true),
        LocalChatMessage(id: UUID(), message: "Custom images don’t provide a text baseline guide, so the bottom of the image aligns to the text view’s baseline", isBot: false),
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
                    .onSubmit {
                        Task {
                            await sendMessage()
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
        let request = ChatRequestList(
            messages: [
                ChatMessage(content: "What is the capital of France?", role: "user")
            ]
        )
        do {
            let response: ChatResponseChoice = try await ApiClient.shared.request(
                endpoint: "chat/completions",
                body: request
            )
            
            print("send message response \(response.choices.first?.content ?? "")")
        } catch {
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
    
    @State private var isLoading: Bool = true
    @State private var modelList: [AIModel] = []
    @State private var errorMessage: String? = nil
    
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
                            await fetchModels()
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
                if isLoading {
                    ProgressView("Fetching models")
                } else if let error = errorMessage {
                    Text(error).foregroundStyle(.red)
                } else {
                    ScrollView {
                        VStack() {
                            ForEach(modelList.filter { $0.id != selectedModel?.id}) { item in
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
            await fetchModels()
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
    
    private func fetchModels() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: AIModelResponse = try await ApiClient.shared.request(
                endpoint: "models",
                queryParams: [
                    "q": searchInput
                ]
            )
            self.modelList = response.data
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to fetch"
        }
    }
}

#Preview {
    ChatView()
}
