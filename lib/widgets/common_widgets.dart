import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/data_service.dart';

class DraggableFilterPopup extends StatefulWidget {
  const DraggableFilterPopup({
    super.key,
    required this.filters,
    required this.onDateChanged,
    required this.onPlatformChanged,
    required this.onViewByChanged,
    required this.onOutletsChanged,
    required this.onRefresh,
    required this.onReset,
    required this.onClose,
  });

  final FilterState filters;
  final void Function(String) onDateChanged;
  final void Function(String) onPlatformChanged;
  final void Function(String) onViewByChanged;
  final void Function(List<String>) onOutletsChanged;
  final VoidCallback onRefresh;
  final VoidCallback onReset;
  final VoidCallback onClose;

  @override
  State<DraggableFilterPopup> createState() => _DraggableFilterPopupState();
}

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    required this.filters,
    required this.onDateChanged,
    required this.onPlatformChanged,
    required this.onViewByChanged,
    required this.onOutletsChanged,
    required this.onRefresh,
    required this.onReset,
    required this.isCollapsed,
    required this.onToggle,
  });

  final FilterState filters;
  final void Function(String) onDateChanged;
  final void Function(String) onPlatformChanged;
  final void Function(String) onViewByChanged;
  final void Function(List<String>) onOutletsChanged;
  final VoidCallback onRefresh;
  final VoidCallback onReset;
  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late String _draftDate;
  late String _draftPlatform;
  late String _draftViewBy;
  late List<String> _draftOutlets;

  @override
  void initState() {
    super.initState();
    _draftDate = widget.filters.date;
    _draftPlatform = widget.filters.platform;
    _draftViewBy = widget.filters.viewBy;
    _draftOutlets = List<String>.from(widget.filters.outlet);
  }

  @override
  void didUpdateWidget(covariant FilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters != oldWidget.filters) {
      _draftDate = widget.filters.date;
      _draftPlatform = widget.filters.platform;
      _draftViewBy = widget.filters.viewBy;
      _draftOutlets = List<String>.from(widget.filters.outlet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt_outlined, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                onPressed: widget.onToggle,
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Collapse filters',
              ),
            ],
          ),
          const Divider(height: 22),
          _FilterControls(
            date: _draftDate,
            platform: _draftPlatform,
            viewBy: _draftViewBy,
            outlets: _draftOutlets,
            onDateChanged: (value) => setState(() => _draftDate = value),
            onPlatformChanged: (value) =>
                setState(() => _draftPlatform = value),
            onViewByChanged: (value) => setState(() => _draftViewBy = value),
            onOutletsChanged: (value) => setState(() => _draftOutlets = value),
            onApply: _applyDrafts,
            onReset: widget.onReset,
          ),
        ],
      ),
    );
  }

  void _applyDrafts() {
    if (_draftDate != widget.filters.date) {
      widget.onDateChanged(_draftDate);
    }
    if (_draftPlatform != widget.filters.platform) {
      widget.onPlatformChanged(_draftPlatform);
    }
    if (_draftViewBy != widget.filters.viewBy) {
      widget.onViewByChanged(_draftViewBy);
    }
    // The if check for lists is tricky, so just apply the change.
    widget.onOutletsChanged(_draftOutlets);
    widget.onRefresh();
  }
}

class _FilterControls extends StatelessWidget {
  const _FilterControls({
    required this.date,
    required this.platform,
    required this.viewBy,
    required this.outlets,
    required this.onDateChanged,
    required this.onPlatformChanged,
    required this.onViewByChanged,
    required this.onOutletsChanged,
    required this.onApply,
    required this.onReset,
    this.showActions = true,
  });

