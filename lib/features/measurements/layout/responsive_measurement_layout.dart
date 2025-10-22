import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/measurements/screens/measurements_list_screen.dart';
import 'package:sartor_order_management/features/measurements/screens/measurement_detail_screen.dart';
import 'package:sartor_order_management/features/measurements/screens/measurement_history_screen.dart';
import 'package:sartor_order_management/features/measurements/screens/measurement_templates_screen.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

enum MeasurementSection {
  list(icon: Icons.straighten, label: 'Measurements'),
  history(icon: Icons.history, label: 'History'),
  settings(icon: Icons.settings, label: 'Settings');

  final IconData icon;
  final String label;
  const MeasurementSection({required this.icon, required this.label});
}

class ResponsiveMeasurementLayout extends ConsumerStatefulWidget {
  const ResponsiveMeasurementLayout({super.key});

  @override
  ConsumerState<ResponsiveMeasurementLayout> createState() => _ResponsiveMeasurementLayoutState();
}

class _ResponsiveMeasurementLayoutState extends ConsumerState<ResponsiveMeasurementLayout> {
  MeasurementSection _selectedSection = MeasurementSection.list;
  String? _selectedMeasurementId;
  bool _isNavigationExtended = false;

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedSection.index,
        children: [
          MeasurementsListScreen(
            onMeasurementSelected: (id) => setState(() => _selectedMeasurementId = id),
            selectedMeasurementId: _selectedMeasurementId,
          ),
          MeasurementHistoryScreen(
            measurementId: _selectedMeasurementId,
            onClose: () => setState(() => _selectedMeasurementId = null),
          ),
          const Placeholder(), // Settings screen
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedSection.index,
        onDestinationSelected: (index) {
          setState(() {
            _selectedSection = MeasurementSection.values[index];
            // Clear selection when switching sections on mobile
            _selectedMeasurementId = null;
          });
        },
        destinations: MeasurementSection.values.map((section) {
          return NavigationDestination(
            icon: Icon(section.icon),
            label: section.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false,
            selectedIndex: _selectedSection.index,
            onDestinationSelected: (index) {
              setState(() {
                _selectedSection = MeasurementSection.values[index];
              });
            },
            destinations: MeasurementSection.values.map((section) {
              return NavigationRailDestination(
                icon: Icon(section.icon),
                label: Text(section.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Master view
          Expanded(
            flex: 1,
            child: IndexedStack(
              index: _selectedSection.index,
              children: [
                MeasurementsListScreen(
                  onMeasurementSelected: (id) {
                    setState(() => _selectedMeasurementId = id);
                  },
                  selectedMeasurementId: _selectedMeasurementId,
                ),
                const MeasurementTemplatesScreen(),
                const MeasurementHistoryScreen(),
                const Placeholder(), // Settings screen
              ],
            ),
          ),
          // Detail view when measurement is selected
          if (_selectedMeasurementId != null && _selectedSection == MeasurementSection.list)
            const VerticalDivider(thickness: 1, width: 1),
          if (_selectedMeasurementId != null && _selectedSection == MeasurementSection.list)
            Expanded(
              flex: 1,
              child: MeasurementDetailScreen(
                measurementId: _selectedMeasurementId!,
                onClose: () {
                  setState(() => _selectedMeasurementId = null);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: _isNavigationExtended,
            selectedIndex: _selectedSection.index,
            onDestinationSelected: (index) {
              setState(() {
                _selectedSection = MeasurementSection.values[index];
              });
            },
            destinations: MeasurementSection.values.map((section) {
              return NavigationRailDestination(
                icon: Icon(section.icon),
                label: Text(section.label),
              );
            }).toList(),
            leading: Column(
              children: [
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(_isNavigationExtended 
                      ? Icons.chevron_left 
                      : Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _isNavigationExtended = !_isNavigationExtended;
                    });
                  },
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Multi-panel layout
          Expanded(
            child: Row(
              children: [
                // Primary panel (list/templates/history)
                Expanded(
                  flex: 2,
                  child: IndexedStack(
                    index: _selectedSection.index,
                    children: [
                      MeasurementsListScreen(
                        onMeasurementSelected: (id) {
                          setState(() => _selectedMeasurementId = id);
                        },
                        selectedMeasurementId: _selectedMeasurementId,
                      ),
                      const MeasurementTemplatesScreen(),
                      const MeasurementHistoryScreen(),
                      const Placeholder(), // Settings screen
                    ],
                  ),
                ),
                // Secondary panel (details/preview)
                if (_selectedSection == MeasurementSection.list) ...[
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    flex: 2,
                    child: _selectedMeasurementId != null
                        ? MeasurementDetailScreen(
                            measurementId: _selectedMeasurementId!,
                            onClose: () {
                              setState(() => _selectedMeasurementId = null);
                            },
                          )
                        : const Center(
                            child: Text('Select a measurement to view details'),
                          ),
                  ),
                ],
                // Optional tertiary panel for history/analytics
                if (_selectedSection == MeasurementSection.list &&
                    _selectedMeasurementId != null) ...[
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    flex: 1,
                    child: MeasurementHistoryScreen(
                      measurementId: _selectedMeasurementId,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(context),
      tabletBody: _buildTabletLayout(context),
      desktopBody: _buildDesktopLayout(context),
    );
  }
}
