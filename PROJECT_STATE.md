# App Name: Resto - Restaurant Management & Analytics

**Overall Completion:** 25%
**Last Updated:** 2 June 2026
**Target Platform:** Android (Flutter Mobile)

---

## 1. Project Architecture

### Technology Stack
- **Framework:** Flutter 3.41.5 + Dart 3.11.3
- **State Management:** Provider / Riverpod (To be implemented)
- **Database:** Hive / Isar (For local caching)
- **Networking:** Dio / HTTP (API Integration - To be implemented)
- **Charts & Analytics:** fl_chart
- **Typography:** Google Fonts (Inter)
- **Structure:** Feature-first architecture
  - `lib/features/` – Feature modules (dashboard, earnings, ads, charges, discounts, refunds)
  - `lib/core/` – Core services (networking, database, theme)
  - `lib/shared/` – Shared widgets & utilities

### Design System
- **Primary Color:** #22C55E (Green)
- **Dark Mode:** #090B14 (Background), #121826 (Cards)
- **Accent Colors:** 
  - Red: #EF4444 (Losses, Refunds)
  - Orange: #FBBf24 (Warnings)
  - Blue: Default action buttons

---

## 2. Core Setup (80% Complete)

- [x] Initialize Flutter project structure
- [x] Setup `pubspec.yaml` with dependencies (`fl_chart`, `google_fonts`)
- [x] Create base theme data (Dark mode primary)
- [x] Setup app entry point (`lib/main.dart`)
- [x] Basic navigation skeleton (Sidebar + Tab navigation)
- [ ] State management setup (Riverpod/Provider) – **IN PROGRESS**
- [ ] Network layer setup (Dio interceptors, base models)
- [ ] Local database setup (Hive/Isar models)
- [ ] Custom widget library (Cards, buttons, inputs)

---

## 3. Feature: Dashboard Screen (70% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Main layout with sidebar navigation
- [x] Filter panel (Date, Platform, View by, Venue)
- [x] Dashboard overview cards (KPIs)
  - [x] Gross Order Value
  - [x] Total Orders
  - [x] Avg Order Value
  - [x] Net Payout
- [x] Secondary metrics cards
  - [x] Ad Spend
  - [x] Platform Charges
  - [x] Discounts
  - [x] Refunds
  - [x] Net Margin
- [x] Platform comparison card (Zomato vs Swiggy)
- [x] Trends chart (Sales daily view)
- [x] AI Insights panel
- [ ] **Data Integration:** Mock data → Real API calls
- [ ] **Filter Logic:** Apply filters to data
- [ ] **Responsive:** Test on different screen sizes

---

## 4. Feature: Earnings Screen (60% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Sales, orders & ticket size analysis header
- [x] Stat cards (6 metrics)
  - [x] Gross Order Value
  - [x] Total Orders
  - [x] Avg Order Value
  - [x] Max Order Value
  - [x] Min Order Value
  - [x] Median Order Value
- [x] Trend analysis chart
- [x] AI Insights panel (5 insights)
- [ ] **Data Integration:** API endpoints for earnings data
- [ ] **Time-based filtering:** Hour-wise, day-wise breakdowns
- [ ] **Export functionality:** Download reports

---

## 5. Feature: Advertisements Screen (65% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Ad spend analysis & sales impact header
- [x] Stat cards (8 metrics)
  - [x] Total Ad Spend
  - [x] Total Ad Days
  - [x] Avg Spend / Day
  - [x] Sales (Ad Days)
  - [x] Sales (Non-ad)
  - [x] Avg Sales (Ad)
  - [x] Avg Sales (Non-ad)
  - [x] Sales Lift
- [x] Ad spend vs sales chart
- [x] AI Insights panel
- [x] Ads impact by outlet (comparison table)
- [x] Platform summary card
- [ ] **Data Integration:** Ad campaign data from Zomato/Swiggy APIs
- [ ] **Campaign Management:** Add/edit/pause campaigns
- [ ] **ROI Calculations:** Implement sales lift logic

---

## 6. Feature: Charges Screen (60% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Platform deductions, commission & cost analysis header
- [x] Stat cards (9 metrics)
  - [x] Gross Order Value
  - [x] Total Charges
  - [x] Effective Charge %
  - [x] Commission %
  - [x] Commission amount
  - [x] PG Charges
  - [x] Long Distance Fee
  - [x] Government Charges
  - [x] Other Charges
- [x] Charges trend chart
- [x] AI Insights panel
- [x] Platform charges comparison table
- [x] Outlet charges table
- [ ] **Data Integration:** Real charges data from platform
- [ ] **Breakdown Logic:** Show charge component breakdown
- [ ] **Alerts:** Notify when charges exceed threshold

---

## 7. Feature: Discounts Screen (60% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Coupon performance & funding split header
- [x] Stat cards (7 metrics)
  - [x] Gross Order Value
  - [x] Total Discount Burn
  - [x] Discount %
  - [x] Discount Contribution
  - [x] Discount Orders
  - [x] Discount Sales
  - [x] Avg Discount/Order