  final String date;
  final String platform;
  final String viewBy;
  final List<String> outlets;
  final ValueChanged<String> onDateChanged;
  final ValueChanged<String> onPlatformChanged;
  final ValueChanged<String> onViewByChanged;
  final ValueChanged<List<String>> onOutletsChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final bool showActions;

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dateOptions = [...DataService.dateOptions, 'Custom Range'];
    if (!dateOptions.contains(date)) {
      dateOptions.add(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilterLabel('Date'),
        DropdownButtonFormField<String>(
          initialValue: date,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
          ),
          items: dateOptions
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: (value) async {
            if (value == 'Custom Range') {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (!context.mounted) return;
              if (picked != null) {
                onDateChanged(
                  '${_formatDate(picked.start)} - ${_formatDate(picked.end)}',
                );
              } else {
                // Revert visual selection if canceled
                onDateChanged(date);
              }
            } else if (value != null) {
              onDateChanged(value);
            }
          },
        ),
        const SizedBox(height: 10),
        _FilterLabel('Platform'),
        DropdownButtonFormField<String>(
          initialValue: platform,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            prefixIcon: Icon(Icons.storefront, size: 20),
          ),
          items: [
            ...DataService.platformOptions.map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 13)),
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) onPlatformChanged(value);
          },
        ),
        const SizedBox(height: 10),
        _FilterLabel('View By'),
        _SegmentedFilter(
          value: viewBy,
          options: DataService.viewOptions,
          onChanged: onViewByChanged,
        ),
        const SizedBox(height: 10),
        _OutletSearchPicker(
          viewBy: viewBy,
          values: outlets,
          onChanged: onOutletsChanged,
        ),
        const SizedBox(height: 14),
        if (showActions)
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onApply,
                  icon: const Icon(Icons.check),
                  label: const Text('Apply'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodySmall?.color?.withValues(alpha: 0.9),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SegmentedFilter extends StatelessWidget {
  const _SegmentedFilter({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...options.map((option) {
          final selected = option == value;
          return ChoiceChip(
            selected: selected,
            label: Text(option),
            avatar: selected ? const Icon(Icons.check, size: 16) : null,
            labelStyle: const TextStyle(fontSize: 12),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(4),
            onSelected: (_) => onChanged(option),
          );
        }),
      ],
    );
  }
}

class _OutletSearchPicker extends StatefulWidget {
  const _OutletSearchPicker({
    required this.values,
    required this.onChanged,
    required this.viewBy,
  });

  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String viewBy;

  @override
  State<_OutletSearchPicker> createState() => _OutletSearchPickerState();
}

