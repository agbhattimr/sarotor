// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get myOrders => 'طلباتي';

  @override
  String get searchByTrackingIdOrItem => 'البحث عن طريق معرف التتبع أو العنصر';

  @override
  String get noOrdersFound => 'لم يتم العثور على طلبات';

  @override
  String get tryAdjustingYourSearchOrFilters => 'حاول تعديل البحث أو المرشحات.';

  @override
  String get order => 'طلب';

  @override
  String get total => 'المجموع';

  @override
  String get items => 'العناصر';

  @override
  String get notes => 'ملاحظات';

  @override
  String get orderProgress => 'تقدم الطلب';

  @override
  String get orderCancelled => 'تم إلغاء الطلب';

  @override
  String get thisOrderHasBeenCancelled => 'تم إلغاء هذا الطلب.';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get confirmed => 'تم التأكيد';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get readyForPickup => 'جاهز للاستلام';

  @override
  String get completed => 'مكتمل';

  @override
  String get youAreOffline => 'أنت غير متصل بالإنترنت';

  @override
  String get showingCachedData =>
      'عرض البيانات المخزنة مؤقتًا. اتصل بالإنترنت لرؤية أحدث الطلبات.';

  @override
  String get hideDetails => 'إخفاء التفاصيل';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get duplicateOrder => 'تكرار الطلب';

  @override
  String get shareOrder => 'مشاركة الطلب';

  @override
  String get areYouSureYouWantToCancelThisOrder =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟';

  @override
  String get no => 'لا';

  @override
  String get yes => 'نعم';

  @override
  String get orderSuccessfullyCancelled => 'تم إلغاء الطلب بنجاح.';

  @override
  String get errorCancellingOrder => 'خطأ في إلغاء الطلب:';

  @override
  String get youAreCurrentlyOffline => 'أنت غير متصل حاليا';

  @override
  String get createTestOrder => 'إنشاء طلب تجريبي';

  @override
  String get refreshOrders => 'تحديث الطلبات';

  @override
  String filterByStatus(Object status) {
    return 'تصفية الطلبات حسب الحالة: $status';
  }

  @override
  String get filterByDate => 'تصفية الطلبات حسب نطاق التاريخ';

  @override
  String get pleaseLoginFirst => 'الرجاء تسجيل الدخول أولا';

  @override
  String testOrderCreated(Object trackingId) {
    return 'تم إنشاء طلب تجريبي! معرف التتبع: $trackingId';
  }

  @override
  String errorCreatingOrder(Object error) {
    return 'خطأ في إنشاء الطلب: $error';
  }

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get couldNotLoadOrders =>
      'لم نتمكن من تحميل طلباتك. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String moreOptionsForOrder(Object trackingId) {
    return 'المزيد من الخيارات للطلب #$trackingId';
  }

  @override
  String get areYouSureYouWantToCancelThisOrderUndone =>
      'هل أنت متأكد أنك تريد إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get yesCancel => 'نعم ، إلغاء';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusConfirmed => 'تم التأكيد';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get statusReadyForPickup => 'جاهز للاستلام';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'تم الإلغاء';

  @override
  String orderPlacedOn(Object date) {
    return 'تم تقديم الطلب في $date';
  }

  @override
  String updatedOn(Object date) {
    return 'تم التحديث في $date';
  }
}
