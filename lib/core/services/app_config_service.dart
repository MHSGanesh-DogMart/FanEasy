import 'dart:io';

import 'package:faneasy/core/services/app_urls.dart';
import 'package:faneasy/core/services/api_environment.dart';
import 'package:faneasy/core/services/api_service.dart';
import 'package:flutter/foundation.dart';

/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
///  AppConfigService â€” miscellaneous /api/v1 root endpoints.
///   GET /api/v1/app-version
///   GET /api/v1/config
///   GET /api/v1/share/{token}
///   GET /health
///
///   POST /api/v1/user/upload/presign/signup-photo
///     (no-auth presigned upload used during OTP signup)
/// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class AppConfigService {
  AppConfigService._();
  static final AppConfigService instance = AppConfigService._();

  final ApiService _api = ApiService();

  /// Called on splash. Returns `{ required_version, latest_version, message }`
  /// or null if the call fails. UI decides whether to force-update.
  Future<Map<String, dynamic>?> fetchAppVersion() async {
    try {
      final url = '${Api.baseUrl}${AppUrls.appVersion}';
      debugPrint('ðŸ“¤ GET AppVersion â†’ $url');
      final res = await _api.getRequest(url);
      debugPrint('ðŸ“¥ GET AppVersion â† $res');
      if (res != null && res['Status'] == 1 && res['Data'] != null) {
        return Map<String, dynamic>.from(res['Data'] as Map);
      }
      return null;
    } catch (e) {
      debugPrint('âŒ fetchAppVersion error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchConfig() async {
    try {
      final url = '${Api.baseUrl}${AppUrls.config}';
      debugPrint('ðŸ“¤ GET Config â†’ $url');
      final res = await _api.getRequest(url);
      debugPrint('ðŸ“¥ GET Config â† $res');
      if (res != null && res['Status'] == 1 && res['Data'] != null) {
        return Map<String, dynamic>.from(res['Data'] as Map);
      }
      return null;
    } catch (e) {
      debugPrint('âŒ fetchConfig error: $e');
      return null;
    }
  }

  /// GET /api/v1/share/{token} â€” used for live-trip-tracking deep links.
  Future<Map<String, dynamic>?> fetchShareTrip(String token) async {
    try {
      final url = '${Api.baseUrl}${AppUrls.shareTrip}/$token';
      debugPrint('ðŸ“¤ GET ShareTrip â†’ $url');
      final res = await _api.getRequest(url);
      debugPrint('ðŸ“¥ GET ShareTrip â† $res');
      if (res != null && res['Status'] == 1 && res['Data'] != null) {
        return Map<String, dynamic>.from(res['Data'] as Map);
      }
      return null;
    } catch (e) {
      debugPrint('âŒ fetchShareTrip error: $e');
      return null;
    }
  }

  Future<bool> ping() async {
    try {
      final url = '${Api.baseUrl}${AppUrls.health}';
      debugPrint('ðŸ“¤ GET Health â†’ $url');
      final res = await _api.getRequest(url);
      debugPrint('ðŸ“¥ GET Health â† $res');
      return res != null && (res['status'] == 'ok' || res['Status'] == 1);
    } catch (e) {
      debugPrint('âŒ ping error: $e');
      return false;
    }
  }

  /// POST /api/v1/user/upload/presign/signup-photo
  ///
  /// During OTP signup the user has no access token yet, so we use the
  /// unauthenticated presign endpoint. Returns the S3 image_key on success
  /// which the backend will associate with the account in verifyOtp.
  Future<String?> presignAndUploadSignupPhoto(File file, {String contentType = 'image/jpeg'}) async {
    try {
      final url = '${Api.baseUrl}${AppUrls.presignSignupPhoto}';
      debugPrint('ðŸ“¤ POST SignupPhoto presign â†’ $url');
      final res = await _api.postRequest(url, {
        'content_type': contentType,
      });
      debugPrint('ðŸ“¥ POST SignupPhoto presign â† $res');

      if (res == null || res['Status'] != 1 || res['Data'] == null) {
        return null;
      }

      final data = res['Data'] as Map<String, dynamic>;
      final uploadUrl = data['upload_url'] as String?;
      final fields = (data['fields'] as Map?)?.cast<String, dynamic>() ?? {};
      final imageKey = data['image_key'] as String?;

      if (uploadUrl == null || imageKey == null) return null;

      final uploaded = await _api.uploadFileS3Post(
        url: uploadUrl,
        fields: fields,
        file: file,
      );

      return uploaded ? imageKey : null;
    } catch (e) {
      debugPrint('âŒ presignAndUploadSignupPhoto error: $e');
      return null;
    }
  }
}

