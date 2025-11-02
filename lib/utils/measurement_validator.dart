import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/utils/size_standards.dart';

enum AlertLevel {
  critical,
  warning,
  info,
  success,
}

class ValidationAlert {
  final String message;
  final AlertLevel level;
  final String? detailedExplanation;
  final String? correctiveAction;
  final String? guideLink;

  ValidationAlert({
    required this.message,
    required this.level,
    this.detailedExplanation,
    this.correctiveAction,
    this.guideLink,
  });
}

class MeasurementValidator {
  static List<ValidationAlert> validate(Measurement measurement,
      {Service? service, Measurement? previousMeasurement}) {
    final List<ValidationAlert> alerts = [];
    final values = measurement.measurements;
    final previousValues = previousMeasurement?.measurements ?? {};

    final doubleValues = Map<String, double>.fromEntries(
      values.entries
        .where((entry) => entry.value is num)
        .map((entry) => MapEntry(entry.key, (entry.value as num).toDouble()))
    );

    final waist = values['waist'];
    final hips = values['hips'];
    final chest = values['chest'];
    final shirtLength = values['shirtLength'];
    final sleevesLength = values['sleevesLength'];
    final shoulder = values['shoulder'];
    final inseam = values['inseam'];
    final outerLeg = values['outerLeg'];

    // 1. Body Proportion Validation
    if (waist != null && hips != null) {
      if (hips < waist) {
        alerts.add(ValidationAlert(
          level: AlertLevel.warning,
          message: 'Hips are smaller than waist.',
          detailedExplanation: 'This is an uncommon body proportion. While possible, it often indicates a measurement error.',
          correctiveAction: 'Please double-check the hip and waist measurements. Ensure the tape is level and at the correct anatomical location.',
          guideLink: '/guides/how-to-measure-hips-waist',
        ));
      }
    }

    if (chest != null && waist != null) {
      if (waist > chest * 1.1) {
        alerts.add(ValidationAlert(
          level: AlertLevel.warning,
          message: 'Waist is significantly larger than chest.',
          detailedExplanation: 'A waist measurement that is much larger than the chest can affect the drape and fit of the garment.',
          correctiveAction: 'Confirm the accuracy of both chest and waist measurements.',
        ));
      }
    }

    if (chest != null && hips != null) {
        if (hips > chest * 1.5) {
            alerts.add(ValidationAlert(
                level: AlertLevel.warning,
                message: 'Hips are disproportionately large compared to chest.',
                detailedExplanation: 'This ratio may require special garment construction. Please verify for accuracy.',
                correctiveAction: 'Please double-check the hip and chest measurements.',
            ));
        }
    }

    if (shirtLength != null && sleevesLength != null && sleevesLength > shirtLength) {
      alerts.add(ValidationAlert(
        level: AlertLevel.warning,
        message: 'Sleeve length is greater than shirt length.',
        detailedExplanation: 'This is highly unusual and likely indicates a measurement error.',
        correctiveAction: 'Ensure both are measured correctly from the proper reference points.',
      ));
    }

    if (inseam != null && outerLeg != null && inseam > outerLeg) {
      alerts.add(ValidationAlert(
        level: AlertLevel.critical,
        message: 'Inseam is longer than outer leg.',
        detailedExplanation: 'This is physically impossible and will result in an incorrectly made garment.',
        correctiveAction: 'Please re-measure the inseam and outer leg. The outer leg should always be longer.',
        guideLink: '/guides/how-to-measure-legs',
      ));
    }

    if (shoulder != null && chest != null && shoulder > chest) {
      alerts.add(ValidationAlert(
        level: AlertLevel.warning,
        message: 'Shoulder width is greater than chest circumference.',
        detailedExplanation: 'This is a very rare body proportion. It could indicate an error in measuring the shoulder width or chest.',
        correctiveAction: 'Please confirm both measurements. Shoulder is a point-to-point measure, while chest is a circumference.',
      ));
    }

    // 2. Service-Specific Validation
    if (service != null) {
      // Example: Rules for a suit
      if (service.name?.toLowerCase().contains('suit') ?? false) {
        if (values['jacketLength'] == null || values['trouserWaist'] == null) {
          alerts.add(ValidationAlert(
            level: AlertLevel.critical,
            message: 'Jacket length and trouser waist are essential for a suit.',
            correctiveAction: 'Please provide these measurements.',
          ));
        }
      }

      // Example: Rules for a shirt
      if (service.name?.toLowerCase().contains('shirt') ?? false) {
        if (values['collarSize'] == null || values['cuffSize'] == null) {
          alerts.add(ValidationAlert(
            level: AlertLevel.warning,
            message: 'Collar and cuff sizes are required for a good shirt fit.',
            correctiveAction: 'Please provide these measurements.',
          ));
        }
      }

      // Example: Rules for trousers
      if (service.name?.toLowerCase().contains('trouser') ?? false) {
        if (values['thigh'] == null || values['knee'] == null) {
          alerts.add(ValidationAlert(
            level: AlertLevel.info,
            message: 'Thigh and knee measurements are important for trouser comfort and style.',
            correctiveAction: 'Consider providing these measurements for a better fit.',
          ));
        }
      }
    }

    // 3. Statistical Anomaly Detection
    values.forEach((key, value) {
      if (value != previousValues[key]) {
        if (value <= 0) {
          alerts.add(ValidationAlert(
            level: AlertLevel.critical,
            message: 'Measurement for $key cannot be zero or negative.',
            correctiveAction: 'Please check the input for $key.',
          ));
        }

        // Check against standard sizes
        final standard =
            SizeStandards.standardSizes[service?.name?.toLowerCase()] ??
                SizeStandards.standardSizes['shirt']!; // Default to shirt
        if (standard['${key}_min'] != null && value < standard['${key}_min']!) {
          alerts.add(ValidationAlert(
            level: AlertLevel.warning,
            message: '$key measurement is unusually small.',
            correctiveAction: 'Please verify the measurement for $key.',
          ));
        }
        if (standard['${key}_max'] != null && value > standard['${key}_max']!) {
          alerts.add(ValidationAlert(
            level: AlertLevel.warning,
            message: '$key measurement is unusually large.',
            correctiveAction: 'Please verify the measurement for $key.',
          ));
        }
      }
    });

    // 4. Practical Tailoring Checks (Ease and Comfort)
    if (chest != null) {
      final ease = SizeStandards.easeAllowances['shirt_chest'] ?? 2.0;
      if (values['finishedChest'] != null &&
          values['finishedChest'] < chest + ease) {
        alerts.add(ValidationAlert(
          level: AlertLevel.warning,
          message: 'Finished chest does not allow for adequate movement.',
          detailedExplanation: 'The finished garment measurement should be larger than the body measurement to allow for comfort and movement. This is called "ease".',
          correctiveAction: 'Consider adding at least $ease inches of ease to the finished chest measurement.',
        ));
      }
    }

    // Validate garment style and fabric
    _validateFabricAndStyle(doubleValues, alerts);

    // Check for swapped values
    _checkSwappedValues(doubleValues, alerts);

    // Check for potential unit confusion (inches vs. cm)
    _checkForUnitConfusion(doubleValues, alerts);

    // Find common measurement mistake patterns
    if (previousMeasurement != null) {
      _findMeasurementPatterns(doubleValues, previousValues, alerts);
    }

    // 5. Historical Consistency Check
    if (previousMeasurement != null) {
      values.forEach((key, value) {
        if (previousValues.containsKey(key) &&
            previousValues[key] is num &&
            value is num) {
          final oldValue = previousValues[key] as num;
          final newValue = value;
          final difference = (newValue - oldValue).abs();

          const double significantChangeThreshold = 2.0; // e.g., 2 inches

          if (difference > significantChangeThreshold) {
            alerts.add(ValidationAlert(
              level: AlertLevel.warning,
              message: 'Significant change detected for $key.',
              detailedExplanation:
                  'The measurement for $key has changed from $oldValue to $newValue, a difference of ${difference.toStringAsFixed(1)} inches. Please verify.',
              correctiveAction: 'Confirm the new measurement for $key is correct.',
            ));
          }
        }
      });
    }

    if (alerts.isEmpty) {
      alerts.add(ValidationAlert(
        level: AlertLevel.success,
        message: 'All measurements seem well-proportioned and consistent.',
      ));
    }

    return alerts;
  }

