import 'package:flutter/material.dart';

import '../services/data_service.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late FilterState _filters;
  late ScreenData _data;

  @override
  void initState() {
    super.initState();
    _filters = FilterState(
      date: 'Latest Week',
      platform: 'All',
      viewBy: 'Restaurant',
      outlet: ['All outlets'],
    );
    _refresh();
  }

  void _refresh() {
    _data = DataService.generate(MobileSection.dashboard, _filters);
  }

  void _reset() {
    setState(() {
      _filters = FilterState(
        date: 'Latest Week',
        platform: 'All',
        viewBy: 'Restaurant',
        outlet: ['All outlets'],
      );
      _refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SectionScreen(
      title: 'Dashboard',
      subtitle: 'Business overview and performance trends',
      section: MobileSection.dashboard,
      filters: _filters,
      data: _data,
      onDateChanged: (value) => setState(() {
        _filters.date = value;
        _refresh();
      }),
      onPlatformChanged: (value) => setState(() {
        _filters.platform = value;
        _refresh();
      }),
      onViewByChanged: (value) => setState(() {
        _filters.viewBy = value;
        _refresh();
      }),
      onOutletsChanged: (value) => setState(() {
        _filters.outlet = value;
        _refresh();
      }),
      onRefresh: () => setState(_refresh),
      onReset: _reset,
    );
  }
}
