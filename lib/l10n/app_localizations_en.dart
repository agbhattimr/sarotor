// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myOrders => 'My Orders';

  @override
  String get searchByTrackingIdOrItem => 'Search by Tracking ID or Item';

  @override
  String get noOrdersFound => 'No Orders Found';

  @override
  String get tryAdjustingYourSearchOrFilters =>
      'Try adjusting your search or filters.';

  @override
  String get order => 'Order';

  @override
  String get total => 'Total';

  @override
  String get items => 'Items';

  @override
  String get notes => 'Notes';

  @override
  String get orderProgress => 'Order Progress';

  @override
  String get orderCancelled => 'Order Cancelled';

  @override
  String get thisOrderHasBeenCancelled => 'This order has been cancelled.';

  @override
  String get pending => 'Pending';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get readyForPickup => 'Ready for Pickup';

  @override
  String get completed => 'Completed';

  @override
  String get youAreOffline => 'You are Offline';

  @override
  String get showingCachedData =>
      'Showing cached data. Connect to the internet to see the latest orders.';

  @override
  String get hideDetails => 'Hide Details';

  @override
  String get viewDetails => 'View Details';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get duplicateOrder => 'Duplicate Order';

  @override
  String get shareOrder => 'Share Order';

  @override
  String get areYouSureYouWantToCancelThisOrder =>
      'Are you sure you want to cancel this order?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get orderSuccessfullyCancelled => 'Order successfully cancelled.';

  @override
  String get errorCancellingOrder => 'Error cancelling order:';

  @override
  String get youAreCurrentlyOffline => 'You are currently offline';

  @override
  String get createTestOrder => 'Create Test Order';

  @override
  String get refreshOrders => 'Refresh Orders';

  @override
  String filterByStatus(Object status) {
    return 'Filter orders by status: $status';
  }

  @override
  String get filterByDate => 'Filter orders by date range';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String testOrderCreated(Object trackingId) {
    return 'Test order created! Tracking ID: $trackingId';
  }

  @override
  String errorCreatingOrder(Object error) {
    return 'Error creating order: $error';
  }

  @override
  String get somethingWentWrong => 'Something Went Wrong';

  @override
  String get couldNotLoadOrders =>
      'We couldn\'t load your orders. Please check your connection and try again.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String moreOptionsForOrder(Object trackingId) {
    return 'More options for order #$trackingId';
  }

  @override
  String get areYouSureYouWantToCancelThisOrderUndone =>
      'Are you sure you want to cancel this order? This action cannot be undone.';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusReadyForPickup => 'Ready for Pickup';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String orderPlacedOn(Object date) {
    return 'Order placed on $date';
  }

  @override
  String updatedOn(Object date) {
    return 'Updated on $date';
  }
}
