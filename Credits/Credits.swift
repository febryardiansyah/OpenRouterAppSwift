//
//  Credits.swift
//  Credits
//
//  Created by Bank Indonesia on 27/07/26.
//

import WidgetKit
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct RemainingCredit: Codable {
    let totalCredits: Double
    let totalUsage: Double
    
    enum CodingKeys: String, CodingKey {
        case totalCredits = "total_credits"
        case totalUsage = "total_usage"
    }
}

struct RemainingCreditResponse: Codable {
    let data: RemainingCredit
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CreditsEntry {
        CreditsEntry(totalCredits: 0.0, totalUsage: 0.0, date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (CreditsEntry) -> ()) {
        let entry = CreditsEntry(totalCredits: 10.0, totalUsage: 5.0, date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [CreditsEntry] = []
        
        guard KeyChainManager.shared.getApiKey() != nil else {
            let entry = CreditsEntry(totalCredits: 0.0, totalUsage: 0.0, date: Date(), errorMessage: "API key not valid")
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
            return
        }

        Task {
            do {
                let response: RemainingCreditResponse = try await ApiClient.shared.request(endpoint: "credits")
                let entry = CreditsEntry(totalCredits: response.data.totalCredits, totalUsage: response.data.totalUsage, date: Date())
                let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                
                completion(timeline)
            } catch {
                let entry = CreditsEntry(totalCredits: 0.0, totalUsage: 0.0, date: Date(), errorMessage: error.localizedDescription)
                let timeline = Timeline(entries: [entry], policy: .never)
                completion(timeline)
            }
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct CreditsEntry: TimelineEntry {
    let totalCredits: Double
    let totalUsage: Double
    let date: Date
    let errorMessage: String?
    
    init(totalCredits: Double, totalUsage: Double, date: Date, errorMessage: String? = nil) {
        self.totalCredits = totalCredits
        self.totalUsage = totalUsage
        self.date = date
        self.errorMessage = errorMessage
    }
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
                        Text("OpenRouter")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                        Text("Total Credits")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }

                Text(entry.errorMessage ?? "$\(entry.totalCredits.formatNumber())")
                    .font(.system(size: entry.errorMessage != nil ? 12 : 26, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Divider()

                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Usage")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        Text("$\(entry.totalUsage.formatNumber())")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }

                    Spacer(minLength: 0)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("Left")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                        Text("$\((entry.totalCredits - entry.totalUsage).formatNumber())")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.05, green: 0.38, blue: 0.92))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(widgetTertiaryFill)
                        .frame(height: 6)
                    Capsule()
                        .fill(Color(red: 0.05, green: 0.38, blue: 0.92))
                        .frame(width: barWidth * 0.42, height: 6)
                }
            }
        }
    }
}

private var widgetTertiaryFill: Color {
#if canImport(UIKit)
    return Color(uiColor: .systemGray5)
#elseif canImport(AppKit)
    return Color(nsColor: .separatorColor).opacity(0.2)
#else
    return Color.gray.opacity(0.2)
#endif
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
        .configurationDisplayName("OpenRouter Credit Widget")
        .description("Show OpenRouter credit usage")
        .supportedFamilies([
            .systemSmall
        ])
    }
}

extension Double {
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}

#Preview(as: .systemSmall) {
    Credits()
} timeline: {
    CreditsEntry(totalCredits: 10.0, totalUsage: 5.0, date: Date())
    CreditsEntry(totalCredits: 0.0, totalUsage: 0.0, date: Date(), errorMessage: "API key is not valid")
}