class _OutletSearchPickerState extends State<_OutletSearchPicker> {
  String _query = '';
  static const Map<String, List<String>> _options = {
    'Restaurant': [
      "Spice Junction - Indiranagar",
      "Spice Junction - Koramangala",
      "Spice Junction - HSR",
      "Curry Leaf - MG Road",
      "Curry Leaf - Whitefield",
      "Tandoori Tales - JP Nagar",
      "Biryani House - BTM",
    ],
    'Chain': [
      "Spice Junction",
      "Curry Leaf",
      "Tandoori Tales",
      "Biryani House",
    ],
    'Group': [
      "Resto Foods Pvt Ltd",
      "Urban Bites Group",
      "Heritage Hospitality",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final allOptions = _options[widget.viewBy] ?? _options['Restaurant']!;
    final outlets = allOptions
        .where((outlet) => outlet.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FilterLabel('Select ${widget.viewBy}'),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search ${widget.viewBy.toLowerCase()}...',
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
          ),
          onChanged: (value) => setState(() => _query = value),
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            TextButton(
              onPressed: () {
                final currentValues = List<String>.from(widget.values);
                for (final option in outlets) {
                  if (!currentValues.contains(option)) {
                    currentValues.add(option);
                  }
                }
                widget.onChanged(currentValues);
              },
              child: const Text('Select all'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => widget.onChanged([]),
              child: const Text('Clear'),
            ),
          ],
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 130),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: outlets.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: Theme.of(context).dividerColor),
            itemBuilder: (context, index) {
              final outlet = outlets[index];
              final selected = widget.values.contains(outlet);
              return InkWell(
                onTap: () {
                  final newValues = List<String>.from(widget.values);
                  if (selected) {
                    newValues.remove(outlet);
                  } else {
                    newValues.add(outlet);
                  }
                  widget.onChanged(newValues);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).iconTheme.color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          outlet,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DraggableFilterPopupState extends State<DraggableFilterPopup> {
  late String _draftDate;
  late String _draftPlatform;
  late String _draftViewBy;
  late List<String> _draftOutlets;

  @override
  void initState() {
    super.initState();
    _draftDate = widget.filters.date;
    _draftPlatform = widget.filters.platform;
    _draftViewBy = widget.filters.viewBy;
    _draftOutlets = List<String>.from(widget.filters.outlet);
  }

  @override
  void didUpdateWidget(covariant DraggableFilterPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filters != oldWidget.filters) {
      _draftDate = widget.filters.date;
      _draftPlatform = widget.filters.platform;
      _draftViewBy = widget.filters.viewBy;
      _draftOutlets = List<String>.from(widget.filters.outlet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    const minMargin = 24.0;
    final popupWidth = math.min(350.0, screenSize.width - minMargin * 2);
    final popupMaxHeight = math.min(
      screenSize.height * 0.75,
      screenSize.height - minMargin * 2 - viewInsets.bottom,
    );
    final footerPadding = 16.0 + viewInsets.bottom;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ),
        SafeArea(
          minimum: const EdgeInsets.all(minMargin),
          child: Center(
            child: Container(
              width: popupWidth,
              constraints: BoxConstraints(maxHeight: popupMaxHeight),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Filters',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.close),
                          tooltip: 'Close filters',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                          child: _FilterControls(
                            date: _draftDate,
                            platform: _draftPlatform,
                            viewBy: _draftViewBy,
                            outlets: _draftOutlets,
                            showActions: false,
                            onDateChanged: (value) =>
                                setState(() => _draftDate = value),
                            onPlatformChanged: (value) =>
                                setState(() => _draftPlatform = value),
                            onViewByChanged: (value) =>
                                setState(() => _draftViewBy = value),
                            onOutletsChanged: (value) =>
                                setState(() => _draftOutlets = value),
                            onApply: _applyDrafts,
                            onReset: widget.onReset,
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              8,
                              16,
                              footerPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                    ),
                                    onPressed: _applyDrafts,
                                    icon: const Icon(Icons.check),
                                    label: const Text('Apply'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                    ),
                                    onPressed: widget.onReset,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Reset'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _applyDrafts() {
    if (_draftDate != widget.filters.date) {
      widget.onDateChanged(_draftDate);
    }
    if (_draftPlatform != widget.filters.platform) {
      widget.onPlatformChanged(_draftPlatform);
    }
    if (_draftViewBy != widget.filters.viewBy) {
      widget.onViewByChanged(_draftViewBy);
    }
    widget.onOutletsChanged(_draftOutlets);
    widget.onRefresh();
  }
}

class SectionScreen extends StatefulWidget {
  const SectionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.filters,
    required this.data,
    required this.section,
    required this.onDateChanged,
    required this.onPlatformChanged,
    required this.onViewByChanged,
    required this.onOutletsChanged,
    required this.onRefresh,
    required this.onReset,
  });

  final String title;
  final String subtitle;
  final FilterState filters;
  final ScreenData data;
  final MobileSection section;
  final void Function(String) onDateChanged;
  final void Function(String) onPlatformChanged;
  final void Function(String) onViewByChanged;
  final void Function(List<String>) onOutletsChanged;
  final VoidCallback onRefresh;
  final VoidCallback onReset;

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  bool _showFilterPopup = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth > 900;
    final filterPanelWidth = math.min(320.0, screenWidth * 0.25);

    final sectionContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          filters: widget.filters,
          lastUpdated: widget.data.generatedAt,
          onFilterTap: () => setState(() => _showFilterPopup = true),
        ),
        const SizedBox(height: 22),
        StatGrid(stats: widget.data.stats),
        const SizedBox(height: 22),
        if (widget.section == MobileSection.dashboard) ...[
          PlatformComparisonCard(data: widget.data),
          const SizedBox(height: 18),
        ] else if (widget.section == MobileSection.earnings) ...[
          EarningsMixCard(data: widget.data),
          const SizedBox(height: 18),
        ] else if (widget.section == MobileSection.advertisements) ...[
          CampaignComparisonCard(data: widget.data),
          const SizedBox(height: 18),
        ] else if (widget.section == MobileSection.charges) ...[
          ChargesBreakdownCard(data: widget.data),
          const SizedBox(height: 18),
        ] else if (widget.section == MobileSection.discounts) ...[
          CouponPerformanceCard(data: widget.data),
          const SizedBox(height: 18),
        ] else if (widget.section == MobileSection.refunds) ...[
          RefundSplitCard(data: widget.data),
          const SizedBox(height: 18),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LargeChartCard(
              spots: widget.data.chartPoints,
              chartColor: _sectionChartColor(widget.title),
              headline: widget.data.stats.first.value,
              lastUpdated: widget.data.generatedAt,
            ),
            const SizedBox(height: 16),
            InsightPanel(insights: widget.data.insights),
          ],
        ),
        const SizedBox(height: 22),
        DataTableCard(
          title: 'Quick summary',
          headers: widget.data.tableData.headers,
          rows: widget.data.tableData.rows,
        ),
        const SizedBox(height: 26),
      ],
    );

