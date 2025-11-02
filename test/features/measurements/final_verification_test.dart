// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:sartor_order_management/features/orders/new_order_screen.dart';
// import 'package:sartor_order_management/features/orders/measurements_selection_screen.dart';
// import 'package:sartor_order_management/models/measurement_template.dart';
// import 'package:sartor_order_management/providers/measurement_template_provider.dart';
// import 'package:sartor_order_management/providers/recommended_templates_provider.dart';
// import '../../mocks/mock_measurement_template_repository.dart';
// import '../../mocks/mock_service_repository.dart';
// import 'package:sartor_order_management/services/service_repository.dart' hide MockServiceRepository;
// import 'package:sartor_order_management/models/service.dart';
// import 'package:sartor_order_management/models/service_category.dart';

// void main() {
//   late MockMeasurementTemplateRepository mockTemplateRepository;
//   late MockServiceRepository mockServiceRepository;

//   setUp(() {
//     mockTemplateRepository = MockMeasurementTemplateRepository();
//     mockServiceRepository = MockServiceRepository();
//   });

//   group('Measurement Templates System - Final Verification', () {
//     testWidgets(
//         'Integration Test: Template recommendations work in a real order scenario',
//         (WidgetTester tester) async {
//       final templates = [
//         const MeasurementTemplate(
//           id: '1',
//           name: 'Slim Fit Shirt',
//           description: 'A slim fit shirt template',
//           standardMeasurements: {'neck': 15.5, 'chest': 40.0},
//           measurementRanges: {'neck': [14, 18], 'chest': [38, 42]},
//           category: 'Shirts',
//         ),
//         const MeasurementTemplate(
//           id: '2',
//           name: 'Regular Fit Trousers',
//           description: 'A regular fit trousers template',
//           standardMeasurements: {'waist': 32.0, 'inseam': 30.0},
//           measurementRanges: {'waist': [30, 34], 'inseam': [28, 32]},
//           category: 'Trousers',
//         ),
//       ];

//       final services = [
//         const Service(
//             id: 1,
//             name: 'Shirt',
//             description: 'A shirt',
//             price: 10,
//             category: ServiceCategory.mensWear)
//       ];
//       when(mockTemplateRepository.getMeasurementTemplates())
//           .thenAnswer((_) async => templates);
//       when(mockServiceRepository.getServices()).thenAnswer((_) async => services);

//       await tester.pumpWidget(
//         ProviderScope(
//           overrides: [
//             measurementTemplateRepositoryProvider
//                 .overrideWithValue(mockTemplateRepository),
//             allServicesProvider.overrideWith((ref) async => services),
//             recommendedTemplatesProvider.overrideWithValue(AsyncData(templates
//                 .map((t) => Recommendation(template: t, score: 1, confidence: 1))
//                 .toList())),
//           ],
//           child: const MaterialApp(
//             home: NewOrderScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       // Assuming the recommendations are displayed on the MeasurementsSelectionScreen
//       expect(find.byType(MeasurementsSelectionScreen), findsOneWidget);
//       expect(find.text('Slim Fit Shirt'), findsOneWidget);
//       expect(find.text('Regular Fit Trousers'), findsOneWidget);
//     });

//     testWidgets('Performance Validation: Recommendation algorithms respond quickly',
//         (WidgetTester tester) async {
//       final templates = List.generate(
//         100,
//         (i) => MeasurementTemplate(
//           id: '$i',
//           name: 'Template $i',
//           description: 'Description $i',
//           standardMeasurements: {'value': i.toDouble()},
//           measurementRanges: {'value': [i - 1, i + 1]},
//           category: 'Category',
//         ),
//       );

//       final stopwatch = Stopwatch()..start();

//       await tester.pumpWidget(
//         ProviderScope(
//           overrides: [
//             recommendedTemplatesProvider.overrideWithValue(AsyncData(templates
//                 .map((t) => Recommendation(template: t, score: 1, confidence: 1))
//                 .toList())),
//           ],
//           child: const MaterialApp(
//             home: MeasurementsSelectionScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();

//       stopwatch.stop();

//       expect(stopwatch.elapsedMilliseconds, lessThan(200),
//           reason: 'Recommendation algorithm should be fast');
//       expect(find.text('Template 99'), findsOneWidget);
//     });

//     testWidgets('User Experience Review: Complete flow from template selection to order completion',
//         (WidgetTester tester) async {
//       const template = MeasurementTemplate(
//         id: '1',
//         name: 'Test Template',
//         description: 'Test Description',
//         standardMeasurements: {'chest': 40.0, 'waist': 32.0},
//         measurementRanges: {'chest': [38, 42], 'waist': [30, 34]},
//         category: 'Test Category',
//       );

//       when(mockTemplateRepository.getMeasurementTemplates())
//           .thenAnswer((_) async => [template]);

//       await tester.pumpWidget(
//         ProviderScope(
//           overrides: [
//             measurementTemplateRepositoryProvider
//                 .overrideWithValue(mockTemplateRepository),
//             recommendedTemplatesProvider.overrideWithValue(AsyncData(
//                 [Recommendation(template: template, score: 1, confidence: 1)])),
//           ],
//           child: const MaterialApp(
//             home: NewOrderScreen(),
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();
//       await tester.tap(find.text('Test Template'));
//       await tester.pumpAndSettle();

//       // Assuming the app navigates to a measurement form
//       await tester.enterText(find.byKey(const Key('chest_field')), '42');
//       await tester.enterText(find.byKey(const Key('waist_field')), '34');
//       await tester.tap(find.text('Confirm'));
//       await tester.pumpAndSettle();

//       // Check for a confirmation dialog or navigation to the next screen
//       expect(find.text('Order Confirmed'), findsOneWidget);
//     });
//   });
// }
