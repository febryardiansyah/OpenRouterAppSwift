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
                List {
                    ForEach(HistorySection.allCases) { section in
                        if let items = groupedItems[section], !items.isEmpty {
                            Section {
                                ForEach(items) { item in
                                    RowView(item: item)
                                }
                                .onDelete { offsets in
                                    for index in offsets {
                                        let item = items[index]
                                        HistoryRepository.shared.deleteItem(item: item, in: context)
                                    }
                                }
                            } header: {
                                Text(section.rawValue)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
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

    struct RowView: View {
        let item: HistoryItem

        @EnvironmentObject private var appState: AppStateViewModel

        var body: some View {
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
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture {
                appState.selectedTab = 0
                appState.historyItem = item
            }
        }
    }
}

#Preview {
    HistoryView()
}
