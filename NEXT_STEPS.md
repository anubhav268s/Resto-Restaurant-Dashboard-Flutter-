# Resto Development - Next Steps & Implementation Guide

## Immediate Tasks (This Week)

### 1. Run the App & Verify UI ✅ FIRST
```bash
cd /Users/boss/Desktop/resto
flutter run
```
**Expected Result:** App should launch with Dashboard screen showing all UI elements

---

### 2. Fix Deprecation Warnings (Priority: HIGH)
**Issue:** `withOpacity()` is deprecated
**Solution:** Replace all `withOpacity()` calls with `.withValues()`

**Locations in `lib/main.dart`:**
- Line 1237, 1244, 1333, 1456

**Pattern:**
```dart
// ❌ OLD
Colors.white.withOpacity(0.7)

// ✅ NEW
Colors.white.withValues(alpha: 0.7)
```

---

### 3. Remove Unused `toList()` Calls (Priority: MEDIUM)
**Issue:** Unnecessary `.toList()` in spread operators
**Locations:** Lines 1534, 1596, 1749, 1828, 1901

**Pattern:**
```dart
// ❌ OLD
children: [
  ...list.map((item) => widget(item)).toList(),
]

// ✅ NEW
children: [
  ...list.map((item) => widget(item)),
]
```

---

## Week 1: State Management Setup

### 1. Install Riverpod
```bash
flutter pub add riverpod flutter_riverpod
```

### 2. Create Provider Structure
**File:** `lib/core/providers/`
```dart
// dashboard_provider.dart
final dashboardMetricsProvider = FutureProvider((ref) async {
  // Fetch dashboard data
  return mockDashboardData;
});

final selectedDateProvider = StateProvider((ref) => 'Latest Week');
final selectedPlatformProvider = StateProvider((ref) => 'Zomato');
final selectedViewByProvider = StateProvider((ref) => 'Restaurant');
final selectedOutletProvider = StateProvider((ref) => 'All outlets');
```

### 3. Update HomeScreen to Use Riverpod
**Current:** `_HomeScreenState` uses `ValueNotifier`
**Target:** Use `ConsumerStatefulWidget` with `ref`

---

## Week 2: Data Models & API Setup

### 1. Create Data Models
**File:** `lib/core/models/`

```dart
// metric_card_model.dart
class MetricCard {
  final String title;
  final String value;
  final String badge;
  final bool isPositive;
  
  MetricCard({...});
}

// dashboard_data_model.dart
class DashboardData {
  final List<MetricCard> metrics;
  final List<MetricCard> secondaryMetrics;
  final PlatformComparison platformComparison;
  
  DashboardData({...});
}
```

### 2. Setup Dio for API Calls
**File:** `lib/core/networking/api_client.dart`
```dart
final apiClientProvider = Provider((ref) {
  return Dio()
    ..options.baseUrl = 'https://api.resto.com'
    ..interceptors.add(LoggingInterceptor());
});
```

### 3. Create API Service
**File:** `lib/core/networking/api_service.dart`
```dart
class ApiService {
  final Dio _dio;
  
  Future<DashboardData> getDashboardData({
    required String dateRange,
    required String platform,
  }) async {
    // API call implementation
  }
}
```

---

## Week 3: Connect UI to Data

### 1. Update Filter Panel
**File:** `lib/features/dashboard/widgets/filter_panel.dart`

Add onApply callback:
```dart
ElevatedButton.icon(
  onPressed: () {
    // Trigger data fetch with new filters
    ref.refresh(dashboardMetricsProvider);
  },
  label: const Text('Apply filters'),
),
```

### 2. Convert StaticWidgets to Data-Driven
**Update:** `DashboardScreen`, `EarningsScreen`, `AdsScreen`, etc.

From:
```dart
Wrap(spacing: 16, children: const [
  StatCard(data: StatCardData(...)),
  // hardcoded
])
```

