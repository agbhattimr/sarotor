class SizeStandards {
  static const Map<String, Map<String, double>> standardSizes = {
    'shirt': {
      'chest_min': 34.0,
      'chest_max': 52.0,
      'waist_min': 28.0,
      'waist_max': 46.0,
      'shoulder_min': 15.0,
      'shoulder_max': 22.0,
      'neck_min': 14.0,
      'neck_max': 20.0,
    },
    'trouser': {
      'waist_min': 28.0,
      'waist_max': 46.0,
      'inseam_min': 28.0,
      'inseam_max': 36.0,
    },
  };

  static const Map<String, double> easeAllowances = {
    'shirt_chest': 2.0,
    'shirt_waist': 3.0,
    'trouser_waist': 1.5,
  };
}
