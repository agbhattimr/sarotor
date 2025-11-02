import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/orders/measurements_selection_screen.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';

void main() {
  group('MeasurementsSelectionScreen', () {
    testWidgets('shows loading indicator when measurements are being fetched',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            measurementsProvider.overrideWith((ref) => Future.value([])),
            measurementValidationProvider.overrideWith((ref) =>
                Future.value(MeasurementValidationResult(isValid: true, message: ''))),
          ],
          child: const MaterialApp(
            home: MeasurementsSelectionScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows create new measurement section when no measurements are available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            measurementsProvider.overrideWith((ref) => Future.value([])),
            measurementValidationProvider.overrideWith((ref) =>
                Future.value(MeasurementValidationResult(isValid: true, message: ''))),
          ],
          child: const MaterialApp(
            home: MeasurementsSelectionScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Need to Create a New Profile?'), findsOneWidget);
      expect(find.text('Create New Measurement Profile'), findsOneWidget);
    });

    testWidgets('displays measurements when fetch is successful',
        (WidgetTester tester) async {
      final measurements = [
        Measurement(id: '1', name: 'Test Measurement 1', measurements: {}, createdAt: DateTime.now(), isCustom: false),
        Measurement(id: '2', name: 'Test Measurement 2', measurements: {}, createdAt: DateTime.now(), isCustom: false),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            measurementsProvider.overrideWith((ref) => Future.value(measurements)),
            measurementValidationProvider.overrideWith((ref) =>
                Future.value(MeasurementValidationResult(isValid: true, message: ''))),
          ],
          child: const MaterialApp(
            home: MeasurementsSelectionScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Test Measurement 1'), findsOneWidget);
      expect(find.text('Test Measurement 2'), findsOneWidget);
    });
  });
}
