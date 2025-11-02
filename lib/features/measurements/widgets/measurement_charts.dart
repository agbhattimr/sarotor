import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/utils/size_standards.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MeasurementCharts extends StatefulWidget {
  final Measurement measurement;
  const MeasurementCharts({super.key, required this.measurement});

  @override
  State<MeasurementCharts> createState() => _MeasurementChartsState();
}

class _MeasurementChartsState extends State<MeasurementCharts> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.measurement.measurements.entries
        .where((entry) => entry.value != null)
        .toList();

    return VisibilityDetector(
      key: const Key('measurement-charts'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Measurement Charts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!_isVisible)
                const Center(child: CircularProgressIndicator())
              else if (data.isEmpty)
                const Center(child: Text('No measurements to display.'))
              else
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: data
                              .map((e) => e.value!)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      barGroups: data
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.value!,
                                  color: Colors.blue,
                                  width: 16,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < data.length) {
                                return Text(
                                  data[index].key,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                            reservedSize: 42,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text('Size Comparison',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!_isVisible)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 300,
                  child: RadarChart(
                    RadarChartData(
                      dataSets: _buildRadarDataSets(),
                      radarShape: RadarShape.circle,
                      tickCount: 5,
                      ticksTextStyle: const TextStyle(
                          color: Colors.transparent, fontSize: 10),
                      getTitle: (index, angle) {
                        final title =
                            SizeStandards.standardSizes['shirt']!.keys.elementAt(index);
                        return RadarChartTitle(text: title, angle: angle);
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text('Measurement History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!_isVisible)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: _buildLineChartData(),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text('Body Shape',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _getBodyShape(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<RadarDataSet> _buildRadarDataSets() {
    final userMeasurements = widget.measurement.measurements;
    final dataSets = <RadarDataSet>[];

    // Add user's measurements
    dataSets.add(
      RadarDataSet(
        dataEntries: userMeasurements.entries
            .map((entry) => RadarEntry(value: entry.value ?? 0))
            .toList(),
        borderColor: Colors.blue,
        fillColor: Colors.blue.withAlpha(51),
      ),
    );

    // Add standard sizes
    SizeStandards.standardSizes.forEach((size, measurements) {
      dataSets.add(
        RadarDataSet(
          dataEntries: measurements.entries
              .map((entry) => RadarEntry(value: entry.value))
              .toList(),
          borderColor: Colors.grey.withAlpha(128),
          fillColor: Colors.transparent,
        ),
      );
    });

    return dataSets;
  }

  List<LineChartBarData> _buildLineChartData() {
    final history = widget.measurement.measurements.entries
        .where((entry) => entry.value != null)
        .toList();

    if (history.isEmpty) {
      return [];
    }

    return [
      LineChartBarData(
        spots: history
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value!))
            .toList(),
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          color: Colors.blue.withAlpha(51),
        ),
      ),
    ];
  }

  String _getBodyShape() {
    final bust = widget.measurement.measurements['chest'] ?? 0;
    final waist = widget.measurement.measurements['waist'] ?? 0;
    final hips = widget.measurement.measurements['hips'] ?? 0;

    if (bust == 0 || waist == 0 || hips == 0) {
      return 'Not enough data';
    }

    if (bust > hips && (bust - hips).abs() > 1) {
      return 'Inverted Triangle';
    }

    if (hips > bust && (hips - bust).abs() > 1) {
      return 'Pear';
    }

    if ((bust - waist).abs() >= 9 && (hips - waist).abs() >= 9) {
      return 'Hourglass';
    }

    if ((bust - waist).abs() < 9 && (hips - waist).abs() < 9) {
      return 'Rectangle';
    }

    return 'Apple';
  }
}
