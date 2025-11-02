import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/template_analytics.dart';
import 'package:sartor_order_management/services/analytics_service.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

final analyticsServiceProvider = Provider((ref) => AnalyticsService(ref.read(supabaseProvider)));

final templateUsageProvider = FutureProvider<List<TemplateUsage>>((ref) async {
  return ref.watch(analyticsServiceProvider).getTemplateUsageStatistics();
});

final templateConversionProvider = FutureProvider<List<TemplateConversion>>((ref) async {
  return ref.watch(analyticsServiceProvider).getTemplateConversionRates();
});

class TemplateAnalyticsScreen extends ConsumerWidget {
  const TemplateAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageAsync = ref.watch(templateUsageProvider);
    final conversionAsync = ref.watch(templateConversionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Template Usage', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            usageAsync.when(
              data: (usage) => DataTable(
                columns: const [
                  DataColumn(label: Text('Template')),
                  DataColumn(label: Text('Usage Count')),
                ],
                rows: usage
                    .map((u) => DataRow(cells: [
                          DataCell(Text(u.templateName)),
                          DataCell(Text(u.orderCount.toString())),
                        ]))
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            const SizedBox(height: 24),
            Text('Template Conversion Rates', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            conversionAsync.when(
              data: (conversion) => DataTable(
                columns: const [
                  DataColumn(label: Text('Template')),
                  DataColumn(label: Text('Template Usage')),
                  DataColumn(label: Text('Custom Usage')),
                  DataColumn(label: Text('Conversion Rate')),
                ],
                rows: conversion
                    .map((c) => DataRow(cells: [
                          DataCell(Text(c.templateName)),
                          DataCell(Text(c.templateUsage.toString())),
                          DataCell(Text(c.customUsage.toString())),
                          DataCell(Text('${c.conversionRate.toStringAsFixed(2)}%')),
                        ]))
                    .toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }
}
