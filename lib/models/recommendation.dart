import 'package:sartor_order_management/models/measurement_template.dart';

class Recommendation {
  final MeasurementTemplate template;
  final double score;

  Recommendation({required this.template, required this.score});
}
