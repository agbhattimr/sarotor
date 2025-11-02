enum ServiceCategory {
  womensWear,
  mensWear,
  extras,
  urgentDelivery,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.womensWear:
        return "Women's Wear";
      case ServiceCategory.mensWear:
        return "Men's Wear";
      case ServiceCategory.extras:
        return "Extras";
      case ServiceCategory.urgentDelivery:
        return "Urgent Delivery";
    }
  }
}
