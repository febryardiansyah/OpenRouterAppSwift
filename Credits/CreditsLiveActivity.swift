//
//  CreditsLiveActivity.swift
//  Credits
//
//  Created by Bank Indonesia on 27/07/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CreditsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CreditsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CreditsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CreditsAttributes {
    fileprivate static var preview: CreditsAttributes {
        CreditsAttributes(name: "World")
    }
}

extension CreditsAttributes.ContentState {
    fileprivate static var smiley: CreditsAttributes.ContentState {
        CreditsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CreditsAttributes.ContentState {
         CreditsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CreditsAttributes.preview) {
   CreditsLiveActivity()
} contentStates: {
    CreditsAttributes.ContentState.smiley
    CreditsAttributes.ContentState.starEyes
}
