import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final measurementsProvider = FutureProvider<List<Measurement>>((ref) async {
  final repository = ref.watch(measurementRepositoryProvider);
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  return repository.getMeasurements(userId);
});

class MeasurementsListScreen extends ConsumerStatefulWidget {
  final Function(String)? onMeasurementSelected;
  final String? selectedMeasurementId;

  const MeasurementsListScreen({
    super.key,
    this.onMeasurementSelected,
    this.selectedMeasurementId,
  });

  @override
  ConsumerState<MeasurementsListScreen> createState() => _MeasurementsListScreenState();
}

class _MeasurementsListScreenState extends ConsumerState<MeasurementsListScreen> {
  final _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showFab = _scrollController.position.userScrollDirection == ScrollDirection.idle;
    if (showFab != _showFab) {
      setState(() => _showFab = showFab);
    }
  }

  Widget _buildSummaryCard(BuildContext context, Measurement measurement) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  measurement.name,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  measurement.value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (measurement.history.isNotEmpty) ...[
              Text(
                'Trend',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 30,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: measurement.history
                            .asMap()
                            .entries
                            .map((e) {
                              final values = e.value.values;
                              if (values.isEmpty) return null;
                              return FlSpot(e.key.toDouble(), values.values.fold(0.0, (a, b) => a + b) / values.length);
                            })
                            .where((spot) => spot != null)
                            .cast<FlSpot>()
                            .toList(),
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: HSLColor.fromColor(theme.colorScheme.primary)
                              .withAlpha(0.1)
                              .toColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTimeline(BuildContext context, List<Measurement> measurements) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recent Updates',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: measurements.length,
            itemBuilder: (context, index) {
              final measurement = measurements[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    measurement.name[0],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                title: Text(measurement.name),
                subtitle: Text(
                  '${measurement.value} • ${timeago.format(measurement.lastUpdated)}',
                ),
                trailing: Icon(
                  measurement.trend == null
                      ? Icons.trending_flat
                      : measurement.trend! > 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                  color: measurement.trend == null
                      ? Colors.grey
                      : measurement.trend! > 0
                          ? Colors.green
                          : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSizeRecommendations(BuildContext context, String bodyType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Size Recommendations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your $bodyType body type:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildRecommendationChip('Fitted shirts: M'),
                _buildRecommendationChip('Regular fit: L'),
                _buildRecommendationChip('Pants: 32'),
                _buildRecommendationChip('Jacket: 40R'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.straighten,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Measurements Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your measurements to get personalized size recommendations',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              // TODO: Navigate to measurement form
            },
            icon: const Icon(Icons.add),
            label: const Text('Add First Measurement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual measurements provider
    final measurements = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Measurements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // TODO: Show measurement guide
            },
          ),
        ],
      ),
      body: measurements.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (measurements) {
          if (measurements.isEmpty) {
            return _buildEmptyState(context);
          }

          return ResponsiveLayout(
            mobileBody: _buildMobileLayout(measurements),
            tabletBody: _buildTabletLayout(measurements),
          );
        },
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Show quick measurement input bottom sheet
              },
              icon: const Icon(Icons.add),
              label: const Text('New Measurement'),
            )
          : null,
    );
  }

  Widget _buildMobileLayout(List<Measurement> measurements) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      children: [
        // Summary Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: measurements.length,
          itemBuilder: (context, index) => _buildSummaryCard(
            context,
            measurements[index],
          ),
        ),

        const SizedBox(height: 24),

        // Recent Updates Timeline
        _buildRecentTimeline(context, measurements),

        const SizedBox(height: 24),

        // Size Recommendations
        _buildSizeRecommendations(context, 'Athletic'), // TODO: Calculate body type

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTabletLayout(List<Measurement> measurements) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(24.0),
      children: [
        // Summary Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: measurements.length,
          itemBuilder: (context, index) => _buildSummaryCard(
            context,
            measurements[index],
          ),
        ),

        const SizedBox(height: 24),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildRecentTimeline(context, measurements),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSizeRecommendations(context, 'Athletic'), // TODO: Calculate body type
            ),
          ],
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
        onPressed: () {
          // TODO: Show quick measurement input bottom sheet
        },
        icon: const Icon(Icons.add),
        label: const Text('New Measurement'),
      ) : null,
    );
  }
}
