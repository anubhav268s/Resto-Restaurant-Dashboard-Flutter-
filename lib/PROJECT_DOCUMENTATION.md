# Resto Project Documentation

This document provides a comprehensive overview of the Resto project, including its purpose, features, technical architecture, and development roadmap.

**Last Updated:** June 23, 2026

## 1. Project Overview

Resto is a modern, cross-platform dashboard application built with Flutter. It is designed for small restaurant owners to provide a centralized and intuitive interface for tracking key business metrics. The application focuses on clear data visualization and lightweight tools to support daily operations.

## 2. Key Features

The application is structured around several core business areas, each represented by a dedicated screen:

*   **Dashboard**: A central hub that displays real-time Key Performance Indicators (KPIs) and trend charts for a quick overview of the restaurant's performance.
*   **Earnings Analysis**: Provides detailed breakdowns of earnings on a daily, weekly, or monthly basis.
*   **Ads & Campaigns**: Tracks advertising expenditure and analyzes the performance of marketing campaigns.
*   **Discounts & Coupons**: Monitors the usage and financial impact of promotional discounts and coupons.
*   **Charges & Commissions**: Breaks down various operational charges and fees.
*   **Refunds & Cancellations**: Analyzes losses and identifies patterns in refunds and order cancellations.
*   **Profile & Settings**: A section for user account management, app settings (like theme switching), and information about the application.

## 3. Technical Architecture

Resto is built using Flutter, enabling a single codebase to target mobile, web, and desktop platforms.

### 3.1. Platform Support

*   **Mobile**: Android & iOS.
*   **Desktop**: Windows and Linux, with native runners implemented in C++.

### 3.2. Frontend (Flutter)

*   **UI Framework**: The user interface is built entirely with Flutter, featuring a custom animated floating navigation bar.
*   **State Management**: The current implementation uses `StatefulWidget` and `setState` for local state management. The development plan includes migrating to `Riverpod` for a more scalable solution.
*   **Dependencies**:
    *   `fl_chart`: For rendering charts and visualizations.
    *   `google_fonts`: For custom typography.
*   **Theming**: The app features a custom, dual-theme system (`AppTheme.light` and `AppTheme.dark`) that allows users to switch between light and dark modes.

### 3.3. Desktop Integration (Windows & Linux)

*   **Windows Runner**: A standard Win32 app hosts the Flutter content, with the entry point at `windows/runner/main.cpp`. The build is managed by CMake.
*   **Linux Runner**: The Linux version uses a C++ runner built with GTK, also managed by CMake.

## 4. Project Structure

The project follows a standard Flutter layout, with additional directories for desktop platforms.

```
Resto/
├── android/              # Android host app
├── ios/                  # iOS host app
├── lib/                  # Main Dart source code
│   ├── main.dart         # App entry point
│   ├── screens/          # Feature screens
│   └── widgets/          # Shared UI components
├── linux/                # Linux host app (C++/CMake)
├── windows/              # Windows host app (C++/CMake)
├── pubspec.yaml          # Dependencies
└── README.md             # Project setup guide
```

## 5. Code Quality and Tooling

*   **Linting**: The project uses the `flutter_lints` package to enforce a recommended set of linting rules, configured in `analysis_options.yaml`.
*   **Build System**: Flutter's build tools are used for mobile development, while CMake is used for the native desktop runners on both Windows and Linux.

## 6. Development Roadmap

The `NEXT_STEPS.md` file outlines the plan for evolving the application. Key upcoming tasks include:

### Week 1: State Management Refactor
*   **Goal**: Replace the current `setState` logic in `main.dart` with a more robust state management solution.
*   **Action**: Install `flutter_riverpod` and create providers for managing application state, such as filters and asynchronous data.
*   **Target**: Convert `_HomeScreenState` to a `ConsumerStatefulWidget`.

### Week 2: Data Models & API Integration
*   **Goal**: Define the data structures and set up the networking layer.
*   **Action**:
    1.  Create data models for metrics, dashboard data, etc., in `lib/core/models/`.
    2.  Set up a `Dio` client for making API calls.
    3.  Create an `ApiService` to handle fetching data from the backend.

### Week 3: Connect UI to Live Data
*   **Goal**: Replace hardcoded UI components with data-driven widgets.
*   **Action**:
    1.  Update screens (e.g., `DashboardScreen`) to use `Consumer` widgets.
    2.  Use `ref.watch` to listen to provider state changes and rebuild the UI.
    3.  Implement loading and error states (`LoadingShimmer`, `ErrorWidget`) for a better user experience during data fetching.

### Week 4: Testing & Polish
*   **Goal**: Ensure application stability and performance.
*   **Action**:
    1.  Run `flutter test` to verify logic.
    2.  Use Flutter DevTools for performance profiling.
    3.  Build and test a release version of the application.

## 7. Code Improvements

As part of ongoing development, several small but important code quality improvements should be addressed.

### Deprecation Warning in `main.dart`

The `withOpacity()` method is the correct and current way to set color opacity in Flutter. The project should be standardized to use it.

**Example Correction in `/Users/boss/Projects/Resto/lib/main.dart`:**

```dart
// Incorrect
color: currentTheme.colorScheme.primary.withValues(alpha: 0.12),

// Correct
color: currentTheme.colorScheme.primary.withOpacity(0.12),
```

### Unnecessary `toList()` calls

Spread operators in Dart can directly iterate over an `Iterable`. Calling `.toList()` before spreading is redundant and can be removed for cleaner code.

**Example:**

```dart
// Before
children: [
  ...list.map((item) => widget(item)).toList(),
]

// After
children: [
  ...list.map((item) => widget(item)),
]
```

---