To:
```dart
Consumer(builder: (context, ref, child) {
  final data = ref.watch(dashboardMetricsProvider);
  return data.when(
    data: (metrics) => Wrap(
      children: metrics.map((m) => StatCard(data: m)).toList(),
    ),
    loading: () => const LoadingShimmer(),
    error: (e, st) => const ErrorWidget(),
  );
})
```

### 3. Add Loading & Error States
**Create:** `lib/shared/widgets/loading_shimmer.dart`
**Create:** `lib/shared/widgets/error_widget.dart`

---

## Week 4: Testing & Polish

### 1. Run Tests
```bash
flutter test
```

### 2. Performance Profiling
```bash
flutter run --profile
```

### 3. Build Release APK
```bash
flutter build apk --release
```

---

## File Creation Checklist

### Core Structure
- [ ] `lib/core/theme/app_theme.dart` - Extract theme from main.dart
- [ ] `lib/core/constants/app_constants.dart` - Colors, endpoints, etc.
- [ ] `lib/core/providers/filter_providers.dart` - Riverpod providers

### Features
- [ ] `lib/features/dashboard/providers/dashboard_provider.dart`
- [ ] `lib/features/earnings/providers/earnings_provider.dart`
- [ ] `lib/features/advertisements/providers/ads_provider.dart`
- [ ] `lib/features/charges/providers/charges_provider.dart`
- [ ] `lib/features/discounts/providers/discounts_provider.dart`
- [ ] `lib/features/refunds/providers/refunds_provider.dart`

### Models
- [ ] `lib/core/models/metric_card.dart`
- [ ] `lib/core/models/dashboard_data.dart`
- [ ] `lib/core/models/chart_data.dart`
- [ ] `lib/core/models/platform_data.dart`
- [ ] `lib/core/models/refund_data.dart`

### Networking
- [ ] `lib/core/networking/api_client.dart`
- [ ] `lib/core/networking/api_service.dart`
- [ ] `lib/core/networking/interceptors.dart`

### Widgets
- [ ] `lib/shared/widgets/loading_shimmer.dart`
- [ ] `lib/shared/widgets/error_widget.dart`
- [ ] `lib/shared/widgets/empty_state.dart`
- [ ] `lib/shared/widgets/custom_text_field.dart`
- [ ] `lib/shared/widgets/custom_button.dart`

---

## Code Patterns to Follow

### Using Riverpod for Async Data
```dart
// Read-only (get data)
final value = ref.watch(provider);

// Modify state (filters)
ref.read(selectedDateProvider.notifier).state = 'Last Month';

// Refresh data
ref.refresh(dashboardMetricsProvider);
```

### Error Handling Pattern
```dart
final data = ref.watch(myProvider);

data.whenData((value) {
  // Success
}).whenError((error, stack) {
  // Error handling
});
```

### Mock Data for Development
```dart
final mockDashboardData = DashboardData(
  metrics: [
    MetricCard(title: 'Gross Order Value', value: '₹4,28,500', badge: '+12.3%'),
    // ... more metrics
  ],
);
```

---

## Running & Testing Commands

```bash
# Check project structure
find lib -type f -name '*.dart' | head -20

# Analyze code quality
flutter analyze

# Run tests
flutter test

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Clear build artifacts
flutter clean
```

---

## Important Notes

1. **Mock Data:** Use mock data until API is ready. Easy to swap later.
2. **Provider Pattern:** All async operations should be Riverpod providers
3. **Reusability:** Extract widgets to `lib/shared/` if used in multiple places
4. **Responsiveness:** Test on different screen sizes using device emulator

---

## Success Checklist

- [ ] App runs without errors
- [ ] All deprecation warnings fixed
- [ ] Riverpod setup complete
- [ ] Data models created
- [ ] API service implemented
- [ ] At least 1 screen connected to providers
- [ ] Tests passing
- [ ] Release APK builds successfully

---

**Last Updated:** 1 June 2026
**Target Completion:** 15 July 2026