  static void _validateFabricAndStyle(
      Map<String, double> values, List<ValidationAlert> alerts) {
    final fabricType = values['fabric_type']; // e.g., 1.0 for non-stretch, 2.0 for stretch
    final chest = values['chest'];
    final finishedChest = values['finishedChest'];

    // Fabric-based validation
    if (fabricType == 1.0 /* Non-Stretch */ && chest != null && finishedChest != null) {
      final ease = finishedChest - chest;
      if (ease < 2.0) {
        alerts.add(ValidationAlert(
          level: AlertLevel.warning,
          message: 'Low ease allowance for non-stretch fabric.',
          detailedExplanation: 'Non-stretch fabrics require more ease for comfort and movement. An ease of less than 2 inches on the chest can feel very restrictive.',
          correctiveAction: 'Consider increasing the finished chest measurement or selecting a fabric with some stretch.',
        ));
      }
    }

    // Garment style validation
    _validateGarmentStyle(values, alerts);
  }

  static void _validateGarmentStyle(
      Map<String, double> values, List<ValidationAlert> alerts) {
    final style = values['style']; // e.g., 1.0 for Slim, 2.0 for Regular, 3.0 for Relaxed
    if (style == null) return;

    final chest = values['chest'];
    final waist = values['waist'];

    if (chest != null && waist != null) {
      final difference = chest - waist;
      if (style == 1.0 /* Slim Fit */ && difference < 4) {
        alerts.add(ValidationAlert(
          level: AlertLevel.info,
          message: 'For a slim fit, the waist should be smaller than the chest.',
          correctiveAction: 'Please verify chest and waist measurements for a proper slim fit.',
        ));
      } else if (style == 2.0 /* Regular Fit */ &&
          (difference < 2 || difference > 6)) {
        alerts.add(ValidationAlert(
          level: AlertLevel.info,
          message: 'Measurements may not be ideal for a regular fit.',
          correctiveAction: 'Check chest and waist difference for a standard regular fit.',
        ));
      } else if (style == 3.0 /* Relaxed Fit */ && difference < 0) {
        alerts.add(ValidationAlert(
          level: AlertLevel.warning,
          message: 'For a relaxed fit, chest should be larger than waist.',
          correctiveAction: 'Please confirm measurements.',
        ));
      }
    }
  }

