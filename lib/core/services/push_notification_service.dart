import 'dart:convert';

import 'package:faneasy/core/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_urls.dart';
import 'api_environment.dart';
import 'deep_link_service.dart';
import '../Utils/secure_storage_helper.dart';
import '../screens/booking/chat_with_driver_screen.dart';

/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
/// PushNotificationService
///   â€¢ Initialises Firebase + FCM.
///   â€¢ Requests permission (Android 13+/iOS).
///   â€¢ Registers the device FCM token with the FemiRides
///     backend via PUT /api/v1/user/profile/push-token.
///   â€¢ Shows foreground notifications via flutter_local_notifications.
///   â€¢ Handles message taps (foreground, background, terminated)
///     and forwards the payload to DeepLinkService.
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  final ApiService _api = ApiService();

  static const _androidChannelId = 'femirides_default';
  static const _androidChannelName = 'FemiRides Notifications';
  static const _androidChannelDesc = 'Ride, payment and support alerts';

  bool _initialised = false;
  String? _token;

  String? get token => _token;

  /// Returns the current token or fetches a fresh one if null.
  Future<String?> fetchToken() async {
    if (_token != null && _token!.isNotEmpty) return _token;
    try {
      _token = await FirebaseMessaging.instance.getToken();
      if (_token != null) {
        await SecureStorageHelper.instance.saveFcmToken(_token!);
      }
    } catch (e) {
      debugPrint('âŒ fetchToken error: $e');
    }
    return _token;
  }


  /// Call once from main() after WidgetsFlutterBinding.ensureInitialized().
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    try {
      debugPrint('ðŸ”” PushNotificationService: Starting init...');
      await Firebase.initializeApp();
      debugPrint('ðŸ”” PushNotificationService: Firebase initialized');

      // iOS + Android 13+ permission
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('ðŸ”” FCM permission: ${settings.authorizationStatus}');

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _setupLocalNotifications();
      debugPrint('ðŸ”” PushNotificationService: Local notifications ready');

      // Foreground messages â†’ render with local notifications
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);

      // Message tap when app in background
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

      // Message that launched the app from terminated state
      final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMsg != null) _onMessageOpened(initialMsg);

      // Token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
        _token = t;
        debugPrint('ðŸ”” FCM token refreshed: $t');
        await SecureStorageHelper.instance.saveFcmToken(t);
        registerToken();
      });

      // Cache current token
      debugPrint('ðŸ”” PushNotificationService: Fetching token...');
      _token = await FirebaseMessaging.instance.getToken();
      if (_token != null) {
        debugPrint('ðŸ”” FCM token: $_token');
        await SecureStorageHelper.instance.saveFcmToken(_token!);
      } else {
        debugPrint('âš ï¸ PushNotificationService: getToken() returned NULL');
      }
      debugPrint('ðŸ”” PushNotificationService init complete');
    } catch (e, stack) {
      debugPrint('âŒ PushNotificationService init FAILED: $e');
      debugPrint(stack.toString());
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final data = jsonDecode(payload) as Map<String, dynamic>;
            DeepLinkService.instance.handleNotificationPayload(data);
          } catch (_) {}
        }
      },
    );

    // Android 8+ channel
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _androidChannelId,
          _androidChannelName,
          description: _androidChannelDesc,
          importance: Importance.high,
        ));
  }

  void _onForegroundMessage(RemoteMessage msg) {
    final n = msg.notification;
    // Fall back to data-only payloads (server may send title/body inside data)
    final title = n?.title ?? msg.data['title']?.toString();
    final body = n?.body ?? msg.data['body']?.toString();

    debugPrint('ðŸ”” FCM Foreground Message: ${msg.messageId}');
    debugPrint('   Title: $title');
    debugPrint('   Body:  $body');
    debugPrint('   Data:  ${msg.data}');

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    // Enrich empty data payload by inferring the type from the title
    final payload = enrichFcmPayload(msg.data, title, body);

    // If the user is already inside the chat screen and this is a chat
    // push, the chat list is already live-updating via socket â€” don't
    // surface a redundant heads-up notification on top of the open chat.
    if (payload['type'] == 'chat_message' && ChatWithDriverScreen.isOpen) {
      debugPrint(
          'ðŸ”” Foreground chat push suppressed â€” chat screen already open');
      return;
    }

    _local.show(
      id: msg.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: _androidChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(payload),
    );
  }

  void _onMessageOpened(RemoteMessage msg) {
    final n = msg.notification;
    debugPrint('ðŸ”” FCM Notification Tapped: ${msg.messageId}');
    debugPrint('   Title: ${n?.title}');
    debugPrint('   Body:  ${n?.body}');
    debugPrint('   Data:  ${msg.data}');
    // Enrich before routing in case backend sent empty data
    final payload = enrichFcmPayload(msg.data, n?.title, n?.body);
    DeepLinkService.instance.handleNotificationPayload(payload);
  }

  /// Registers the current FCM token against the logged-in user.
  /// Requires a valid access token in secure storage.
  Future<void> registerToken() async {
    try {
      final access = await SecureStorageHelper.instance.getAccessToken();
      if (access == null || access.isEmpty) return;

      _token ??= await FirebaseMessaging.instance.getToken();
      if (_token == null || _token!.isEmpty) return;

      final url = '${Api.baseUrl}${AppUrls.pushToken}';
      final body = {'token': _token};
      debugPrint('ðŸ“¤ PUT pushToken â†’ $url body:$body');
      final res = await _api.putRequest(url, body);
      debugPrint('ðŸ“¥ PUT pushToken â† $res');
    } catch (e) {
      debugPrint('âŒ registerToken error: $e');
    }
  }

  /// Delete the FCM token locally on logout.
  Future<void> clearToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      _token = null;
    } catch (e) {
      debugPrint('âŒ clearToken error: $e');
    }
  }
}

