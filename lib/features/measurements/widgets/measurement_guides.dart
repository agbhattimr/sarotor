import 'package:flutter/material.dart';
import 'package:sartor_order_management/utils/measurement_images.dart';

class MeasurementGuides extends StatelessWidget {
  final String? selectedMeasurement;
  const MeasurementGuides({super.key, this.selectedMeasurement});

  @override
  Widget build(BuildContext context) {
    final imagePath = measurementImages[selectedMeasurement?.toLowerCase()];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Measurement Guides',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (selectedMeasurement == null)
              const Center(child: Text('Select a measurement to see a guide.'))
            else
              Center(
                child: Column(
                  children: [
                    Text(
                      selectedMeasurement!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: imagePath != null
                          ? Image.asset(
                              imagePath,
                              key: ValueKey<String>(imagePath),
                              height: 150,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.image,
                              key: const ValueKey<String>('placeholder'),
                              size: 150,
                              color: Colors.grey[400],
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
