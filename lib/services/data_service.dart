import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum MobileSection {
  dashboard,
  earnings,
  advertisements,
  charges,
  discounts,
  refunds,
}

class FilterState {
  FilterState({
    required this.date,
    required this.platform,
    required this.viewBy,
    required this.outlet,
  });

  String date;
  String platform;
  String viewBy;
  List<String> outlet;

  FilterState copyWith({
    String? date,
    String? platform,
    String? viewBy,
    List<String>? outlet,
  }) {
    return FilterState(
      date: date ?? this.date,
      platform: platform ?? this.platform,
      viewBy: viewBy ?? this.viewBy,
      outlet: outlet ?? List<String>.from(this.outlet),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState &&
        other.date == date &&
        other.platform == platform &&
        other.viewBy == viewBy &&
        _listEquals(other.outlet, outlet);
  }

  @override
  int get hashCode =>
      Object.hash(date, platform, viewBy, Object.hashAll(outlet));

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class StatItem {
  StatItem({
    required this.title,
    required this.value,
    required this.badge,
    this.color,
    this.icon = Icons.analytics_outlined,
  });

  final String title;
  final String value;
  final String badge;
  final Color? color;
  final IconData icon;
}

class InsightItem {
  InsightItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class TableData {
  TableData({required this.headers, required this.rows});

  final List<String> headers;
  final List<List<String>> rows;
}

class ScreenData {
  ScreenData({
    required this.stats,
    required this.chartPoints,
    required this.insights,
    required this.tableData,
    required this.generatedAt,
  });

  final List<StatItem> stats;
  final List<FlSpot> chartPoints;
  final List<InsightItem> insights;
  final TableData tableData;
  final DateTime generatedAt;
}

class DataService {
  static const dateOptions = [
    'Latest Week',
    'This Month',
    'Previous Month',
    'Quarterly',
  ];
  static const platformOptions = ['All', 'Zomato', 'Swiggy'];
  static const viewOptions = ['Restaurant', 'Chain', 'Group'];
  static const outletOptions = [
    'All outlets',
    'Spice Junction - Indiranagar',
    'Spice Junction - Koramangala',
    'Spice Junction - HSR',
    'Curry Leaf - MG Road',
    'Curry Leaf - Whitefield',
    'Tandoori Tales - JP Nagar',
    'Biryani House - BTM',
  ];

  static ScreenData generate(MobileSection section, FilterState filter) {
    final filterSeed =
        filter.date.hashCode ^
        (filter.platform.hashCode << 8) ^
        (filter.viewBy.hashCode << 16) ^
        filter.outlet.join('|').hashCode;
    final seed =
        DateTime.now().millisecondsSinceEpoch +
        section.index * 1000 +
        filterSeed;
    final random = Random(seed);
    final multiplier = _filterMultiplier(section, filter);

    return ScreenData(
      stats: _buildStats(section, random, multiplier),
      chartPoints: _buildChart(section, random, multiplier, filter),
      insights: _buildInsights(section, random),
      tableData: _buildTable(section, random),
      generatedAt: DateTime.now(),
    );
  }

  static double _filterMultiplier(MobileSection section, FilterState filter) {
    var value = 1.0;
    if (filter.date == 'Previous Month' || filter.date == 'Last Month') {
      value += 0.12;
    }
    if (filter.date == 'This Month') {
      value += 0.08;
    }
    if (filter.date == 'Quarterly') {
      value += 0.25;
    }
    if (filter.date.contains('-') && filter.date != 'Latest Week') {
      value += 0.1;
    }
    if (filter.platform == 'Zomato') {
      value += 0.06;
    }
    if (filter.platform == 'Swiggy') {
      value += 0.03;
    }
    if (filter.viewBy == 'Chain') {
      value += 0.04;
    }
    if (filter.viewBy == 'Group') {
      value += 0.1;
    }
    if (!filter.outlet.contains('All outlets') && filter.outlet.isNotEmpty) {
      value += 0.08;
    }
    switch (section) {
      case MobileSection.advertisements:
        return value + 0.1;
      case MobileSection.charges:
        return value - 0.05;
      case MobileSection.discounts:
        return value + 0.02;
      case MobileSection.refunds:
        return value - 0.08;
      default:
        return value;
    }
  }

  static List<StatItem> _buildStats(
    MobileSection section,
    Random random,
    double multiplier,
  ) {
    switch (section) {
      case MobileSection.dashboard:
        return [
          StatItem(
            title: 'Gross Order Value',
            value: _formatCurrency(
              (300000 + random.nextInt(180000)) * multiplier,
            ),
            badge: _formatBadge(8.5 + random.nextDouble() * 6),
            color: const Color(0xFF1D4ED8),
            icon: Icons.currency_rupee,
          ),
          StatItem(
            title: 'Total Orders',
            value: _formatNumber((1600 + random.nextInt(520)) * multiplier),
            badge: _formatBadge(5 + random.nextDouble() * 5),
            icon: Icons.inventory_2_outlined,
          ),
          StatItem(
            title: 'Average Order Value',
            value: _formatCurrency((180 + random.nextInt(80)) * multiplier),
            badge: _formatBadge(3 + random.nextDouble() * 4),
            icon: Icons.trending_up,
          ),
          StatItem(
            title: 'Net Payout',
            value: _formatCurrency(
              (280000 + random.nextInt(120000)) * multiplier,
            ),
            badge: _formatBadge(4 + random.nextDouble() * 5),
            icon: Icons.account_balance_wallet_outlined,
          ),
          StatItem(
            title: 'Repeat Orders',
            value: _formatNumber((420 + random.nextInt(260)) * multiplier),
            badge: _formatBadge(6 + random.nextDouble() * 4),
            icon: Icons.repeat,
          ),
          StatItem(
            title: 'Cancelled Orders',
            value: _formatNumber((60 + random.nextInt(80)) * multiplier),
            badge: _formatBadge(-2 + random.nextDouble() * 3),
            color: const Color(0xFFEF4444),
            icon: Icons.cancel_outlined,
          ),
          StatItem(
            title: 'New Customers',
            value: _formatNumber((240 + random.nextInt(200)) * multiplier),
            badge: _formatBadge(7 + random.nextDouble() * 5),
            color: const Color(0xFF16A34A),
            icon: Icons.person_add_alt_1_outlined,
          ),
          StatItem(
            title: 'Refund Rate',
            value: '${(2 + random.nextDouble() * 4).toStringAsFixed(2)}%',
            badge: _formatBadge(-0.5 + random.nextDouble() * 1.5),
            color: const Color(0xFFDC2626),
            icon: Icons.undo,
          ),
          StatItem(
            title: 'Net Margin',
            value: '${(18 + random.nextDouble() * 6).toStringAsFixed(2)}%',
            badge: _formatBadge(2 + random.nextDouble() * 3),
            color: const Color(0xFF0F766E),
            icon: Icons.percent,
          ),
        ];
      case MobileSection.earnings:
        return [
          StatItem(
            title: 'Revenue',
            value: _formatCurrency(
              (420000 + random.nextInt(160000)) * multiplier,
            ),
            badge: _formatBadge(9 + random.nextDouble() * 5),
            color: const Color(0xFF0F766E),
            icon: Icons.currency_rupee,
          ),
          StatItem(
            title: 'Orders',
            value: _formatNumber((1800 + random.nextInt(520)) * multiplier),
            badge: _formatBadge(6 + random.nextDouble() * 4),
            icon: Icons.receipt_long_outlined,
          ),
          StatItem(
            title: 'AOV',
            value: _formatCurrency((210 + random.nextInt(70)) * multiplier),
            badge: _formatBadge(3 + random.nextDouble() * 4),
            icon: Icons.show_chart,
          ),
          StatItem(
            title: 'Max Order',
            value: _formatCurrency(1200 + random.nextInt(400)),
            badge: _formatBadge(2 + random.nextDouble() * 3),
            icon: Icons.arrow_upward,
          ),
          StatItem(
            title: 'Min Order',
            value: _formatCurrency(90 + random.nextInt(60)),
            badge: _formatBadge(-1 + random.nextDouble() * 2),
            icon: Icons.arrow_downward,
          ),
          StatItem(
            title: 'Median Order',
            value: _formatCurrency(200 + random.nextInt(30)),
            badge: _formatBadge(1 + random.nextDouble() * 3),
            icon: Icons.align_horizontal_center,
          ),
          StatItem(
            title: 'Repeat Orders',
            value: _formatNumber((380 + random.nextInt(260)) * multiplier),
            badge: _formatBadge(5 + random.nextDouble() * 4),
            icon: Icons.repeat,
          ),
          StatItem(
            title: 'Net Margin',
            value: '${(20 + random.nextDouble() * 8).toStringAsFixed(2)}%',
            badge: _formatBadge(1 + random.nextDouble() * 3),
            color: const Color(0xFF0F766E),
            icon: Icons.percent,
          ),
        ];
      case MobileSection.advertisements:
        return [
          StatItem(
            title: 'Ad Spend',
            value: _formatCurrency(140000 + random.nextInt(60000)),
            badge: _formatBadge(-12 + random.nextDouble() * 6),
            color: const Color(0xFFEA580C),
            icon: Icons.campaign_outlined,
          ),
          StatItem(
            title: 'Campaigns',
            value: '${8 + random.nextInt(6)} active',
            badge: _formatBadge(5 + random.nextDouble() * 3, percent: false),
            icon: Icons.calendar_month_outlined,
          ),
          StatItem(
            title: 'Lift',
            value: '${25 + random.nextInt(20)}%',
            badge: _formatBadge(7 + random.nextDouble() * 4),
            icon: Icons.bolt_outlined,
          ),
          StatItem(
            title: 'Sales from Ads',
            value: _formatCurrency(680000 + random.nextInt(200000)),
            badge: _formatBadge(11 + random.nextDouble() * 5),
            icon: Icons.trending_up,
          ),
          StatItem(
            title: 'CTR',
            value: '${(1 + random.nextDouble() * 3).toStringAsFixed(2)}%',
            badge: _formatBadge(0.5 + random.nextDouble() * 1.5),
            icon: Icons.ads_click,
          ),
          StatItem(
            title: 'CPM',
            value: _formatCurrency(120 + random.nextInt(200)),
            badge: _formatBadge(-1 + random.nextDouble() * 2),
            icon: Icons.currency_rupee,
          ),
          StatItem(
            title: 'Conversions',
            value: _formatNumber(420 + random.nextInt(300)),
            badge: _formatBadge(6 + random.nextDouble() * 4),
            icon: Icons.check_circle_outline,
          ),
          StatItem(
            title: 'ROAS',
            value: '${(1 + random.nextDouble() * 3).toStringAsFixed(2)}x',
            badge: _formatBadge(4 + random.nextDouble() * 5, percent: false),
            icon: Icons.stacked_line_chart,
          ),
        ];
      case MobileSection.charges:
        return [
          StatItem(
            title: 'Total Charges',
            value: _formatCurrency(420000 + random.nextInt(90000)),
            badge: _formatBadge(2 + random.nextDouble() * 3),
            color: const Color(0xFF7C3AED),
            icon: Icons.account_balance_wallet_outlined,
          ),
          StatItem(
            title: 'Effective Rate',
            value: '${24 + random.nextInt(5)}%',
            badge: _formatBadge(-1 + random.nextDouble() * 2, percent: false),
            icon: Icons.percent,
          ),
          StatItem(
            title: 'Commission',
            value: _formatCurrency(320000 + random.nextInt(70000)),
            badge: _formatBadge(1 + random.nextDouble() * 3),
            icon: Icons.receipt_long_outlined,
          ),
          StatItem(
            title: 'PG Fees',
            value: _formatCurrency(28000 + random.nextInt(14000)),
            badge: _formatBadge(
              0.8 + random.nextDouble() * 1.5,
              percent: false,
            ),
            icon: Icons.credit_card,
          ),
          StatItem(
            title: 'Delivery Fees',
            value: _formatCurrency(19000 + random.nextInt(9000)),
            badge: _formatBadge(1 + random.nextDouble() * 2),
            icon: Icons.delivery_dining,
          ),
          StatItem(
            title: 'Other Charges',
            value: _formatCurrency(18000 + random.nextInt(7000)),
            badge: _formatBadge(0.5 + random.nextDouble() * 1.5),
            icon: Icons.more_horiz,
          ),
          StatItem(
            title: 'Tax & Govt',
            value: _formatCurrency(26000 + random.nextInt(12000)),
            badge: _formatBadge(-0.5 + random.nextDouble() * 1.5),
            icon: Icons.account_balance_outlined,
          ),
          StatItem(
            title: 'Chargebacks',
            value: _formatNumber(40 + random.nextInt(80)),
            badge: _formatBadge(-2 + random.nextDouble() * 3),
            icon: Icons.report_gmailerrorred_outlined,
          ),
          StatItem(
            title: 'Net Deductions',
            value: _formatCurrency(360000 + random.nextInt(120000)),
            badge: _formatBadge(1 + random.nextDouble() * 3),
            icon: Icons.remove_circle_outline,
          ),
        ];
      case MobileSection.discounts:
        return [
          StatItem(
            title: 'Discount Burn',
            value: _formatCurrency(260000 + random.nextInt(80000)),
            badge: _formatBadge(7 + random.nextDouble() * 4),
            color: const Color(0xFFDB2777),
            icon: Icons.local_offer_outlined,
          ),
          StatItem(
            title: 'Discount %',
            value: '${12 + random.nextInt(4)}%',
            badge: _formatBadge(1 + random.nextDouble() * 2, percent: false),
            icon: Icons.percent,
          ),
          StatItem(
            title: 'Coupon Orders',
            value: _formatNumber(3900 + random.nextInt(1500)),
            badge: _formatBadge(5 + random.nextDouble() * 4),
            icon: Icons.confirmation_number_outlined,
          ),
          StatItem(
            title: 'Avg Discount',
            value: _formatCurrency(45 + random.nextInt(28)),
            badge: _formatBadge(2 + random.nextDouble() * 3),
            icon: Icons.currency_rupee,
          ),
          StatItem(
            title: 'Coupon ROI',
            value: '${(1 + random.nextDouble() * 2).toStringAsFixed(2)}x',
            badge: _formatBadge(3 + random.nextDouble() * 3, percent: false),
            icon: Icons.stacked_line_chart,
          ),
          StatItem(
            title: 'Active Coupons',
            value: '${6 + random.nextInt(6)} active',
            badge: _formatBadge(2 + random.nextDouble() * 3, percent: false),
            icon: Icons.sell_outlined,
          ),
          StatItem(
            title: 'Discount Contribution',
            value: '${(8 + random.nextDouble() * 6).toStringAsFixed(2)}%',
            badge: _formatBadge(1 + random.nextDouble() * 2),
            icon: Icons.pie_chart_outline,
          ),
        ];
      case MobileSection.refunds:
        return [
          StatItem(
            title: 'Refund Amount',
            value: _formatCurrency(130000 + random.nextInt(50000)),
            badge: _formatBadge(10 + random.nextDouble() * 5),
            color: const Color(0xFFDC2626),
            icon: Icons.undo,
          ),
          StatItem(
            title: 'Refund %',
            value: '${6 + random.nextInt(3)}%',
            badge: _formatBadge(1 + random.nextDouble() * 2, percent: false),
            icon: Icons.percent,
          ),
          StatItem(
            title: 'Refunded Orders',
            value: _formatNumber(420 + random.nextInt(220)),
            badge: _formatBadge(7 + random.nextDouble() * 5),
            icon: Icons.receipt_long_outlined,
          ),
          StatItem(
            title: 'Cancellation',
            value: '${3 + random.nextInt(3)}%',
            badge: _formatBadge(
              0.5 + random.nextDouble() * 1.5,
              percent: false,
            ),
            icon: Icons.cancel_outlined,
          ),
          StatItem(
            title: 'Loss Amount',
            value: _formatCurrency(24000 + random.nextInt(16000)),
            badge: _formatBadge(4 + random.nextDouble() * 3),
            icon: Icons.warning_amber_outlined,
          ),
          StatItem(
            title: 'Outlet Impact',
            value: '${(random.nextDouble() * 25).toStringAsFixed(2)}%',
            badge: _formatBadge(2 + random.nextDouble() * 3),
            icon: Icons.storefront_outlined,
          ),
          StatItem(
            title: 'Avg Refund Time',
            value: '${1 + random.nextInt(5)} days',
            badge: _formatBadge(
              -0.5 + random.nextDouble() * 1.5,
              percent: false,
            ),
            icon: Icons.schedule,
          ),
          StatItem(
            title: 'Recovered',
            value: _formatCurrency(12000 + random.nextInt(8000)),
            badge: _formatBadge(3 + random.nextDouble() * 3),
            icon: Icons.savings_outlined,
          ),
        ];
    }
  }

  static List<FlSpot> _buildChart(
    MobileSection section,
    Random random,
    double multiplier,
    FilterState filter,
  ) {
    final base = 12 + (section.index * 4) + random.nextDouble() * 4;
    final points = _chartPointCount(section, filter);
    final rangeFactor = switch (filter.date) {
      'This Month' => 0.95,
      'Previous Month' => 1.0,
      'Quarterly' => 1.1,
      _ => 1.0,
    };
    final platformBias = switch (filter.platform) {
      'Zomato' => 1.2,
      'Swiggy' => 0.9,
      _ => 1.0,
    };
    final outletBoost =
        (!filter.outlet.contains('All outlets') && filter.outlet.isNotEmpty)
        ? 1.08
        : 1.0;
    final categoryShift = switch (filter.viewBy) {
      'Chain' => 1.1,
      'Group' => 1.3,
      _ => 1.0,
    };

    return List.generate(points, (index) {
      final x = index.toDouble() + 1;
      final trend = index * 0.18 * categoryShift;
      final wave = sin(x / 1.8) * 3.2 + cos(x / 2.6) * 1.6;
      final noise = random.nextDouble() * 2.4;
      final value =
          (base * multiplier * rangeFactor * platformBias * outletBoost) +
          wave +
          trend +
          noise;
      return FlSpot(x, value);
    });
  }

  static int _chartPointCount(MobileSection section, FilterState filter) {
    if (filter.date == 'Latest Week') {
      return 7;
    }
    if (filter.date == 'This Month' || filter.date == 'Previous Month') {
      return 14;
    }
    if (filter.date == 'Quarterly') {
      return 12;
    }
    if (filter.date.contains('-')) {
      return 10;
    }
    return section == MobileSection.dashboard ? 14 : 10;
  }

  static List<InsightItem> _buildInsights(
    MobileSection section,
    Random random,
  ) {
    final titles = <String>[
      'Momentum is strong for selected filters.',
      'One outlet is leading performance clearly.',
      'Campaign spend is delivering stable lift.',
      'Discount usage is trending higher this week.',
      'Refunds remain within expected thresholds.',
      'Average order value is improving.',
    ];

    final subtitles = <String>[
      'Keep promoting best-selling combos.',
      'Push budget to the highest-margin zone.',
      'Review the lowest performing campaign.',
      'Monitor coupon burn closely.',
      'Adjust packaging and delivery quality.',
      'Keep the premium bundle active.',
    ];

    final icons = <IconData>[
      Icons.trending_up,
      Icons.thumb_up,
      Icons.insights,
      Icons.local_offer,
      Icons.warning,
      Icons.pie_chart,
    ];
    final colors = <Color>[
      const Color(0xFF16A34A),
      const Color(0xFF2563EB),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
    ];

    return List.generate(4, (index) {
      final title = titles[random.nextInt(titles.length)];
      final subtitle = subtitles[random.nextInt(subtitles.length)];
      final icon = icons[random.nextInt(icons.length)];
      final color = colors[random.nextInt(colors.length)];
      return InsightItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        color: color,
      );
    });
  }

  static TableData _buildTable(MobileSection section, Random random) {
    switch (section) {
      case MobileSection.dashboard:
        return TableData(
          headers: ['Platform', 'Sales', 'Payout', 'Share'],
          rows: [
            [
              'Zomato',
              _formatCurrency(180000 + random.nextInt(100000)),
              _formatCurrency(135000 + random.nextInt(70000)),
              '${36 + random.nextInt(10)}%',
            ],
            [
              'Swiggy',
              _formatCurrency(150000 + random.nextInt(90000)),
              _formatCurrency(112000 + random.nextInt(60000)),
              '${28 + random.nextInt(12)}%',
            ],
            [
              'Delivery',
              _formatCurrency(76000 + random.nextInt(50000)),
              _formatCurrency(58000 + random.nextInt(30000)),
              '${18 + random.nextInt(8)}%',
            ],
            [
              'Walk-in',
              _formatCurrency(62000 + random.nextInt(31000)),
              _formatCurrency(47000 + random.nextInt(23000)),
              '${16 + random.nextInt(6)}%',
            ],
          ],
        );
      case MobileSection.earnings:
        return TableData(
          headers: ['Outlet', 'Sales', 'Orders', 'AOV'],
          rows: [
            [
              'HSR Layout',
              _formatCurrency(125000 + random.nextInt(60000)),
              _formatNumber(320 + random.nextInt(120)),
              _formatCurrency(180 + random.nextInt(50)),
            ],
            [
              'Koramangala',
              _formatCurrency(148000 + random.nextInt(70000)),
              _formatNumber(350 + random.nextInt(140)),
              _formatCurrency(195 + random.nextInt(55)),
            ],
            [
              'Whitefield',
              _formatCurrency(98000 + random.nextInt(50000)),
              _formatNumber(260 + random.nextInt(100)),
              _formatCurrency(175 + random.nextInt(45)),
            ],
            [
              'Indiranagar',
              _formatCurrency(110000 + random.nextInt(52000)),
              _formatNumber(280 + random.nextInt(110)),
              _formatCurrency(185 + random.nextInt(50)),
            ],
          ],
        );
      case MobileSection.advertisements:
        return TableData(
          headers: ['Outlet', 'Spend', 'Sales', 'Lift'],
          rows: [
            [
              'HSR Layout',
              _formatCurrency(22000 + random.nextInt(16000)),
              _formatCurrency(95000 + random.nextInt(45000)),
              '${28 + random.nextInt(15)}%',
            ],
            [
              'Koramangala',
              _formatCurrency(24000 + random.nextInt(17000)),
              _formatCurrency(106000 + random.nextInt(52000)),
              '${31 + random.nextInt(14)}%',
            ],
            [
              'Whitefield',
              _formatCurrency(18000 + random.nextInt(14000)),
              _formatCurrency(76000 + random.nextInt(39000)),
              '${22 + random.nextInt(13)}%',
            ],
            [
              'JP Nagar',
              _formatCurrency(16000 + random.nextInt(13000)),
              _formatCurrency(69000 + random.nextInt(36000)),
              '${19 + random.nextInt(12)}%',
            ],
          ],
        );
      case MobileSection.charges:
        return TableData(
          headers: ['Type', 'Amount', 'Rate', 'Status'],
          rows: [
            [
              'Commission',
              _formatCurrency(305000 + random.nextInt(88000)),
              '${17 + random.nextInt(3)}%',
              'Stable',
            ],
            [
              'PG Fees',
              _formatCurrency(28000 + random.nextInt(11000)),
              '${(1.2 + random.nextDouble() * 0.8).toStringAsFixed(2)}%',
              'Low',
            ],
            [
              'Delivery Fee',
              _formatCurrency(19000 + random.nextInt(9000)),
              '${(1.0 + random.nextDouble() * 0.7).toStringAsFixed(2)}%',
              'Moderate',
            ],
            [
              'Other Charges',
              _formatCurrency(18000 + random.nextInt(7000)),
              '${(0.8 + random.nextDouble() * 0.6).toStringAsFixed(2)}%',
              'Watch',
            ],
          ],
        );
      case MobileSection.discounts:
        return TableData(
          headers: ['Coupon', 'Orders', 'Burn', 'ROI'],
          rows: [
            [
              'WELCOME100',
              _formatNumber(920 + random.nextInt(360)),
              _formatCurrency(88000 + random.nextInt(42000)),
              '${18 + random.nextInt(9)}%',
            ],
            [
              'FLAT50',
              _formatNumber(1240 + random.nextInt(420)),
              _formatCurrency(76000 + random.nextInt(33000)),
              '${23 + random.nextInt(11)}%',
            ],
            [
              'SUPER20',
              _formatNumber(830 + random.nextInt(310)),
              _formatCurrency(52000 + random.nextInt(26000)),
              '${26 + random.nextInt(10)}%',
            ],
            [
              'TASTY30',
              _formatNumber(610 + random.nextInt(250)),
              _formatCurrency(38000 + random.nextInt(21000)),
              '${15 + random.nextInt(9)}%',
            ],
          ],
        );
      case MobileSection.refunds:
        return TableData(
          headers: ['Outlet', 'Refund', 'Cancel', 'Loss'],
          rows: [
            [
              'Whitefield',
              '${6 + random.nextInt(3)}%',
              '${3 + random.nextInt(2)}%',
              _formatCurrency(24000 + random.nextInt(16000)),
            ],
            [
              'Koramangala',
              '${5 + random.nextInt(3)}%',
              '${2 + random.nextInt(2)}%',
              _formatCurrency(21000 + random.nextInt(15000)),
            ],
            [
              'HSR Layout',
              '${5 + random.nextInt(3)}%',
              '${3 + random.nextInt(2)}%',
              _formatCurrency(19500 + random.nextInt(14000)),
            ],
            [
              'JP Nagar',
              '${4 + random.nextInt(2)}%',
              '${2 + random.nextInt(2)}%',
              _formatCurrency(17000 + random.nextInt(12000)),
            ],
          ],
        );
    }
  }

  static String _formatCurrency(num value) {
    final formatted = _formatNumber(value);
    return '₹$formatted';
  }

  static String _formatNumber(num value) {
    final intValue = value.round();
    final result = intValue.abs().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return intValue < 0 ? '-$result' : result;
  }

  static String _formatBadge(double value, {bool percent = true}) {
    final formatted = percent
        ? '${value.toStringAsFixed(2)}%'
        : value.toStringAsFixed(1);
    return value >= 0 ? '+$formatted' : formatted;
  }
}