  static void _checkSwappedValues(
      Map<String, double> values, List<ValidationAlert> alerts) {
    final chest = values['chest'];
    final waist = values['waist'];
    final hips = values['hips'];

    if (chest != null && waist != null && chest < waist) {
      alerts.add(ValidationAlert(
        level: AlertLevel.warning,
        message: 'Chest is smaller than waist.',
        detailedExplanation: 'This might indicate that the chest and waist measurements were accidentally swapped.',
        correctiveAction: 'Please verify that the chest measurement was taken at the fullest part of the chest and the waist at the natural waistline.',
      ));
    }

    if (waist != null && hips != null && waist > hips) {
      alerts.add(ValidationAlert(
        level: AlertLevel.warning,
        message: 'Waist is larger than hips.',
        detailedExplanation: 'This could indicate that the waist and hip measurements were swapped.',
        correctiveAction: 'Please double-check the measurements. The hip measurement should be taken at the widest part of the hips.',
      ));
    }
  }

  static void _checkForUnitConfusion(
      Map<String, double> values, List<ValidationAlert> alerts) {
    // This map holds typical ranges for measurements in inches.
    const inchRanges = {
      'chest': {'min': 30.0, 'max': 60.0},
      'waist': {'min': 24.0, 'max': 55.0},
      'hips': {'min': 30.0, 'max': 60.0},
      'shirtLength': {'min': 25.0, 'max': 40.0},
      'sleevesLength': {'min': 20.0, 'max': 38.0},
      'shoulder': {'min': 14.0, 'max': 25.0},
    };

    values.forEach((key, value) {
      if (inchRanges.containsKey(key)) {
        final range = inchRanges[key]!;

        // Check if the value is outside the typical inch range but would be reasonable in cm
        if (value > range['max']! && (value >= range['min']! * 2.54 && value <= range['max']! * 2.54)) {
          alerts.add(ValidationAlert(
            level: AlertLevel.warning,
            message: 'Possible unit confusion for $key.',
            detailedExplanation: 'The value $value for $key seems high for inches, but would be a reasonable value in centimeters. The system expects measurements in inches.',
            correctiveAction: 'Please confirm that the measurement was entered in inches. If it was in centimeters, please convert it to inches before submitting.',
          ));
        }
      }
    });
  }

