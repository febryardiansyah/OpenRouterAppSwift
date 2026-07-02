//
//  HistoryView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 02/07/26.
//

import SwiftUI

struct HistoryView: View {
    enum HistorySection: String, CaseIterable, Identifiable {
        case today = "Today"
        case yesterday = "Yesterday"
        case lastWeek = "Last Week"

        var id: String { rawValue }
    }

    struct HistoryItem: Identifiable {
        let id = UUID()
        let title: String
        let lastMessage: String
        let section: HistorySection
    }

    private let historyItems: [HistoryItem] = [
        HistoryItem(
            title: "React Native Debugging",
            lastMessage: "Can you help me figure out why my FlatList isn't rendering items when I fetch data from an API?",
            section: .today
        ),
        HistoryItem(
            title: "API Endpoint Design",
            lastMessage: "Review this REST API structure for a user management system and suggest improvements.",
            section: .today
        ),
        HistoryItem(
            title: "Dinner Recipes",
            lastMessage: "I have chicken breasts, broccoli, and soy sauce. What's a quick 20-minute recipe?",
            section: .yesterday
        ),
        HistoryItem(
            title: "Email Draft: PTO Request",
            lastMessage: "Draft a professional email to my manager requesting time off from October 12th to 18th.",
            section: .lastWeek
        ),
        HistoryItem(
            title: "Explain Quantum Computing",
            lastMessage: "Explain the concept of quantum superposition as if I were a bright high-school student.",
            section: .lastWeek
        )
    ]

    private var groupedItems: [HistorySection: [HistoryItem]] {
        Dictionary(grouping: historyItems, by: \.section)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(HistorySection.allCases) { section in
                        if let items = groupedItems[section], !items.isEmpty {
                            ItemView(section.rawValue, items: items)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(.secondary.opacity(0.1))
            .navigationTitle("History")
        }
    }

    struct ItemView: View {
        let headerTitle: String
        let items: [HistoryItem]

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

                        if index < items.count - 1 {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white)
                )
            }
        }
    }
}

#Preview {
    HistoryView()
}
