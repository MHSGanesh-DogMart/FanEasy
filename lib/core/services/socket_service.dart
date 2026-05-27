import 'dart:async';

import 'package:faneasy/core/services/api_environment.dart';
import 'package:faneasy/Utils/secure_storage_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:faneasy/Utils/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
///  SocketService â€” Singleton wrapper around socket_io_client
///  for the RideFlow namespace (user side).
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
///  Events consumed by the User app (per AsyncAPI):
///    listen â†’ driver:found, ride:started, ride:completed,
///             ride:no_drivers, driver:location, server:new_message,
///             driver:arrived
///    emit   â†’ user:cancel_ride, user:send_message, event:ack
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  io.Socket? _socket;
  bool _connecting = false;
  bool _wasDisconnected = false;
  Timer? _heartbeatTimer;
  static const _heartbeatInterval = Duration(seconds: 5);

  // â”€â”€ Broadcast streams â€” any number of UI listeners can subscribe â”€â”€
  final _driverFound = StreamController<Map<String, dynamic>>.broadcast();
  final _driverCancelledSearching =
      StreamController<Map<String, dynamic>>.broadcast();
  final _rideStarted = StreamController<Map<String, dynamic>>.broadcast();
  final _rideCompleted = StreamController<Map<String, dynamic>>.broadcast();
  final _rideNoDrivers = StreamController<Map<String, dynamic>>.broadcast();
  final _rideCancelled = StreamController<Map<String, dynamic>>.broadcast();
  final _driverLocation = StreamController<Map<String, dynamic>>.broadcast();
  final _driverArrived = StreamController<Map<String, dynamic>>.broadcast();
  final _newMessage = StreamController<Map<String, dynamic>>.broadcast();
  final _paymentConfirmed = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionState = StreamController<bool>.broadcast();

  Stream<Map<String, dynamic>> get onDriverFound => _driverFound.stream;
  /// Fires when the driver who was matched cancels before the ride starts,
  /// and the backend has put the booking back into "searching" state.
  Stream<Map<String, dynamic>> get onDriverCancelledSearching =>
      _driverCancelledSearching.stream;
  Stream<Map<String, dynamic>> get onRideStarted => _rideStarted.stream;
  Stream<Map<String, dynamic>> get onRideCompleted => _rideCompleted.stream;
  Stream<Map<String, dynamic>> get onRideNoDrivers => _rideNoDrivers.stream;
  Stream<Map<String, dynamic>> get onRideCancelled => _rideCancelled.stream;
  Stream<Map<String, dynamic>> get onDriverLocation => _driverLocation.stream;
  Stream<Map<String, dynamic>> get onDriverArrived => _driverArrived.stream;
  Stream<Map<String, dynamic>> get onNewMessage => _newMessage.stream;
  Stream<Map<String, dynamic>> get onPaymentConfirmed =>
      _paymentConfirmed.stream;
  Stream<bool> get onConnectionState => _connectionState.stream;

  bool get isConnected => _socket?.connected ?? false;

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Connect â€” call after successful login.
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> connect() async {
    if (_socket?.connected == true || _connecting) return;
    _connecting = true;

    final token = await SecureStorageHelper.instance.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('ðŸ”Œ SocketService: no token â€” skipping connect');
      _connecting = false;
      return;
    }

    _socket = io.io(
      Api.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableReconnection()
          .setReconnectionDelay(100)
          .build(),
    );

    _wireEvents();
    _socket!.connect();
    _connecting = false;
  }

  void _wireEvents() {
    final s = _socket!;

    s.onConnect((_) {
      debugPrint('ðŸ”Œ Socket connected: ${s.id}');
      if (_wasDisconnected) {
        customToast(message: 'Socket Reconnected');
        _wasDisconnected = false;
      }
      _startHeartbeat();
      _connectionState.add(true);
    });

    s.onDisconnect((_) {
      debugPrint('ðŸ”Œ Socket disconnected');
      customToast(
        message: 'Reconnecting...',
      );
      _wasDisconnected = true;
      _stopHeartbeat();
      _connectionState.add(false);
    });

    s.onConnectError((err) => debugPrint('âŒ Socket connect error: $err'));
    s.onError((err) => debugPrint('âŒ Socket error: $err'));

    // â”€â”€ Server â†’ User events â”€â”€
    s.on('driver:found', (d) => _emit(_driverFound, d));
    s.on('driver:cancelled_searching',
        (d) => _emit(_driverCancelledSearching, d));
    s.on('ride:started', (d) => _emit(_rideStarted, d));
    s.on('ride:completed', (d) => _emit(_rideCompleted, d));
    s.on('ride:no_drivers', (d) => _emit(_rideNoDrivers, d));
    s.on('ride:cancelled', (d) => _emit(_rideCancelled, d));
    s.on('driver:location', (d) => _emit(_driverLocation, d));
    s.on('driver:arrived', (d) => _emit(_driverArrived, d));
    s.on('server:new_message', (d) => _emit(_newMessage, d));
    s.on('payment:confirmed', (d) => _emit(_paymentConfirmed, d));
  }

  void _emit(StreamController<Map<String, dynamic>> c, dynamic data) {
    debugPrint('ðŸ“« SOCKET EVENT: ${c.hashCode} data: $data');
    Map<String, dynamic>? map;
    if (data is Map) {
      map = Map<String, dynamic>.from(data);
      c.add(map);
    } else if (data != null) {
      map = {'raw': data};
      c.add(map);
    }
    // AsyncAPI `event:ack` â€” any reliable event carries a `msgId` UUID.
    // Without this ack the server re-delivers it on every reconnect.
    final msgId = map?['msgId'];
    if (msgId is String && msgId.isNotEmpty) {
      ackEvent(msgId);
    }
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Emit helpers (User â†’ Server)
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void cancelRide(
      {required int bookingId, int? reasonId, String? customReason}) {
    _socket?.emit('user:cancel_ride', {
      'booking_id': bookingId,
      if (reasonId != null) 'reason_id': reasonId,
      if (customReason != null) 'custom_reason': customReason,
    });
  }

  /// Emit `user:send_message` per AsyncAPI â€” payload keys are camelCase
  /// (`bookingId`, `message`). `clientMsgId` is included if the server
  /// later adds support for client-side dedupe echoes.
  void sendMessage(
      {required int bookingId, required String text, String? clientMsgId}) {
    _socket?.emit('user:send_message', {
      'bookingId': bookingId,
      'message': text,
      if (clientMsgId != null) 'client_msg_id': clientMsgId,
    });
  }

  /// Acknowledge a reliable event per AsyncAPI `event:ack`.
  /// Payload key MUST be `msgId` â€” the server ignores other keys and
  /// will keep replaying the event on every reconnect.
  /// Called automatically from `_emit` for every incoming event that
  /// carries a `msgId` field.
  void ackEvent(String msgId) {
    final s = _socket;
    if (s == null || !s.connected) {
      debugPrint('âš ï¸ ackEvent: socket not connected, skipping msgId=$msgId');
      return;
    }
    debugPrint('ðŸ“¤ SOCKET ACK â†’ event:ack msgId=$msgId');
    s.emit('event:ack', {'msgId': msgId});
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Heartbeat â€” keep the server's presence tracker fresh.
  //  Emits `user:heartbeat` (no payload) every 20s while connected.
  //  Stops automatically on disconnect; restarted on every reconnect.
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    // Fire one immediately on (re)connect so the server registers us
    // without waiting a full interval.
    _emitHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _emitHeartbeat();
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _emitHeartbeat() {
    final s = _socket;
    if (s == null || !s.connected) return;
    debugPrint('ðŸ’“ SOCKET â†’ user:heartbeat');
    s.emit('user:heartbeat');
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Disconnect â€” call on logout
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> disconnect() async {
    _stopHeartbeat();
    _socket?.dispose();
    _socket = null;
    _connectionState.add(false);
  }

  /// Tear down all broadcast streams (normally never called during app life).
  Future<void> dispose() async {
    await disconnect();
    await _driverFound.close();
    await _driverCancelledSearching.close();
    await _rideStarted.close();
    await _rideCompleted.close();
    await _rideNoDrivers.close();
    await _rideCancelled.close();
    await _driverLocation.close();
    await _driverArrived.close();
    await _newMessage.close();
    await _paymentConfirmed.close();
    await _connectionState.close();
  }
}

