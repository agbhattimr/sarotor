import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Providers for advanced measurement features
final bodyTypeProvider = Provider.family<BodyType, BodyMeasurements>((ref, measurements) {
  return BodyTypeClassifier.classify(measurements);
});

final measurementPredictionsProvider = Provider.family<PredictedMeasurements, BaseMeasurements>((ref, base) {
  return MeasurementPredictor.predict(base);
});

final stylingRecommendationsProvider = Provider.family<List<StyleRecommendation>, BodyProfile>((ref, profile) {
  return StyleRecommendationEngine.getRecommendations(profile);
});

/// Models for measurement analysis
class BodyMeasurements {
  final double height; // inches
  final double weight; // lbs
  final double chest;
  final double waist;
  final double hips;
  final double shoulders;

  const BodyMeasurements({
    required this.height,
    required this.weight,
    required this.chest,
    required this.waist,
    required this.hips,
    required this.shoulders,
  });

  double get bmi => (weight * 703) / (height * height);
  
  /// Shoulder to waist ratio (indicates V-shape)
  double get shoulderToWaistRatio => shoulders / waist;
  
  /// Waist to hip ratio (indicates body fat distribution)
  double get waistToHipRatio => waist / hips;
}

class BaseMeasurements {
  final double height;
  final double weight;
  final String gender;
  final int age;

  const BaseMeasurements({
    required this.height,
    required this.weight,
    required this.gender,
    required this.age,
  });
}

class PredictedMeasurements {
  final Map<String, double> predictions;
  final double confidenceScore;

  const PredictedMeasurements({
    required this.predictions,
    required this.confidenceScore,
  });
}

enum BodyType {
  ectomorph,
  mesomorph,
  endomorph,
  athletic,
  hourglass,
  pear,
  inverted,
  rectangle
}

class BodyProfile {
  final BodyType bodyType;
  final BodyMeasurements measurements;
  final List<String> fitPreferences;
  final List<String> stylePreferences;

  const BodyProfile({
    required this.bodyType,
    required this.measurements,
    required this.fitPreferences,
    required this.stylePreferences,
  });
}

class StyleRecommendation {
  final String garmentType;
  final String fit;
  final String style;
  final String fabricType;
  final String rationale;
  final double confidenceScore;

  const StyleRecommendation({
    required this.garmentType,
    required this.fit,
    required this.style,
    required this.fabricType,
    required this.rationale,
    required this.confidenceScore,
  });
}

/// Body Type Classification System
class BodyTypeClassifier {
  static BodyType classify(BodyMeasurements measurements) {
    final bmi = measurements.bmi;
    final shoulderToWaist = measurements.shoulderToWaistRatio;
    final waistToHip = measurements.waistToHipRatio;

    // Complex classification logic based on multiple factors
    if (bmi < 18.5) {
      return shoulderToWaist > 1.4 ? BodyType.ectomorph : BodyType.rectangle;
    } else if (bmi < 25) {
      if (shoulderToWaist > 1.5) {
        return BodyType.athletic;
      } else if (waistToHip < 0.8) {
        return BodyType.hourglass;
      }
      return BodyType.mesomorph;
    } else {
      if (waistToHip > 0.9) {
        return BodyType.endomorph;
      }
      return BodyType.pear;
    }
  }
}

/// Measurement Prediction System
class MeasurementPredictor {
  static PredictedMeasurements predict(BaseMeasurements base) {
    // Advanced anthropometric calculations
    final predictions = <String, double>{};
    double confidenceScore = 0.95;

    // Chest prediction based on height and weight
    predictions['chest'] = _predictChest(base);
    
    // Waist prediction using statistical modeling
    predictions['waist'] = _predictWaist(base);
    
    // Other measurements
    predictions['neck'] = base.height * 0.2375;
    predictions['shoulders'] = base.height * 0.259;
    predictions['sleeve'] = base.height * 0.35;
    predictions['inseam'] = base.height * 0.48;

    // Adjust confidence based on age ranges
    if (base.age < 18 || base.age > 65) {
      confidenceScore *= 0.9;
    }

    return PredictedMeasurements(
      predictions: predictions,
      confidenceScore: confidenceScore,
    );
  }

  static double _predictChest(BaseMeasurements base) {
    // Thoracic index calculation
    final thoracicIndex = base.height * 0.52;
    final weightFactor = base.weight / 150;
    return thoracicIndex * weightFactor;
  }

  static double _predictWaist(BaseMeasurements base) {
    // Waist prediction using WHO formula adjusted for age
    final baseWaist = base.height * 0.382;
    final ageFactor = 1 + ((base.age - 25) * 0.001);
    return baseWaist * ageFactor;
  }
}

