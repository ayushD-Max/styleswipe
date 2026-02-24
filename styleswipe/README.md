# StyleSwipe

StyleSwipe is a Flutter application developed for the Flutter Developer Round 2 Build Challenge.  
The app demonstrates practical mobile development skills including API integration, state management, navigation, user interaction, local persistence, and WebView browsing with history tracking.

---

## Features

- Dynamic product feed powered by FakeStoreAPI
- Product discovery using swipe interactions
- Like / Dislike preference system
- Persistent local storage of user preferences
- Product detail screen
- In-app browser using WebView
- Browsing history tracking with timestamps
- Search and category filtering
- Smooth animations and transitions
- Support for Light and Dark themes
- Haptic feedback for enhanced interaction experience

---

## Functional Highlights

### Product Feed
- Fetches live product data from FakeStoreAPI
- Displays product image, title, and price
- Handles loading and error states

### Style Preference Interaction
- Like / Dislike functionality
- Immediate UI updates
- Preferences stored locally

### Swipe Discovery
- Swipe right → Like
- Swipe left → Dislike
- Physics-based card animations

### Product Detail Screen
- Expanded product information
- Navigation to in-app browser

### In-App Browser
- WebView integration
- Back / Forward / Refresh controls
- URL tracking

### Browsing History
- Stores visited URLs with timestamps
- Displays history list
- Clear history option

---

## Tech Stack

- Framework: Flutter (latest stable)
- State Management: GetX
- Dependency Injection: GetX
- API Requests: http
- Local Storage: SharedPreferences
- Animations: flutter_animate
- Image Handling: cached_network_image
- Swipe Interaction: swipe_cards
- WebView: webview_flutter

---

## Architecture

The project follows a modular structure with separation of concerns:

lib/
├── models/
├── services/
├── controllers/
├── screens/
├── widgets/
├── theme/
└── main.dart

Business logic, UI, and data handling are structured independently to improve maintainability and scalability.

---

## State Management

State management is implemented using GetX.

Reasons for choosing GetX:
- Lightweight and minimal boilerplate
- Reactive UI updates
- Built-in dependency injection
- Simplified navigation

Controllers manage:
- Product data
- Like / Dislike state
- Browsing history

---

## Data Persistence

Local persistence is implemented using SharedPreferences.

Persisted data includes:
- Liked product IDs
- Disliked product IDs
- Browsing history (URL + timestamp)

All preferences persist across app restarts.

---

## Loading & Error Handling

- Loading indicators during API calls
- Error UI for failed requests
- Retry mechanisms
- Defensive async handling

---

## Navigation

Navigation is handled using GetX navigation.

Implemented flows:
- Feed → Detail Screen
- Detail → Browser
- Browser → History

---

## What I Would Improve With More Time

- Offline caching using Hive or Isar
- Pagination / lazy loading
- Unit and widget testing
- Enhanced micro-interactions
- Improved browser metadata (page titles, favicons)
- Advanced filtering and sorting

---

## Approximate Time Spent

Total time spent: **6 HR**

---

## Getting Started

### Prerequisites
- Flutter SDK installed
- Android Studio / VS Code

### Installation

```bash
git clone https://github.com/ayushD-Max/styleswipe.git
cd styleswipe
flutter pub get
flutter run