import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @searchByTrackingIdOrItem.
  ///
  /// In en, this message translates to:
  /// **'Search by Tracking ID or Item'**
  String get searchByTrackingIdOrItem;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No Orders Found'**
  String get noOrdersFound;

  /// No description provided for @tryAdjustingYourSearchOrFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters.'**
  String get tryAdjustingYourSearchOrFilters;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @orderProgress.
  ///
  /// In en, this message translates to:
  /// **'Order Progress'**
  String get orderProgress;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get orderCancelled;

  /// No description provided for @thisOrderHasBeenCancelled.
  ///
  /// In en, this message translates to:
  /// **'This order has been cancelled.'**
  String get thisOrderHasBeenCancelled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @readyForPickup.
  ///
  /// In en, this message translates to:
  /// **'Ready for Pickup'**
  String get readyForPickup;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are Offline'**
  String get youAreOffline;

  /// No description provided for @showingCachedData.
  ///
  /// In en, this message translates to:
  /// **'Showing cached data. Connect to the internet to see the latest orders.'**
  String get showingCachedData;

  /// No description provided for @hideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hideDetails;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @duplicateOrder.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Order'**
  String get duplicateOrder;

  /// No description provided for @shareOrder.
  ///
  /// In en, this message translates to:
  /// **'Share Order'**
  String get shareOrder;

  /// No description provided for @areYouSureYouWantToCancelThisOrder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get areYouSureYouWantToCancelThisOrder;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @orderSuccessfullyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order successfully cancelled.'**
  String get orderSuccessfullyCancelled;

  /// No description provided for @errorCancellingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error cancelling order:'**
  String get errorCancellingOrder;

  /// No description provided for @youAreCurrentlyOffline.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline'**
  String get youAreCurrentlyOffline;

  /// No description provided for @createTestOrder.
  ///
  /// In en, this message translates to:
  /// **'Create Test Order'**
  String get createTestOrder;

  /// No description provided for @refreshOrders.
  ///
  /// In en, this message translates to:
  /// **'Refresh Orders'**
  String get refreshOrders;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter orders by status: {status}'**
  String filterByStatus(Object status);

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter orders by date range'**
  String get filterByDate;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @testOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Test order created! Tracking ID: {trackingId}'**
  String testOrderCreated(Object trackingId);

  /// No description provided for @errorCreatingOrder.
  ///
  /// In en, this message translates to:
  /// **'Error creating order: {error}'**
  String errorCreatingOrder(Object error);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @couldNotLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your orders. Please check your connection and try again.'**
  String get couldNotLoadOrders;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @moreOptionsForOrder.
  ///
  /// In en, this message translates to:
  /// **'More options for order #{trackingId}'**
  String moreOptionsForOrder(Object trackingId);

  /// No description provided for @areYouSureYouWantToCancelThisOrderUndone.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order? This action cannot be undone.'**
  String get areYouSureYouWantToCancelThisOrderUndone;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusReadyForPickup.
  ///
  /// In en, this message translates to:
  /// **'Ready for Pickup'**
  String get statusReadyForPickup;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @orderPlacedOn.
  ///
  /// In en, this message translates to:
  /// **'Order placed on {date}'**
  String orderPlacedOn(Object date);

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated on {date}'**
  String updatedOn(Object date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