    return Stack(
      children: [
        isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 20, 0, 100),
                    child: SizedBox(
                      width: filterPanelWidth,
                      child: FilterPanel(
                        filters: widget.filters,
                        onDateChanged: widget.onDateChanged,
                        onPlatformChanged: widget.onPlatformChanged,
                        onViewByChanged: widget.onViewByChanged,
                        onOutletsChanged: widget.onOutletsChanged,
                        onRefresh: widget.onRefresh,
                        onReset: widget.onReset,
                        isCollapsed: false,
                        onToggle: () {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: SingleChildScrollView(
                      key: PageStorageKey('${widget.title}_scroll'),
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
                      child: sectionContent,
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                key: PageStorageKey('${widget.title}_scroll'),
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
                child: sectionContent,
              ),
        if (_showFilterPopup)
          DraggableFilterPopup(
            filters: widget.filters,
            onDateChanged: widget.onDateChanged,
            onPlatformChanged: widget.onPlatformChanged,
            onViewByChanged: widget.onViewByChanged,
            onOutletsChanged: widget.onOutletsChanged,
            onRefresh: () {
              widget.onRefresh();
              setState(() => _showFilterPopup = false);
            },
            onReset: () {
              widget.onReset();
              setState(() => _showFilterPopup = false);
            },
            onClose: () => setState(() => _showFilterPopup = false),
          ),
      ],
    );
  }

  Color _sectionChartColor(String title) {
    if (title.contains('Ads')) return const Color(0xFFFB923C);
    if (title.contains('Refund')) return const Color(0xFFEF4444);
    if (title.contains('Charge')) return const Color(0xFF8B5CF6);
    if (title.contains('Discount')) return const Color(0xFFEC4899);
    if (title.contains('Earnings')) return const Color(0xFF14B8A6);
    return const Color(0xFF2563EB);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.filters,
    required this.lastUpdated,
    required this.onFilterTap,
  });

  final String title;
  final String subtitle;
  final FilterState filters;
  final DateTime lastUpdated;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 720;

    String datePillLabel;
    if (filters.date.contains('-')) {
      datePillLabel = filters.date;
    } else {
      final dateLabel = switch (filters.date) {
        'Last Month' => 'May 1 - May 31, 2026',
        'Previous Month' => 'May 1 - May 31, 2026',
        'This Month' => 'Jun 1 - Jun 2, 2026',
        'Quarterly' => 'Mar 1 - Jun 1, 2026',
        _ => 'May 26 - Jun 1, 2026',
      };
      datePillLabel = '${filters.date} · $dateLabel';
    }

