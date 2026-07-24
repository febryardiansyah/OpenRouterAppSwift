# OpenRouter Swift App

SwiftUI iOS client for OpenRouter. The app lets you browse models, chat with a selected model, view model details, and manage chat history. API credentials are stored locally in the iOS Keychain.

## Features
- Chat with OpenRouter models and persist messages locally with SwiftData.
- Search and select models, plus view model detail (context length, modality, pricing).
- History tab with grouped chat sessions and deletion support.
- Settings for API key management, usage credits, and appearance toggles.

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

## API Usage
Requests are sent to `https://openrouter.ai/api/v1` with a Bearer token. The app calls:
- `GET /models` for model browsing and search.
- `POST /chat/completions` to send chat messages.
- `GET /credits` to show remaining credits.
- `GET /model/{author}/{slug}` for model detail.

## Project Structure
- `openrouter_app_swift/Core` shared services, networking, theme, and components.
- `openrouter_app_swift/Features/Chat` chat UI, view models, and repositories.
- `openrouter_app_swift/Features/History` SwiftData models and history UI.
- `openrouter_app_swift/Features/Settings` API key, credits, and appearance settings.
- `openrouter_app_swift/Features/ModelDetail` model detail UI and data.

## Notes
- API keys are stored locally in Keychain and never sent anywhere except OpenRouter.
- If the API key is missing or invalid, requests fail with an error message in the UI.