- [x] Discount trend chart
- [x] AI Insights panel
- [x] Coupon performance table (5 coupons)
- [x] Coupon contribution breakdown card
- [ ] **Data Integration:** Coupon usage data
- [ ] **Coupon Creation:** UI for creating new coupons
- [ ] **Performance Tracking:** Track coupon ROI

---

## 8. Feature: Refunds Screen (60% Complete)

**Status:** UI Complete, Logic Pending

### Screens/Components:
- [x] Refund losses, cancellations & problem areas header
- [x] Stat cards (8 metrics)
  - [x] Refund Amount
  - [x] Refund % of Sales
  - [x] Refunded Orders
  - [x] Total Loss
  - [x] Gross Order Value
  - [x] Cancellation Amount
  - [x] Cancellation %
  - [x] Total Orders
- [x] Refund & cancellation trends chart
- [x] AI Insights panel
- [x] Outlet refunds table
- [x] Platform refund split card
- [ ] **Data Integration:** Real refund data
- [ ] **Issue Analysis:** Root cause identification
- [ ] **Alerts:** High refund rate notifications

---

## 9. Navigation & Routing (100% Complete)

- [x] Bottom-tab / Sidebar navigation implemented
- [x] Screen sections: Dashboard, Earnings, Ads, Charges, Discounts, Refunds
- [ ] **Route Protection:** Implement auth checks
- [ ] **Deep Linking:** Support deep links for analytics
- [ ] **Back Button Handling:** Proper navigation state

---

## 10. Data Models & Backend Integration (0% Complete)

**Status:** Not Started

### Required Endpoints:
```
GET /api/dashboard/overview - Main KPIs
GET /api/dashboard/platform-comparison - Zomato vs Swiggy
GET /api/earnings/breakdown - Sales data by hour/day
GET /api/ads/campaigns - Ad campaign data
GET /api/ads/lift-analysis - Sales lift calculations
GET /api/charges/breakdown - Commission & fees breakdown
GET /api/discounts/coupons - Coupon performance
GET /api/refunds/analysis - Refund patterns
```

### Data Models to Implement:
- [ ] `Order` model (OrderValue, OrderCount, Platform)
- [ ] `MetricCard` model (title, value, badge, trend)
- [ ] `Campaign` model (AdSpend, Platform, Outlet, Lift)
- [ ] `Coupon` model (Code, BurnRate, Orders, Sales)
- [ ] `Refund` model (Amount, Reason, Outlet, Item)
- [ ] `User` model (Restaurant info, Outlets, Platforms)
- [ ] `Filter` model (DateRange, Platform, ViewBy, Outlet)

### Local Database Schemas (Hive/Isar):
- [ ] CachedMetrics
- [ ] CachedCampaigns
- [ ] CachedCoupons
- [ ] CachedRefunds
- [ ] SyncStatus (last_sync_time, sync_status)

---

## 11. UI Components Library (40% Complete)

### Completed:
- [x] StatCard widget
- [x] InfoCard widget
- [x] SectionHeader widget
- [x] FilterPanel with dropdown buttons
- [x] TrendCard with LineChart
- [x] InsightPanel with insights list
- [x] ComparisonTableCard
- [x] PlatformComparisonCard
- [x] CouponPerformanceCard
- [x] OutletTableCard
- [x] RefundSplitCard
- [x] Navigation sidebar

### Pending:
- [ ] Input fields (TextField with validation)
- [ ] DatePicker modal
- [ ] DateRange picker
- [ ] MultiSelect dropdown
- [ ] Loading skeleton loaders
- [ ] Empty state screens
- [ ] Error state screens
- [ ] Toast/Snackbar notifications
- [ ] Bottom sheet modals
- [ ] Pagination/Infinite scroll

---

## 12. State Management (0% Complete)

**Status:** Not Started

### Required Providers/Notifiers:
```dart
// Dashboard
dashboardMetricsProvider -> DashboardState
platformComparisonProvider -> ComparisonData
trendsChartProvider -> ChartData

// Filters
selectedDateProvider -> String
selectedPlatformProvider -> String
selectedViewByProvider -> String
selectedOutletProvider -> String

// Earnings
earningsDataProvider -> EarningsState
earningsChartProvider -> ChartData

// Ads
adCampaignsProvider -> AdCampaignState
adLiftProvider -> LiftAnalysisState

// Discounts
couponPerformanceProvider -> CouponState

// Refunds
refundAnalysisProvider -> RefundState
```

---

## 13. Feature: Filters (20% Complete)

**Status:** UI Complete, Logic Pending

### Filter Options:
- [x] Date: Latest Week, Last Month, Quarterly, Custom Range
- [x] Platform: Zomato, Swiggy, All
- [x] View By: Restaurant, Outlet, Platform
- [x] Venue/Outlet: All outlets, HSR Layout, Koramangala, Whitefield, JP Nagar, Indiranagar, Marathahalli

### Logic Pending:
- [ ] Apply filters button functionality
- [ ] Filter persistence across screens
- [ ] Filter reset functionality
- [ ] Date range picker modal
- [ ] Save custom filters

