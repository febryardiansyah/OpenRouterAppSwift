//
//  Credits.swift
//  Credits
//
//  Created by Bank Indonesia on 27/07/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct CreditsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let barWidth = max(0, totalWidth - 36)

            VStack(alignment: .leading, spacing: 8) {
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
                        Text("Openrouter")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                        Text("Total Credits")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(.secondaryLabel))
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }

                Text("$2.00")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color(.label))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Divider()

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Usage")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(.secondaryLabel))
                            .lineLimit(1)
                        Text("$1.24")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(.label))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }

                    Spacer(minLength: 0)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("Left")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                        Text("$0.76")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    Capsule()
                        .fill(Color(red: 0.05, green: 0.38, blue: 0.92))
                        .frame(width: barWidth * 0.42, height: 6)
                }
            }
        }
    }
}

struct Credits: Widget {
    let kind: String = "Credits"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CreditsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CreditsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    Credits()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
