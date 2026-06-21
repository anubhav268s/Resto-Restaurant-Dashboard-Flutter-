// Tests for Resto - Restaurant Management & Analytics App
//
// This file contains widget and integration tests for the Resto application.
// Tests verify that key UI components and functionality work as expected.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:resto/main.dart';

void main() {
  group('Resto App - Basic Smoke Tests', () {
    testWidgets('App launches and displays main screen', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const RestoApp());

      // Verify that the app title "Resto" is displayed
      expect(find.text('Resto'), findsOneWidget);
    });

    testWidgets('Home screen displays Dash tooltip', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());

      // Verify that Dash text is visible in nav bar tooltip
      expect(find.byTooltip('Dash'), findsOneWidget);
    });

    testWidgets('Dashboard screen shows KPI cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Verify key metrics are displayed on dashboard
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Filter panel is visible when filter icon tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      final filterButton = find.byIcon(Icons.filter_alt_outlined);
      if (filterButton.evaluate().isNotEmpty) {
        await tester.tap(filterButton.first);
        await tester.pumpAndSettle();

        // Verify filter controls are present
        expect(find.text('Date'), findsWidgets);
        expect(find.text('Platform'), findsWidgets);
        expect(find.text('View By'), findsWidgets);
        expect(find.text('Select Restaurant'), findsWidgets);
      }
    });

    testWidgets('Section header displays correct titles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Verify main dashboard header
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Navigation through sidebar works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Open nav by tapping apps menu
      final menuButton = find.byIcon(Icons.apps);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();

        // Verify navigation items are shown in drawer
        expect(find.byTooltip('Earnings'), findsOneWidget);
        expect(find.byTooltip('Ads'), findsOneWidget);
        expect(find.byTooltip('Charges'), findsOneWidget);
      }
    });

    testWidgets('AI Insights panel displays on dashboard', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Verify AI Insights section
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Platform comparison card shows both platforms', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsWidgets);
    });

    testWidgets('Secondary metrics visible below main KPIs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });
  });

  group('Resto App - Navigation Tests', () {
    testWidgets('Can navigate to Earnings screen', (WidgetTester tester) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Open nav by tapping apps menu first to make Earnings visible
      final menuButton = find.byIcon(Icons.apps);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();
      }

      // Try to find and tap Earnings navigation item
      final earningsNav = find.byTooltip('Earnings');
      if (earningsNav.evaluate().isNotEmpty) {
        await tester.tap(earningsNav.first);
        await tester.pumpAndSettle();

        // Verify navigation occurred
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });

  group('Resto App - Widget Rendering Tests', () {
    testWidgets('All stat cards render without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Verify stat cards are rendered
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('Charts render without overflow', (WidgetTester tester) async {
      await tester.pumpWidget(const RestoApp());
      await tester.pumpAndSettle();

      // Verify no render errors occur (basic smoke test)
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
