import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ChatView: View {
    @State var inputText = ""
    @State var showSheet = false
    @State var selectedModel: AIModel? = nil
    
    @State var chatMessages: [ChatMessage] = []
    
    @State var showFilePicker = false
    @State var selectedFile = ""
    
    @StateObject private var sendMessageViewModel = SendMessageViewModel()
    @StateObject private var clarifyMessageViewModel = ClarifyMessageTitleViewModel()
    
    @State private var toast: ToastMessage? = nil
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var appState: AppStateViewModel
    
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
                .foregroundStyle(.foreground)
                .buttonStyle(GrowingButtonStyle())
                Spacer()
                Image(systemName: "plus.message")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        appState.historyItem = nil
                    }
            }
            
            ScrollViewReader { proxy in
                if !chatMessages.isEmpty {
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
                    .onAppear {
                        withAnimation {
                            if let lastId = chatMessages.last?.id {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                } else {
                    Text("Start chatting..")
                        .frame(maxHeight: .infinity)
                        .font(.subheadline.italic())
                        .foregroundStyle(.foreground)
                }
                
                HStack {
                    Image(systemName: "plus")
                        .padding(.trailing)
                        .onTapGesture {
                            showFilePicker.toggle()
                        }
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
                    Image(systemName: "paperplane")
                        .padding(.leading)
                        .onTapGesture {
                            Task {
                                await sendMessage()
                            }
                            
                            withAnimation {
                                if let lastId = chatMessages.last?.id {
                                    proxy.scrollTo(lastId, anchor: .bottom)
                                }
                            }
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.gray.opacity(0.2))
                )
            }
        }
        .padding()
        .showToast(toast: $toast)
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.directory]) { result in
            switch result {
            case .success(let url):
                guard url.startAccessingSecurityScopedResource() else {
                    return
                }

                selectedFile = url.lastPathComponent
                
                url.stopAccessingSecurityScopedResource()
            case .failure(let error):
                print("Failed to pick file \(error)")
            }
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                BottomSheetContentView(
                    selectedModel: $selectedModel,
                    onClicked: { model in
                        selectedModel = model
                        if let item = appState.historyItem {
                            try? HistoryRepository.shared.updateItem(item: item, selectedModel: selectedModel?.toPersistedAIModel(), in: context)
                        }
                    }
                )
            }
            .presentationDetents([.large])
        }
        .onChange(of: appState.historyItem) {
            selectedModel = appState.historyItem?.selectedModel.toAIModel()
            
            guard let _ = appState.historyItem else {
                chatMessages = []
                return
            }
            
            let sorted = appState.historyItem!.messages.sorted {$0.createdAt < $1.createdAt }
            chatMessages = sorted.map { item in
                ChatMessage(content: item.content, role: item.role)
            }
        }
    }
    
    private func sendMessage() async {
        chatMessages.append(
            ChatMessage(content: inputText, role: "user")
        )
        
        guard let selectedModelId = selectedModel?.id else {
            toast = ToastMessage(icon: "exclamationmark.triangle.fill", message: "You have to choose model first", tint: .secondary)
            chatMessages.remove(at: chatMessages.count - 1)
            return
        }
        
        let chatRequest = ChatRequest(
            model: selectedModelId,
            messages: chatMessages
        )
        
        chatMessages.append(
            ChatMessage(content: "Answering..", role: "assistant")
        )
        
        let historyItem: HistoryItem
        
        if let existing = appState.historyItem {
            historyItem = existing
        } else {
            await clarifyMessageViewModel.setTitle(for: chatMessages.first?.content ?? "New Chat")
            let title = clarifyMessageViewModel.title ?? "New Chat"
            
            let newHistoryItem = HistoryItem(title: title, lastMessage: inputText, selectedModel: selectedModel!.toPersistedAIModel())
            
//            HistoryRepository.shared.logAction(item: newHistoryItem, in: context)
            historyItem = newHistoryItem
//            appState.historyItem = historyItem
        }
        
        let userPersisted = PersistedChatMessage(content: inputText, role: "user", historyItem: historyItem)
        context.insert(userPersisted)
        try? context.save()
        
        inputText = ""
        
        await sendMessageViewModel.sendMessage(chatRequest: chatRequest)
        
        if let message = sendMessageViewModel.data?.message {
            chatMessages.remove(at: chatMessages.count - 1)
            chatMessages.append(
                message
            )
            
            let botPersisted = PersistedChatMessage(content: message.content, role: "asistant", historyItem: historyItem)
            context.insert(botPersisted)
            historyItem.lastMessage = message.content
            try? context.save()
        }
        
        if let error = sendMessageViewModel.errorMessage {
            chatMessages.remove(at: chatMessages.count - 1)
            chatMessages.append(
                ChatMessage(content: "\(error)", role: "assistant")
            )
            
            let botPersisted = PersistedChatMessage(content: error, role: "asistant", historyItem: historyItem)
            context.insert(botPersisted)
            historyItem.lastMessage = error
            try? context.save()
            print("\(error)")
        }
        
        if appState.historyItem == nil {
            appState.historyItem = historyItem
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
                    id: model.id
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
                                    isSelected: selectedModel?.id == item.id,
                                    id: item.id
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
        let id: String
        
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
                    
                    NavigationLink("Detail") {
                        let author = id.split(separator: "/").first ?? "unknown"
                        let slug = id.split(separator: "/").last ?? "unknown"
                        
                        ModelDetailView(
                            author: String(author), slug: String(slug)
                        )
                    }
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
                    .strokeBorder(isSelected ? .blue : .clear, lineWidth: 3)
            )
        }
    }
}

#Preview {
    @Previewable @StateObject var appState = AppStateViewModel()
    ChatView()
        .environmentObject(appState)
}
