import 'package:flutter/material.dart';

import '../services/data_service.dart';
import '../widgets/common_widgets.dart';

class ChargesScreen extends StatefulWidget {
  const ChargesScreen({super.key});

  @override
  State<ChargesScreen> createState() => _ChargesScreenState();
}

class _ChargesScreenState extends State<ChargesScreen> {
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
    _data = DataService.generate(MobileSection.charges, _filters);
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
      title: 'Charges',
      subtitle: 'Platform fees, commissions and payout costs',
      section: MobileSection.charges,
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