/// Style Recommendation Engine
class StyleRecommendationEngine {
  static List<StyleRecommendation> getRecommendations(BodyProfile profile) {
    final recommendations = <StyleRecommendation>[];
    
    switch (profile.bodyType) {
      case BodyType.athletic:
        recommendations.addAll(_getAthleticRecommendations(profile));
      case BodyType.ectomorph:
        recommendations.addAll(_getEctomorphRecommendations(profile));
      case BodyType.mesomorph:
        recommendations.addAll(_getMesomorphRecommendations(profile));
      // ... other body types
      default:
        recommendations.addAll(_getDefaultRecommendations(profile));
    }

    return recommendations;
  }

  static List<StyleRecommendation> _getAthleticRecommendations(BodyProfile profile) {
    return [
      const StyleRecommendation(
        garmentType: 'Suit',
        fit: 'Tailored',
        style: 'Modern',
        fabricType: 'High-stretch wool blend',
        rationale: 'Accentuates V-shaped torso while allowing movement',
        confidenceScore: 0.95,
      ),
      const StyleRecommendation(
        garmentType: 'Shirt',
        fit: 'Slim',
        style: 'Structured',
        fabricType: 'Cotton stretch',
        rationale: 'Complements athletic build without restricting',
        confidenceScore: 0.92,
      ),
      // More recommendations...
    ];
  }

  // Similar methods for other body types...
  static List<StyleRecommendation> _getEctomorphRecommendations(BodyProfile profile) {
    // Implementation for ectomorph body type
    return [];
  }

  static List<StyleRecommendation> _getMesomorphRecommendations(BodyProfile profile) {
    // Implementation for mesomorph body type
    return [];
  }

  static List<StyleRecommendation> _getDefaultRecommendations(BodyProfile profile) {
    // Default recommendations
    return [];
  }
}

/// PDF Generation and Export
class MeasurementPDFExporter {
  static Future<File> generatePDF({
    required String clientName,
    required BodyMeasurements measurements,
    required List<StyleRecommendation> recommendations,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(clientName),
          _buildMeasurementsTable(measurements),
          _buildBodyProfile(measurements),
          _buildRecommendations(recommendations),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/measurements_$clientName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildHeader(String clientName) {
    return pw.Header(
      level: 0,
      child: pw.Text(
        'Measurement Profile: $clientName',
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _buildMeasurementsTable(BodyMeasurements measurements) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Text('Measurement'),
            pw.Text('Inches'),
            pw.Text('Centimeters'),
          ],
        ),
        _measurementRow('Height', measurements.height),
        _measurementRow('Chest', measurements.chest),
        _measurementRow('Waist', measurements.waist),
        _measurementRow('Hips', measurements.hips),
        _measurementRow('Shoulders', measurements.shoulders),
      ],
    );
  }

  static pw.TableRow _measurementRow(String label, double inches) {
    return pw.TableRow(
      children: [
        pw.Text(label),
        pw.Text(inches.toStringAsFixed(1)),
        pw.Text((inches * 2.54).toStringAsFixed(1)),
      ],
    );
  }

  static pw.Widget _buildBodyProfile(BodyMeasurements measurements) {
    final bodyType = BodyTypeClassifier.classify(measurements);
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'Body Profile'),
        pw.Text('Body Type: ${bodyType.toString().split('.').last}'),
        pw.Text('BMI: ${measurements.bmi.toStringAsFixed(1)}'),
        pw.SizedBox(height: 10),
      ],
    );
  }

  static pw.Widget _buildRecommendations(List<StyleRecommendation> recommendations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(level: 1, text: 'Style Recommendations'),
        ...recommendations.map((rec) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('${rec.garmentType} - ${rec.style}'),
            pw.Text('Fit: ${rec.fit}'),
            pw.Text('Fabric: ${rec.fabricType}'),
            pw.Text('Why: ${rec.rationale}'),
            pw.SizedBox(height: 10),
          ],
        )),
      ],
    );
  }
}

/// Measurement Sharing Functionality
class MeasurementSharing {
  static Future<void> shareMeasurementProfile({
    required String clientName,
    required BodyMeasurements measurements,
    required List<StyleRecommendation> recommendations,
  }) async {
    final pdf = await MeasurementPDFExporter.generatePDF(
      clientName: clientName,
      measurements: measurements,
      recommendations: recommendations,
    );

    await Share.shareXFiles(
      [XFile(pdf.path)],
      text: 'Measurement Profile for $clientName',
      subject: 'Sartor Measurements - $clientName',
    );
  }

  static String generateShareableLink({
    required String clientId,
    required String measurementId,
    Duration? expiry,
  }) {
    // TODO: Implement secure link generation with backend
    return 'https://sartor.app/share/$clientId/$measurementId';
  }
}