    String outletLabel;
    if (filters.outlet.contains('All outlets') || filters.outlet.isEmpty) {
      outletLabel = 'All outlets';
    } else if (filters.outlet.length > 1) {
      outletLabel = '${filters.outlet.length} outlets selected';
    } else if (filters.outlet.length == 1) {
      outletLabel = filters.outlet.first;
    } else {
      outletLabel = 'No selection';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isWide
              ? math.min(MediaQuery.sizeOf(context).width * 0.72, 560)
              : double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.78),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _StatusPill(
              icon: Icons.calendar_today_outlined,
              label: datePillLabel,
            ),
            _StatusPill(
              icon: Icons.storefront_outlined,
              label: '${filters.platform} · ${filters.viewBy}',
            ),
            _StatusPill(icon: Icons.business_outlined, label: outletLabel),
            _StatusPill(icon: Icons.sync, label: _formattedUpdatedLabel()),
            Tooltip(
              message: 'Open filters',
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onFilterTap,
                icon: const Icon(Icons.filter_alt_outlined),
                tooltip: 'Open filters',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formattedUpdatedLabel() {
    final date = lastUpdated;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour == 0 || date.hour == 12 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'AM' : 'PM';
    return 'Last updated ${months[date.month - 1]} ${date.day}, ${date.year} at $hour:$minute $period';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.stats});

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 900) {
      return SizedBox(
        height: 158,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          itemCount: stats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return SizedBox(width: 200, child: StatCard(item: stats[index]));
          },
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [...stats.map((item) => StatCard(item: item))],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.item});

  final StatItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: (item.color ?? Theme.of(context).colorScheme.primary)
                      .withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 18,
                  color: item.color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: item.color ?? Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.badge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: item.badge.startsWith('+')
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}

class LargeChartCard extends StatefulWidget {
  const LargeChartCard({
    super.key,
    required this.spots,
    required this.chartColor,
    required this.headline,
    required this.lastUpdated,
  });

  final List<FlSpot> spots;
  final Color chartColor;
  final String headline;
  final DateTime lastUpdated;

  @override
  State<LargeChartCard> createState() => _LargeChartCardState();
}

class _LargeChartCardState extends State<LargeChartCard> {
  String _metric = 'Sales';

  @override
  Widget build(BuildContext context) {
    final spots = _metricSpots();
    final yValues = spots.map((s) => s.y).toList();
    final minY = yValues.reduce((a, b) => a < b ? a : b);
    final maxY = yValues.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trends',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Daily view',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _ChartMetricTabs(
                value: _metric,
                color: widget.chartColor,
                onChanged: (value) => setState(() => _metric = value),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.headline,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            _updatedLabel(),
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 270,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    color: widget.chartColor,
                    isCurved: true,
                    barWidth: 3.5,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: widget.chartColor.withValues(alpha: 0.18),
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.5),
                    strokeWidth: 1,
                    dashArray: [6, 6],
                  ),
                ),
                minY: minY * 0.92,
                maxY: maxY * 1.08,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: math.max(1, (maxY - minY) / 4),
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: _getXAxisInterval(spots.length),
                      getTitlesWidget: (value, meta) {
                        if (value % 1 != 0) return const SizedBox.shrink();
                        final labels = _buildBottomLabels(spots.length);
                        final index = value.toInt() - 1;
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          labels[index],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) =>
                        Theme.of(context).brightness == Brightness.dark
                        ? Colors.white12
                        : Colors.black87,
                    getTooltipItems: (items) => items
                        .map(
                          (item) => LineTooltipItem(
                            item.y.toStringAsFixed(1),
                            const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _updatedLabel() {
    final delta = DateTime.now().difference(widget.lastUpdated);
    if (delta.inSeconds < 60) {
      return 'Updated just now';
    }
    if (delta.inMinutes < 60) {
      return 'Updated ${delta.inMinutes}m ago';
    }
    if (delta.inHours < 24) {
      return 'Updated ${delta.inHours}h ago';
    }
    return 'Updated ${delta.inDays}d ago';
  }

  List<FlSpot> _metricSpots() {
    final factor = switch (_metric) {
      'Payout' => 0.78,
      'Orders' => 0.52,
      _ => 1.0,
    };
    final lift = switch (_metric) {
      'Payout' => 2.0,
      'Orders' => 4.0,
      _ => 0.0,
    };
    return widget.spots
        .map((spot) => FlSpot(spot.x, (spot.y * factor) + lift))
        .toList();
  }

  static const _monthAbbreviations = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  double _getXAxisInterval(int pointCount) {
    if (pointCount <= 7) return 1;
    if (pointCount <= 10) return 2;
    if (pointCount <= 14) return 3;
    return 4;
  }

  List<String> _buildBottomLabels(int count) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: count - 1));
    return List.generate(count, (index) {
      final date = startDate.add(Duration(days: index));
      return '${date.day} ${_monthAbbreviations[date.month - 1]}';
    });
  }
}

