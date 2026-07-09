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
                VStack(alignment: .leading, spacing: 32) {
                    ApiConfigurationItem()
                    AppearanceItem()
                    UsageStats()
                    About()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Settings")
        }
    }
    
    private struct ApiConfigurationItem: View {
        @State private var inputKey = ""
        @State private var hasSavedKey = false
        @State private var showSuccessAlert = false
        
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
                            
                            SecureField("", text: $inputKey, prompt: Text("Input your API key here"))
                                .onSubmit {
                                    print("API_KEY \(inputKey)")
                                    
                                    guard !inputKey.isEmpty else {
                                        return
                                    }
                                    
                                    KeyChainManager.shared.saveApiKey(inputKey)
                                    hasSavedKey = true
                                    showSuccessAlert = true
                                    
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            
                            if hasSavedKey {
                                Button(role: .destructive, action: {
                                    inputKey = ""
                                    KeyChainManager.shared.removeApiKey()
                                    hasSavedKey = false
                                }) {
                                    Text("Remove key")
                                }
                            }
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
            .onAppear(perform: {
                if let savedKey = KeyChainManager.shared.getApiKey() {
                    inputKey = savedKey
                    hasSavedKey = true
                }
            })
            .alert("API key saved", isPresented: $showSuccessAlert, actions: {
                Button("OK", role: .cancel) {
                    
                }
            })
        }
    }
    
    private struct AppearanceItem: View {
        @AppStorage("isDarkMode") private var isDarkMode = false
        @State private var isHighContrast = false
        
        var body: some View {
            CardWithHeader("APPEARANCE", spacing: 10) {
                RowItem(icon: "moon") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Divider()
                
                RowItem(icon: "moonphase.first.quarter", iconBackgroundColor: .orange) {
                    Toggle("High Contrast", isOn: $isHighContrast)
                }
            }
        }
    }
    
    private struct UsageStats: View {
        var body: some View {
            CardWithHeader("USAGE STATS", spacing: 10) {
                RowItem(icon: "gauge.chart.lefthalf.righthalf", iconBackgroundColor: .green) {
                    Text("Token Used")
                    Spacer()
                    Text("4,521")
                }
                
                Divider()
                
                RowItem(icon: "dollarsign.ring", iconBackgroundColor: .mint) {
                    Text("Estimated Cost")
                    Spacer()
                    Text("$4,5")
                }
            }
        }
    }
    
    private struct About: View {
        var body: some View {
            CardWithHeader("ABOUT", spacing: 10, alignment: .center) {
                RowItem(icon: "questionmark.circle", iconBackgroundColor: .gray) {
                    Text("Help & Support")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                }
                
                Divider()
                
                RowItem(icon: "shield.lefthalf.filled", iconBackgroundColor: .gray) {
                    Text("Privacy Policy")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                }
                
                Divider()
                
                HStack(spacing: 34) {
                    Text("Version")
                    Text("1.0.4 (Build 42)")
                }
            }
        }
    }
    
    private struct RowItem<Content:View>: View {
        let icon: String
        let iconBackgroundColor: Color
        let content: Content
        
        init(icon: String, iconBackgroundColor: Color = .purple, @ViewBuilder content: () -> Content) {
            self.icon = icon
            self.iconBackgroundColor = iconBackgroundColor
            self.content = content()
        }
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(iconBackgroundColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                content
            }
        }
    }
}

#Preview {
    SettingsView()
}