  static void _findMeasurementPatterns(Map<String, double> currentValues,
      Map<String, dynamic> previousValues, List<ValidationAlert> alerts) {
    final diffs = <String, double>{};
    currentValues.forEach((key, value) {
      if (previousValues.containsKey(key) && previousValues[key] is num) {
        diffs[key] = value - (previousValues[key] as num);
      }
    });

    if (diffs.isEmpty) return;

    // Pattern 1: Consistent offset in a group of measurements
    _checkConsistentOffset(
        diffs,
        ['chest', 'waist', 'hips'],
        'upper body circumferences',
        alerts);
    _checkConsistentOffset(
        diffs,
        ['inseam', 'outerLeg', 'thigh', 'knee'],
        'leg measurements',
        alerts);

    // Pattern 2: All measurements are larger/smaller
    final allPositive = diffs.values.every((d) => d > 0);
    final allNegative = diffs.values.every((d) => d < 0);
    if (diffs.length > 3) {
      if (allPositive) {
        alerts.add(ValidationAlert(
          level: AlertLevel.info,
          message: 'All measurements have increased.',
          detailedExplanation: 'This could be intentional, but it\'s worth confirming that all measurements were retaken accurately.',
        ));
      } else if (allNegative) {
        alerts.add(ValidationAlert(
          level: AlertLevel.info,
          message: 'All measurements have decreased.',
          detailedExplanation: 'This could be intentional, but it\'s worth confirming that all measurements were retaken accurately.',
        ));
      }
    }
  }

  static void _checkConsistentOffset(
      Map<String, double> diffs,
      List<String> keys,
      String groupName,
      List<ValidationAlert> alerts) {
    final groupDiffs =
        keys.where((k) => diffs.containsKey(k)).map((k) => diffs[k]!).toList();
    if (groupDiffs.length < 2) return;

    final averageDiff =
        groupDiffs.reduce((a, b) => a + b) / groupDiffs.length;
    if (averageDiff.abs() < 0.1) return; // Ignore negligible differences

    final isConsistent =
        groupDiffs.every((d) => (d - averageDiff).abs() < 0.5); // 0.5 inch tolerance

    if (isConsistent) {
      alerts.add(ValidationAlert(
        level: AlertLevel.info,
        message: 'Consistent change detected in $groupName.',
        detailedExplanation: 'The measurements for $groupName have all changed by approximately ${averageDiff.toStringAsFixed(2)} inches. This might indicate a systematic change or a consistent measurement error (e.g., tape position).',
        correctiveAction: 'If this change was not intentional, please review the measurement technique for this group of measurements.',
      ));
    }
  }
}