class _ChartMetricTabs extends StatelessWidget {
  const _ChartMetricTabs({
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String value;
  final Color color;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final metric in const ['Sales', 'Payout', 'Orders'])
            _ChartMetricTab(
              label: metric,
              selected: metric == value,
              color: color,
              onTap: () => onChanged(metric),
            ),
        ],
      ),
    );
  }
}

class _ChartMetricTab extends StatelessWidget {
  const _ChartMetricTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? color
                : Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PlatformComparisonCard extends StatelessWidget {
  const PlatformComparisonCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final rows = data.tableData.rows;
    final left = rows.isNotEmpty ? rows[0] : null;
    final right = rows.length > 1 ? rows[1] : null;
    const leftShare = 0.57;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Platform comparison',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              _ShareBar(leftShare: leftShare),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 720;
              final children = [
                if (left != null)
                  Expanded(
                    child: _PlatformDetailCard(
                      row: left,
                      color: const Color(0xFFEF4444),
                      shareLabel: '57% share',
                    ),
                  ),
                if (!compact) const SizedBox(width: 14),
                if (right != null)
                  Expanded(
                    child: _PlatformDetailCard(
                      row: right,
                      color: const Color(0xFFF97316),
                      shareLabel: '43% share',
                    ),
                  ),
              ];
              if (compact) {
                return Column(
                  children: [
                    if (left != null)
                      _PlatformDetailCard(
                        row: left,
                        color: const Color(0xFFEF4444),
                        shareLabel: '57% share',
                      ),
                    if (left != null && right != null)
                      const SizedBox(height: 12),
                    if (right != null)
                      _PlatformDetailCard(
                        row: right,
                        color: const Color(0xFFF97316),
                        shareLabel: '43% share',
                      ),
                  ],
                );
              }
              return Row(children: children);
            },
          ),
        ],
      ),
    );
  }
}

class _ShareBar extends StatelessWidget {
  const _ShareBar({required this.leftShare});

  final double leftShare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: leftShare,
                backgroundColor: const Color(0xFFF97316),
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(leftShare * 100).round()}/${((1 - leftShare) * 100).round()}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PlatformDetailCard extends StatelessWidget {
  const _PlatformDetailCard({
    required this.row,
    required this.color,
    required this.shareLabel,
  });

  final List<String> row;
  final Color color;
  final String shareLabel;

  @override
  Widget build(BuildContext context) {
    final payout = row.length > 2 ? row[2] : row[1];
    final share = row.length > 3 ? row[3] : shareLabel;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  row[0],
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                shareLabel,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 14,
            children: [
              _MetricPair(label: 'GOV', value: row[1]),
              _MetricPair(label: 'Payout', value: payout),
              _MetricPair(label: 'Share', value: share),
              _MetricPair(label: 'Margin', value: '75.8%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricPair extends StatelessWidget {
  const _MetricPair({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 5),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class CampaignComparisonCard extends StatelessWidget {
  const CampaignComparisonCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final salesSpots = data.chartPoints;
    final spendGroups = salesSpots.take(8).map((spot) {
      return BarChartGroupData(
        x: spot.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: spot.y * 0.55,
            color: const Color(0xFF8B5CF6),
            width: 10,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ad spend vs sales timeline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Shaded periods indicate active campaigns',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const _LegendDot(label: 'Sales', color: Color(0xFF10B981)),
              const SizedBox(width: 12),
              const _LegendDot(label: 'Ad spend', color: Color(0xFF8B5CF6)),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                BarChart(
                  BarChartData(
                    barGroups: spendGroups,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                  ),
                ),
                LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: salesSpots,
                        isCurved: true,
                        color: const Color(0xFF10B981),
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    lineTouchData: LineTouchData(enabled: false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _CampaignChip(label: 'Search boost', value: '+18.5% lift'),
              _CampaignChip(label: 'Meal combo', value: '3.2x ROAS'),
              _CampaignChip(label: 'Dinner slot', value: 'Best margin'),
            ],
          ),
        ],
      ),
    );
  }
}

class CouponPerformanceCard extends StatelessWidget {
  const CouponPerformanceCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final rows = data.tableData.rows;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Coupon performance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            'Top coupons by orders and burn',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          ...rows.take(4).map((row) {
            final progress = 0.42 + (rows.indexOf(row) * 0.12);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ProgressRow(
                label: row[0],
                value: '${row[1]} orders · ${row[2]}',
                progress: progress.clamp(0.0, 0.92),
                color: const Color(0xFFDB2777),
              ),
            );
          }),
          const Divider(height: 24),
          const Row(
            children: [
              Expanded(
                child: _FundingTile(
                  title: 'Restaurant funded',
                  value: '62%',
                  color: Color(0xFFDB2777),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FundingTile(
                  title: 'Platform funded',
                  value: '38%',
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RefundSplitCard extends StatelessWidget {
  const RefundSplitCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final rows = data.tableData.rows;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Refund split',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            'Outlet and platform-level refund breakdown',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          const _ProgressRow(
            label: 'Zomato',
            value: '57% refund share',
            progress: 0.57,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 12),
          const _ProgressRow(
            label: 'Swiggy',
            value: '43% refund share',
            progress: 0.43,
            color: Color(0xFFF97316),
          ),
          const Divider(height: 26),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final row in rows.take(4))
                _IssueChip(label: row[0], value: '${row[1]} · ${row[3]}'),
            ],
          ),
        ],
      ),
    );
  }
}

