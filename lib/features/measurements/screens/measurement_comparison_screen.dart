import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/measurement.dart';

class MeasurementComparisonScreen extends StatelessWidget {
  final Measurement measurement1;
  final Measurement measurement2;

  const MeasurementComparisonScreen({
    super.key,
    required this.measurement1,
    required this.measurement2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Compare ${measurement1.profileName ?? 'Unnamed'} and ${measurement2.profileName ?? 'Unnamed'}'),
      ),
      body: ListView(
        children: [
          DataTable(
            columns: [
              const DataColumn(label: Text('Measurement')),
              DataColumn(label: Text(measurement1.profileName ?? 'Unnamed')),
              DataColumn(label: Text(measurement2.profileName ?? 'Unnamed')),
            ],
            rows: _buildComparisonRows(),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildComparisonRows() {
    final allKeys = {...measurement1.measurements.keys, ...measurement2.measurements.keys};
    return allKeys.map((key) {
      final value1 = measurement1.measurements[key];
      final value2 = measurement2.measurements[key];
      final isDifferent = value1 != value2;

      return DataRow(
        cells: [
          DataCell(Text(key)),
          DataCell(
            Text(
              value1?.toString() ?? '-',
              style: TextStyle(
                fontWeight: isDifferent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          DataCell(
            Text(
              value2?.toString() ?? '-',
              style: TextStyle(
                fontWeight: isDifferent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
