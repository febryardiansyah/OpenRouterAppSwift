import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \HistoryItem.createdAt, order: .reverse) private var histories: [HistoryItem]
    @EnvironmentObject var appState: AppStateViewModel
    
    enum HistorySection: String, CaseIterable, Identifiable {
        case today = "Today"
        case yesterday = "Yesterday"
        case lastWeek = "Last Week"

        var id: String { rawValue }
    }

    private var groupedItems: [HistorySection: [HistoryItem]] {
        return Dictionary(grouping: histories, by: { section(for: $0.createdAt) })
    }

    private func section(for date: Date) -> HistorySection {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return .today
        }
        if calendar.isDateInYesterday(date) {
            return .yesterday
        }
        return .lastWeek
    }
    
    var body: some View {
        NavigationStack {
            if histories.isEmpty {
                VStack {
                    Spacer()
                    Text("No history yet.")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .navigationTitle("History")
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(HistorySection.allCases) { section in
                            if let items = groupedItems[section], !items.isEmpty {
                                ItemView(section.rawValue, items: items)
                            }
                        }
                        .onDelete(perform: { offset in
                            for index in offset {
                                let section = HistorySection.allCases[index]
                                for item in groupedItems[section]! {
                                    HistoryRepository.shared.deleteItem(item: item, in: context)
                                }
                            }
                        })
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(UIColor.systemBackground))
                .navigationTitle("History")
                .toolbar(content: {
                    ToolbarItem(content: {
                        Button( action: {
                            HistoryRepository.shared.clearAllHistory(items: histories, in: context)
                            appState.historyItem = nil
                        }, label: {
                            Text("Clear all history")
                        })
                    })
                })
            }
        }
    }

    struct ItemView: View {
        let headerTitle: String
        let items: [HistoryItem]
        
        @EnvironmentObject private var appState: AppStateViewModel

        init(_ headerTitle: String, items: [HistoryItem]) {
            self.headerTitle = headerTitle
            self.items = items
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(headerTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.secondary)

                VStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]

                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)

                                Text(item.lastMessage)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                                .padding(.top, 4)
                        }
                        .padding(16)
                        .onTapGesture {
                            appState.selectedTab = 0
                            appState.historyItem = item
                        }

                        if index < items.count - 1 {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
            }
        }
    }
}

#Preview {
    HistoryView()
}