class EarningsMixCard extends StatelessWidget {
  const EarningsMixCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final rows = data.tableData.rows;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sales mix by outlet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          ...rows.take(4).map((row) {
            final index = rows.indexOf(row);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProgressRow(
                label: row[0],
                value: '${row[1]} · ${row[2]} orders',
                progress: (0.72 - (index * 0.1)).clamp(0.28, 0.9),
                color: const Color(0xFF14B8A6),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ChargesBreakdownCard extends StatelessWidget {
  const ChargesBreakdownCard({super.key, required this.data});

  final ScreenData data;

  @override
  Widget build(BuildContext context) {
    final rows = data.tableData.rows;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Charge breakdown',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          ...rows.map((row) {
            final index = rows.indexOf(row);
            final color = [
              const Color(0xFF7C3AED),
              const Color(0xFF2563EB),
              const Color(0xFFF59E0B),
              const Color(0xFFEF4444),
            ][index % 4];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProgressRow(
                label: row[0],
                value: '${row[1]} · ${row[2]}',
                progress: (0.78 - (index * 0.14)).clamp(0.2, 0.9),
                color: color,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

class _CampaignChip extends StatelessWidget {
  const _CampaignChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _MetricChip(
      icon: Icons.campaign_outlined,
      label: label,
      value: value,
    );
  }
}

class _IssueChip extends StatelessWidget {
  const _IssueChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _MetricChip(
      icon: Icons.warning_amber_outlined,
      label: label,
      value: value,
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress,
            color: color,
            backgroundColor: color.withValues(alpha: 0.14),
          ),
        ),
      ],
    );
  }
}

class _FundingTile extends StatelessWidget {
  const _FundingTile({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: child,
    );
  }
}

class InsightPanel extends StatelessWidget {
  const InsightPanel({super.key, required this.insights});

  final List<InsightItem> insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Operational insights',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          ...insights.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: item.color.withValues(alpha: 0.2),
                    child: Icon(item.icon, size: 18, color: item.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DataTableCard extends StatelessWidget {
  const DataTableCard({
    super.key,
    required this.title,
    required this.headers,
    required this.rows,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [...headers.map((label) => _TagChip(label: label))],
          ),
          const Divider(height: 28),
          ...rows.asMap().entries.map((entry) {
            final row = entry.value;
            final isEven = entry.key.isEven;
            return Container(
              decoration: BoxDecoration(
                color: isEven
                    ? Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF111827)
                          : const Color(0xFFF8FAFC)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Row(
                children: [
                  ...row.map(
                    (cell) => Expanded(
                      child: Text(
                        cell,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF111827)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
