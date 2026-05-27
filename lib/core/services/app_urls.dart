/// ─────────────────────────────────────────────────────────
///  AppUrls — Centralised API endpoint constants
/// ─────────────────────────────────────────────────────────
///  All paths are relative to [Api.baseUrl].
///  Group by feature → alphabetical within each group.
/// ─────────────────────────────────────────────────────────
class AppUrls {
  AppUrls._();

  // ── AUTH ──
  static const String sendOtp = '/api/v1/user/auth/send-otp';
  static const String verifyOtp = '/api/v1/user/auth/verify-otp';
  static const String refreshToken = '/api/v1/user/auth/refresh';
  static const String logout = '/api/v1/user/auth/logout';

  // ── PROFILE ──
  static const String profile = '/api/v1/user/profile';
  static const String updateProfile = '/api/v1/user/profile';
  static const String deleteAccount = '/api/v1/user/profile';
  static const String pushToken = '/api/v1/user/profile/push-token';

  // ── BOOKING ──
  static const String bookingEstimate = '/api/v1/user/bookings/estimate';
  static const String bookingSummary = '/api/v1/user/bookings/summary';
  static const String bookingApplyCoupon = '/api/v1/user/bookings/apply-coupon';
  static const String bookingConfirm = '/api/v1/user/bookings/confirm';
  static const String bookingDetail = '/api/v1/user/bookings';
  static const String bookingCancel = '/api/v1/user/bookings';
  static const String bookingRate = '/api/v1/user/bookings';
  static const String bookingRateSkip = '/api/v1/user/bookings';
  static const String bookingMessages = '/api/v1/user/bookings';
  static const String bookingRoute = '/api/v1/user/bookings';
  static const String bookingPaymentOrder = '/api/v1/user/bookings';
  static const String bookingPaymentVerify = '/api/v1/user/bookings';
  static const String bookingPaymentWallet = '/api/v1/user/bookings';
  static const String bookingsActive = '/api/v1/user/bookings/active';
  static const String cancellationReasons =
      '/api/v1/user/bookings/cancellation-reasons';
  static const String recentDestinations =
      '/api/v1/user/bookings/recent-destinations';
  static const String coupons = '/api/v1/user/coupons';

  // ── ADDRESSES ──
  static const String addresses = '/api/v1/user/addresses';

  // ── FAVOURITE LOCATIONS ──
  static const String favouriteLocations = '/api/v1/user/favourite-locations';

  // ── PAYMENT METHODS ──
  static const String paymentMethods = '/api/v1/user/payment-methods';

  // ── HISTORY ──
  static const String rideHistory = '/api/v1/user/history';
  static const String rideReceipt = '/api/v1/user/history';

  // ── NOTIFICATIONS ──
  static const String notifications = '/api/v1/user/notifications';
  static const String notificationsUnread =
      '/api/v1/user/notifications/unread-count';
  static const String notificationsPrefs =
      '/api/v1/user/notifications/preferences';
  static const String notificationsReadAll =
      '/api/v1/user/notifications/read-all';
  static const String notificationReadOne = '/api/v1/user/notifications';

  // ── COMPLAINTS ──
  static const String complaints = '/api/v1/user/complaints';
  static const String complaintReasons = '/api/v1/user/complaints/reasons';

  // ── CONTACT US ──
  static const String contactUs = '/api/v1/user/contact-us';

  // ── SUPPORT ──
  static const String support = '/api/v1/user/support';

  // ── SOS ──
  static const String sos = '/api/v1/user/sos';
  static const String sosLocation = '/api/v1/user/sos/location';

  // ── TRUSTED CONTACTS ──
  static const String trustedContacts = '/api/v1/user/trusted-contacts';

  // ── WALLET ──
  static const String wallet = '/api/v1/user/wallet';
  static const String walletTopupOrder = '/api/v1/user/wallet/topup/order';
  static const String walletTopupVerify = '/api/v1/user/wallet/topup/verify';

  // ── UPLOAD ──
  static const String presign = '/api/v1/user/upload/presign';
  static const String presignSignupPhoto =
      '/api/v1/user/upload/presign/signup-photo';

  // ── PUBLIC (no auth required) ──
  static const String publicBanners = '/api/v1/user/public/banners';
  static const String publicCities = '/api/v1/user/public/cities';
  static const String publicFaqs = '/api/v1/user/public/faqs';
  static const String publicLocate = '/api/v1/user/public/locate';
  static const String publicAutocomplete =
      '/api/v1/user/public/places/autocomplete';
  static const String publicEnums = '/api/v1/user/public/enums';
  static const String publicStates = '/api/v1/user/public/states';
  static const String publicVehicleTypes = '/api/v1/user/public/vehicle-types';
  static const String aboutUs = '/api/v1/about-us/user';

  // ── MISC ──
  static const String appVersion = '/api/v1/app-version';
  static const String config = '/api/v1/config';
  static const String shareTrip = '/api/v1/share';
  static const String health = '/health';
}
