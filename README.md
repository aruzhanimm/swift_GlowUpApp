# GlowUp 💄

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS_17.0-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**GlowUp** is a premium mobile marketplace for skincare and makeup enthusiasts. Built with a focus on modern UI/UX (Dark/Neon aesthetic) and clean architecture. The app allows users to discover beauty products, read real-time reviews, and manage their favorites offline.

> **Note:** This project demonstrates advanced iOS development concepts including **MVVM Architecture**, **Offline-First Persistence**, and **Real-time Data Sync**.

---

## Screenshots

| Home Feed | Search & Filter | Product Details |
|:---:|:---:|:---:|
| <img src="docs/screenshots/home.png" width="250" alt="Home Screen"> | <img src="docs/screenshots/search.png" width="250" alt="Search Screen"> | <img src="docs/screenshots/details.png" width="250" alt="Details Screen"> |


---

## Key Features

* **Dark & Neon UI System:** A custom-built design system with deep blacks and neon accents for a premium feel.
* **Smart Search:** Debounced search functionality with category filtering (Mascara, Lipstick, Foundation, etc.) to minimize API calls.
* **Real-time Community:** Live reviews and comments powered by **Firebase Realtime Database**. Updates appear instantly across all devices.
* **Offline Favorites:** **Core Data** integration allows users to access their liked products even without an internet connection.
* **Secure Authentication:** User sign-up and login handling via **Firebase Auth**.
* **Deep Navigation:** Structured navigation flow from feed to detailed product views.

---

## Tech Stack

* **Language:** Swift 5
* **UI Framework:** SwiftUI
* **Architecture:** MVVM (Model-View-ViewModel) + Repository Pattern
* **Networking:** URLSession + async/await + Combine
* **Database (Local):** Core Data
* **Backend (BaaS):** Firebase (Auth, Realtime Database, Analytics, Crashlytics)
* **Image Caching:** Kingfisher
* **API:** Makeup API (REST)

---
## How to Run
**Clone the repository**

Bash
git clone [https://github.com/aruzhanimm/swift_GlowUpApp.git](https://github.com/aruzhanimm/swift_GlowUpApp.git)
cd swift_GlowUpApp
**Setup Firebase:**

This project uses Firebase. For security reasons, the GoogleService-Info.plist is excluded from the repository.

Create a project in Firebase Console.

Download your own GoogleService-Info.plist.

Drag and drop it into the root of the project in Xcode.

**Run:**

Open GlowUp.xcodeproj in Xcode.

Wait for Swift Package Manager to resolve dependencies.

Select your simulator (e.g., iPhone 15 Pro).

**Press Cmd + R.**

## Testing
The project includes Unit Tests covering:

Model decoding and JSON parsing.

Business logic (e.g., Currency conversion).

AuthViewModel validation logic.

To run tests, press Cmd + U in Xcode.
## Architecture

The project follows the **Clean Architecture** principles to ensure scalability and testability.

```text
GlowUp
├── App                 # Entry point (LaunchScreen logic)
├── Core                # Design System, Extensions, Logger
├── Data                # API Services, Models, Core Data Storage
├── Domain              # Business Logic
├── Presentation        # Views & ViewModels (MVVM)
    ├── Auth            # Login/SignUp
    ├── Home            # Feed & Details
    ├── Search          # Search logic
    ├── Favorites       # Offline storage view
    └── Profile         # Profile logic
└── Resources           # Assets
