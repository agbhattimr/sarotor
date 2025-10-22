import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/service.dart';

class PriceUtils {
  static int calculateTotalPrice(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.priceCents);
  }

  static int calculateItemPrice(Service service, Map<String, bool> addOns) {
    int price = service.priceCents;
    // for (var addOn in service.addOns) {
    //   if (addOns[addOn.name] == true) {
    //     price += addOn.priceCents;
    //   }
    // }
    return price;
  }
}