### Recent Updates (2 June 2026)
- [x] Filters implemented as a draggable popup overlay (`DraggableFilterPopup`) — opens from section header filter icon and can be repositioned via drag handle.
- [x] Popup scrim closes on tap; popup constrained to viewport to avoid overflowing off-screen.
- [x] Dashboard mock data expanded: additional KPI cards (Repeat Orders, Cancelled Orders) and extended trend chart points for richer visuals.
- [x] Section header updated to display a filter icon that opens the popup.

---

## 14. Testing (0% Complete)

**Status:** Not Started

- [ ] Fix `test/widget_test.dart` (currently testing old counter app)
- [ ] Unit tests for data models
- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Integration tests for full screens
- [ ] Mock API data for testing

---

## 15. Performance & Optimization (0% Complete)

**Status:** Not Started

- [ ] Lazy load charts (viewport-based rendering)
- [ ] Pagination for large tables
- [ ] Image caching for outlets/platforms
- [ ] API response caching
- [ ] Offline mode with Hive
- [ ] Bundle size optimization

---

## 16. Deployment & Configuration (10% Complete)

**Status:** In Progress

### Android:
- [ ] Update app identifier: `com.example.resto` → `com.yourcompany.resto`
- [ ] Setup Firebase (Crashlytics, Analytics)
- [ ] Signing certificate configuration
- [ ] Release build configuration

### iOS:
- [ ] App display name ✅ (set to "Resto")
- [ ] Bundle identifier update
- [ ] App icon setup
- [ ] Splash screen

### App Store:
- [ ] App description & screenshots
- [ ] Privacy policy
- [ ] Terms of service

---

## 17. Current Blocking Issues & Notes

### High Priority:
1. **API Integration Blocked** – Waiting for backend API documentation
   - Mock data currently used in UI
   - Action: Clarify API endpoints with backend team

2. **State Management Needed** – To properly manage filter state & async data
   - Decision: Implement Riverpod for clean reactive state
   - Action: Setup provider structure next

3. **Test File Broken** – `test/widget_test.dart` references old counter app
   - Action: Update test file to test new `RestoApp`

### Medium Priority:
4. **Database Schema** – Need to finalize Hive/Isar schema
5. **Auth Flow** – Login/authentication not yet implemented
6. **Error Handling** – Need global error boundary & retry logic

### Low Priority:
7. Analytics tracking setup
8. Crash reporting (Firebase Crashlytics)
9. Performance profiling

---

## 18. Development Roadmap (Next 30 Days)

### Week 1: State Management & Data Models
- [x] Project scaffolding (DONE)
- [ ] Setup Riverpod providers for dashboard
- [ ] Create data models (Order, Metric, Campaign, etc.)
- [ ] Mock API service
- [ ] Update test file

### Week 2: API Integration & Filters
- [ ] Implement real API calls (with mock data fallback)
- [ ] Wire filter functionality to data fetching
- [ ] Implement date picker & filter reset
- [ ] Add loading states for all screens

### Week 3: Missing Components & Polish
- [ ] Implement input validation & empty states
- [ ] Add loading skeleton screens
- [ ] Error state UI & retry logic
- [ ] Responsive design tests

### Week 4: Testing & Release Prep
- [ ] Unit & widget tests for core features
- [ ] Android release build configuration
- [ ] Firebase integration (Analytics, Crashlytics)
- [ ] Internal beta build & testing

---

## 19. Success Metrics

- [x] Dashboard UI matches design (100%)
- [ ] All screens functional with real data (0%)
- [ ] Filter system working end-to-end (0%)
- [ ] Performance: Dashboard loads in <2 seconds (0%)
- [ ] Test coverage: >70% for core logic (0%)
- [ ] No critical crashes in beta testing (0%)

---

## 20. Files Structure

```
lib/
├── main.dart                 # App entry point (DONE)
├── core/
│   ├── theme/               # Theme data (PENDING)
│   ├── routing/              # Navigation/routing (PENDING)
│   ├── networking/           # API client (PENDING)
│   ├── database/             # Local DB setup (PENDING)
│   └── constants/            # App constants
├── features/
│   ├── dashboard/            # Dashboard feature (UI DONE)
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── providers/        # State management (PENDING)
│   │   └── models/
│   ├── earnings/             # Earnings feature (UI DONE)
│   ├── advertisements/       # Ads feature (UI DONE)
│   ├── charges/              # Charges feature (UI DONE)
│   ├── discounts/            # Discounts feature (UI DONE)
│   └── refunds/              # Refunds feature (UI DONE)
├── shared/
│   ├── widgets/              # Common widgets (PARTIAL)
│   ├── models/               # Shared data models (PENDING)
│   └── utils/                # Helper functions (PENDING)
└── config/
    ├── api_config.dart       # API configuration (PENDING)
    └── db_config.dart        # Database configuration (PENDING)

test/
├── widget_test.dart          # Update for new app (PENDING)
└── unit/                     # Unit tests (PENDING)
```

---

**Last Updated:** 1 June 2026
**Next Review:** After Week 1 of development
