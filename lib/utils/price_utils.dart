import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/service.dart';

class PriceUtils {
  static double calculateTotalPrice(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.lineTotal);
  }

  static double calculateItemPrice(Service service, Map<String, bool> addOns) {
    double price = service.price;
    // for (var addOn in service.addOns) {
    //   if (addOns[addOn.name] == true) {
    //     price += addOn.price;
    //   }
    // }
    return price;
  }
}
