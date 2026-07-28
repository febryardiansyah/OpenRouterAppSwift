# OpenRouter Swift App

SwiftUI iOS client for OpenRouter. The app lets you browse models, chat with a selected model, view model details, and manage chat history. API credentials are stored locally in the iOS Keychain.

## Features
- Chat with OpenRouter models and persist messages locally with SwiftData.
- Search and select models, plus view model detail (context length, modality, pricing).
- History tab with grouped chat sessions and deletion support.
- Settings for API key management, usage credits, and appearance toggles.
- Remaining credits surface on iOS Widget and macOS status bar for quick glance access.

## Tech Stack
- SwiftUI, Swift Concurrency, SwiftData
- OpenRouter REST API
- KeychainAccess (SPM)

## Requirements
- Xcode 15+ (SwiftData requires iOS 17+)
- An OpenRouter API key

## Setup
1. Open `openrouter_app_swift.xcodeproj` in Xcode.
2. Select a simulator or device.
3. Build and run the app.
4. Go to Settings and paste your OpenRouter API key.

## Release Build
### Run Locally (Debug)
1. Open `openrouter_app_swift.xcodeproj` in Xcode.
2. Select a simulator or connected iPhone.
3. Press Run (`Cmd + R`).

### Build Locally (Release)
In Xcode:
1. Select scheme `openrouter_app_swift`.
2. Open `Product` -> `Scheme` -> `Edit Scheme...` and set `Run`/`Archive` to `Release`.
3. Use `Product` -> `Build` for a local Release build, or `Product` -> `Archive` for distribution.

For iPhone First-time device trust:
`On iPhone: Settings → General → VPN & Device Management → trust your developer certificate.`

From Terminal:

```bash
# iOS archive
xcodebuild \
  -project "openrouter_app_swift.xcodeproj" \
  -scheme "openrouter_app_swift" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "build/OpenRouter-iOS.xcarchive" \
  archive

# macOS archive
xcodebuild \
  -project "openrouter_app_swift.xcodeproj" \
  -scheme "openrouter_app_swift" \
  -configuration Release \
  -destination "generic/platform=macOS" \
  -archivePath "build/OpenRouter-macOS.xcarchive" \
  archive

# export iOS (.ipa)
xcodebuild -exportArchive \
  -archivePath "build/OpenRouter-iOS.xcarchive" \
  -exportOptionsPlist "ExportOptions-iOS.plist" \
  -exportPath "build/iOS"

# export macOS (.app)
xcodebuild -exportArchive \
  -archivePath "build/OpenRouter-macOS.xcarchive" \
  -exportOptionsPlist "ExportOptions-macOS.plist" \
  -exportPath "build/macOS"
```

You can also export/sign from Xcode Organizer (`Window` -> `Organizer`).

`ExportOptions-*.plist` must match your method (for example `app-store`, `ad-hoc`, or `developer-id`) and signing setup.

## API Usage
Requests are sent to `https://openrouter.ai/api/v1` with a Bearer token. The app calls:
- `GET /models` for model browsing and search.
- `POST /chat/completions` to send chat messages.
- `GET /credits` to show remaining credits.
- `GET /model/{author}/{slug}` for model detail.

## Notes
- API keys are stored locally in Keychain and never sent anywhere except OpenRouter.
- If the API key is missing or invalid, requests fail with an error message in the UI.
