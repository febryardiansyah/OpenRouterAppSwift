//
//  SettingsView.swift
//  openrouter_app_swift
//
//  Created by Bank Indonesia on 02/07/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ApiConfigurationItem()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(.secondary.opacity(0.1))
            .navigationTitle("Settings")
        }
    }
    
    struct ApiConfigurationItem: View {
        var body: some View {
            VStack(spacing: 8) {
                CardWithHeader("API CONFIGURATION") {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "key.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        VStack(alignment: .leading, spacing: 6) {
                            Text("OpenRouter Key")
                                .font(.title3)
                                .foregroundStyle(.primary)
                            Text("••••••••••••••••••••••••••••••••")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    Divider()
                    HStack {
                        Text("Test Connection")
                            .font(.headline)
                            .foregroundStyle(Color.blue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 14)
                }
                
                Text("Your key is stored locally on your device and is never sent to our servers.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