/// Top-level helper â€” shared by foreground/opened/background handlers so the
/// notification payload always carries a `type` even when the backend sends
/// an empty `data` block (current FemiRides backend behaviour).
Map<String, dynamic> enrichFcmPayload(
    Map<String, dynamic> data, String? title, [String? body]) {
  // Already has type â€” leave it.
  if (data['type'] != null && data['type'].toString().isNotEmpty) return data;

  final t = (title ?? '').toLowerCase().trim();
  String? inferredType;
  if (t.contains('message') || t.contains('chat')) {
    inferredType = 'chat_message';
  } else if (t.contains('driver found') || t.contains('driver matched')) {
    inferredType = 'driver_found';
  } else if (t.contains('driver arrived') || t.contains('on the way')) {
    inferredType = 'driver_arrived';
  } else if (t.contains('ride started') || t.contains('trip started')) {
    inferredType = 'ride_started';
  } else if (t.contains('completed') || t.contains('arrived')) {
    inferredType = 'ride_completed';
  } else if (t.contains('cancelled') || t.contains('canceled')) {
    inferredType = 'ride_cancelled';
  } else if (t.contains('payment') || t.contains('paid')) {
    inferredType = 'payment_confirmed';
  } else if (t.contains('promo') ||
      t.contains('offer') ||
      t.contains('discount')) {
    inferredType = 'promo_offer';
  }
  if (inferredType == null) return data;
  debugPrint('ðŸ”” Inferred notification type: $inferredType from title: "$title"');
  return {...data, 'type': inferredType, if (body != null) 'body': body};
}

/// Top-level background message handler â€” registered in main().
/// Keep it tiny and side-effect-free; full handling happens
/// on tap via [PushNotificationService._onMessageOpened].
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final n = message.notification;
  final title = n?.title ?? message.data['title']?.toString();
  final body = n?.body ?? message.data['body']?.toString();

  debugPrint('ðŸ”” FCM Background Message: ${message.messageId}');
  debugPrint('   Title: $title');
  debugPrint('   Body:  $body');
  debugPrint('   Data:  ${message.data}');

  // For data-only payloads the OS does not auto-display a notification â€”
  // render it manually from the background isolate.
  if (n == null && (title != null || body != null)) {
    final local = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings();
    await local.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );
    await local.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'femirides_default',
          'FemiRides Notifications',
          channelDescription: 'Ride, payment and support alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/launcher_icon',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(enrichFcmPayload(message.data, title, body)),
    );
  }
}

