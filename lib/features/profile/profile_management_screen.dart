import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileStats {
  final String name;
  final int measurementCount;
  final DateTime lastUpdated;
  final Map<String, double> measurements;

  const ProfileStats({
    required this.name,
    required this.measurementCount,
    required this.lastUpdated,
    required this.measurements,
  });
}

class ProfileMeasurementChart extends StatelessWidget {
  final List<ProfileStats> profiles;
  final String measurementType;

  const ProfileMeasurementChart({
    super.key,
    required this.profiles,
    required this.measurementType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Measurement Trend: $measurementType',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final value = profile.measurements[measurementType] ?? 0;
                final maxValue = profiles
                    .map((p) => p.measurements[measurementType] ?? 0)
                    .reduce((a, b) => a > b ? a : b);
                
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        value.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          height: (value / maxValue) * 100,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.name.split(' ').map((w) => w[0]).join(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileManagementScreen extends ConsumerStatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  ConsumerState<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends ConsumerState<ProfileManagementScreen> {
  String? _selectedProfile;
  String? _defaultProfile;
  final Set<String> _selectedForCopy = {};
  bool _showComparison = false;

  // Sample data - replace with actual data from your repository
  final List<ProfileStats> _profiles = [
    ProfileStats(
      name: 'Casual Wear',
      measurementCount: 12,
      lastUpdated: DateTime.now().subtract(const Duration(days: 7)),
      measurements: {
        'chest': 40.0,
        'waist': 34.0,
        'shoulder': 17.5,
      },
    ),
    ProfileStats(
      name: 'Formal Wear',
      measurementCount: 15,
      lastUpdated: DateTime.now().subtract(const Duration(days: 14)),
      measurements: {
        'chest': 41.0,
        'waist': 35.0,
        'shoulder': 18.0,
      },
    ),
  ];

  Widget _buildProfileCard(ProfileStats profile) {
    final theme = Theme.of(context);
    final lastUpdated = DateTime.now().difference(profile.lastUpdated);
    final lastUpdatedText = lastUpdated.inDays > 0
        ? '${lastUpdated.inDays}d ago'
        : '${lastUpdated.inHours}h ago';

    return Card(
      child: InkWell(
        onTap: () => setState(() => _selectedProfile = profile.name),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: _selectedForCopy.contains(profile.name),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedForCopy.add(profile.name);
                    } else {
                      _selectedForCopy.remove(profile.name);
                    }
                  });
                },
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.primaryColorLight,
                child: Text(
                  profile.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        profile.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      leading: Icon(
                        _defaultProfile == profile.name
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                      onTap: () {
                        setState(() {
                          _defaultProfile = profile.name;
                        });
                      },
                    ),
                    Text(
                      '${profile.measurementCount} measurements',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Updated $lastUpdatedText',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // Navigate to edit screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSwitch() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.swap_horiz),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<String>(
                value: _selectedProfile,
                hint: const Text('Switch Profile'),
                isExpanded: true,
                items: _profiles.map((profile) {
                  return DropdownMenuItem(
                    value: profile.name,
                    child: Text(profile.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedProfile = value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Measurement')),
          DataColumn(label: Text('Casual Wear')),
          DataColumn(label: Text('Formal Wear')),
          DataColumn(label: Text('Difference')),
        ],
        rows: [
          DataRow(cells: [
            const DataCell(Text('Chest')),
            DataCell(Text(_profiles[0].measurements['chest'].toString())),
            DataCell(Text(_profiles[1].measurements['chest'].toString())),
            DataCell(Text(
              (_profiles[1].measurements['chest']! - _profiles[0].measurements['chest']!).toStringAsFixed(1),
              style: TextStyle(
                color: _profiles[1].measurements['chest']! > _profiles[0].measurements['chest']!
                    ? Colors.green
                    : Colors.red,
              ),
            )),
          ]),
          DataRow(cells: [
            const DataCell(Text('Waist')),
            DataCell(Text(_profiles[0].measurements['waist'].toString())),
            DataCell(Text(_profiles[1].measurements['waist'].toString())),
            DataCell(Text(
              (_profiles[1].measurements['waist']! - _profiles[0].measurements['waist']!).toStringAsFixed(1),
              style: TextStyle(
                color: _profiles[1].measurements['waist']! > _profiles[0].measurements['waist']!
                    ? Colors.red
                    : Colors.green,
              ),
            )),
          ]),
          DataRow(cells: [
            const DataCell(Text('Shoulder')),
            DataCell(Text(_profiles[0].measurements['shoulder'].toString())),
            DataCell(Text(_profiles[1].measurements['shoulder'].toString())),
            DataCell(Text(
              (_profiles[1].measurements['shoulder']! - _profiles[0].measurements['shoulder']!).toStringAsFixed(1),
              style: TextStyle(
                color: _profiles[1].measurements['shoulder']! > _profiles[0].measurements['shoulder']!
                    ? Colors.green
                    : Colors.red,
              ),
            )),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        actions: [
          if (_selectedForCopy.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                // Implement copy functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Measurements copied')),
                );
                setState(() => _selectedForCopy.clear());
              },
            ),
          IconButton(
            icon: Icon(_showComparison ? Icons.grid_view : Icons.compare_arrows),
            onPressed: () {
              setState(() => _showComparison = !_showComparison);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickSwitch(),
              const SizedBox(height: 24),
              
              Text(
                'Your Profiles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _profiles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _buildProfileCard(_profiles[index]),
              ),
              
              if (_showComparison) ...[
                const SizedBox(height: 24),
                Text(
                  'Profile Comparison',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildComparisonTable(),
              ],
              
              const SizedBox(height: 24),
              Text(
                'Measurement Trends',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ProfileMeasurementChart(
                profiles: _profiles,
                measurementType: 'chest',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'profile_management_fab',
        onPressed: () {
          // Navigate to create new profile
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
