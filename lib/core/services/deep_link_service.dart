import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../Utils/navigations.dart';
import '../Utils/secure_storage_helper.dart';
import '../main.dart' show navigatorKey;
import '../screens/booking/active_ride_screen.dart';
import '../screens/booking/chat_with_driver_screen.dart';
import '../screens/booking/ride_completed_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/wallet/wallet_screen.dart';

/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// DeepLinkService â€” cold-start + live deep link routing.
///   femirides://<type>[/<id>]   and   https://femirides.app/<type>[/<id>]
/// Also called by PushNotificationService with FCM `data` payload.
///
/// Backend notification `type` values:
///   driver_found       â†’ ActiveRideScreen   (driver matched)
///   driver_arrived     â†’ ActiveRideScreen   (driver on-site)
///   ride_started       â†’ ActiveRideScreen   (trip in progress)
///   ride_completed     â†’ RideCompletedScreen
///   payment_confirmed  â†’ WalletScreen
///   ride_cancelled     â†’ HomeScreen
///   no_drivers         â†’ HomeScreen
///   promo_offer        â†’ NotificationsScreen
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  bool _initialised = false;

  /// Pending route captured before the navigator is mounted or
  /// before the user has logged in. Replayed by [flush].
  _PendingRoute? _pending;

  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    // Cold-start link â€” note: app_links 6.x exposes `getInitialLink()`,
    // not the older `getInitialAppLink()`.
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) _handleUri(initial);
    } catch (e) {
      debugPrint('âŒ deep-link initial error: $e');
    }

    _sub = _appLinks.uriLinkStream.listen(_handleUri, onError: (e) {
      debugPrint('âŒ deep-link stream error: $e');
    });
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }

  /// Called by PushNotificationService on notification tap.
  void handleNotificationPayload(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? '';
    final bookingId = int.tryParse(data['booking_id']?.toString() ?? '');
    if (type.isEmpty) return;

    // FAST PATH for chat â€” skip the async token check + post-frame gates so
    // the chat screen opens within the same frame the user tapped the
    // notification. Mirrors the driver app's NotificationService._routeToChat.
    if (type == 'chat' || type == 'chat_message') {
      _fastRouteToChat();
      return;
    }
    _route(type: type, bookingId: bookingId);
  }

  /// Synchronous chat push â€” no awaits, no post-frame, no intermediate
  /// ActiveRideScreen. The chat screen reads its booking id from
  /// BookingController.activeBookingId which is already hydrated whenever
  /// a chat push could arrive (we only have chat with an active driver).
  void _fastRouteToChat() {
    debugPrint('ðŸ”— DeepLink fastRouteToChat');
    if (ChatWithDriverScreen.isOpen) {
      debugPrint('ðŸ”— DeepLink chat: already open â€” skipping');
      return;
    }
    final nav = navigatorKey.currentState;
    if (nav == null) {
      debugPrint('ðŸ”— DeepLink chat: navigator not mounted, queueing');
      _pending = _PendingRoute(type: 'chat_message');
      return;
    }
    NavigateTo().nextPage(
      child: const ChatWithDriverScreen(),
      settings: const RouteSettings(name: 'chat_with_driver'),
    );
  }

  /// Call after successful login so any link queued while the user
  /// was on the auth stack is now honoured.
  Future<void> flush() async {
    final p = _pending;
    if (p == null) return;
    _pending = null;
    _route(type: p.type, bookingId: p.bookingId);
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Internals
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _handleUri(Uri uri) {
    debugPrint('ðŸ”— Deep link: $uri');
    final segments = uri.pathSegments.isNotEmpty
        ? uri.pathSegments
        : (uri.host.isNotEmpty ? [uri.host] : const <String>[]);
    if (segments.isEmpty) return;

    final type = segments.first;
    final bookingId = segments.length > 1 ? int.tryParse(segments[1]) : null;
    _route(type: type, bookingId: bookingId);
  }

  Future<void> _route({required String type, int? bookingId}) async {
    debugPrint('ðŸ”— DeepLink _route: type=$type bookingId=$bookingId');
    // â”€â”€ Gate 1: user must be logged in, otherwise queue. â”€â”€
    final token = await SecureStorageHelper.instance.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('ðŸ”— Deep link queued (not logged in): $type');
      _pending = _PendingRoute(type: type, bookingId: bookingId);
      return;
    }

    // â”€â”€ Gate 2: navigator must be mounted. â”€â”€
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentState == null) {
        debugPrint('ðŸ”— DeepLink: navigator not mounted, queueing $type');
        _pending = _PendingRoute(type: type, bookingId: bookingId);
        return;
      }
      debugPrint('ðŸ”— DeepLink _push: $type');
      _push(type);
    });
  }

  void _push(String type) {
    switch (type) {
      // â”€â”€ Active ride states â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      case 'driver_found':
      case 'driver_arrived':
      case 'ride_started':
      // Legacy deep-link aliases kept for backwards compat
      case 'booking':
        NavigateTo().nextPage(child: const ActiveRideScreen());
        break;

      // â”€â”€ Chat â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      // Handled by the fast path in handleNotificationPayload â€”
      // this branch only runs if a non-FCM deep-link delivers chat
      // (e.g. universal link). Push chat directly.
      case 'chat':
      case 'chat_message':
        _fastRouteToChat();
        break;

      // â”€â”€ Ride completed â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      case 'ride_completed':
      case 'ride_complete': // legacy alias
        NavigateTo().nextPage(child: const RideCompletedScreen());
        break;

      // â”€â”€ Payment â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      case 'payment_confirmed':
      case 'payment':
        NavigateTo().nextPage(child: const WalletScreen());
        break;

      // â”€â”€ Terminal / informational states â†’ go home â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      case 'ride_cancelled':
      case 'no_drivers':
        NavigateTo().pushRemove(child: const DashboardScreen());
        break;

      // â”€â”€ Promotions â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
      case 'promo_offer':
      case 'notifications':
        NavigateTo().nextPage(child: const NotificationsScreen());
        break;

      default:
        debugPrint('ðŸ”— Unhandled deep-link type: $type');
    }
  }
}

class _PendingRoute {
  final String type;
  final int? bookingId;
  _PendingRoute({required this.type, this.bookingId});
}

