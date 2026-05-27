import 'dart:convert';
import 'dart:io';

import 'package:faneasy/Utils/secure_storage_helper.dart';
import 'package:faneasy/Utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// ─────────────────────────────────────────────────────────
///  ApiService — HTTP client with secure token management.
/// ─────────────────────────────────────────────────────────
///  Legacy file ported from another project. Imports above
///  point at packages / helpers that are not part of this
///  project yet (excluded from analysis via
///  `analysis_options.yaml`). Wire up when the auth + storage
///  layers land.
/// ─────────────────────────────────────────────────────────
class ApiService {
  static const Duration _timeout = Duration(seconds: 30);

  final SecureStorageHelper _secure = SecureStorageHelper.instance;

  // ─────────────────────────────────────────────
  //  Headers (reads token from secure storage)
  // ─────────────────────────────────────────────
  Future<Map<String, String>> _getHeaders() async {
    final token = await _secure.getAccessToken();
    debugPrint('🔑 TOKEN: ${token != null ? '${token.substring(0, 20)}…' : 'null'}');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ─────────────────────────────────────────────
  //  GET
  // ─────────────────────────────────────────────
  Future<dynamic> getRequest(String url) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      _showToast('No Internet Connection');
      throw Exception('No Internet Connection');
    } catch (e) {
      debugPrint('❌ GET error: $e');
      _showToast('Request failed. Please try again.');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  //  POST
  // ─────────────────────────────────────────────
  Future<dynamic> postRequest(String url, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      _showToast('No Internet Connection');
      throw Exception('No Internet Connection');
    } catch (e) {
      debugPrint('❌ POST error: $e');
      _showToast('Request failed. Please try again.');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  //  PUT
  // ─────────────────────────────────────────────
  Future<dynamic> putRequest(String url, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      _showToast('No Internet Connection');
      throw Exception('No Internet Connection');
    } catch (e) {
      debugPrint('❌ PUT error: $e');
      _showToast('Request failed. Please try again.');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  //  PATCH
  // ─────────────────────────────────────────────
  Future<dynamic> patchRequest(String url, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .patch(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      _showToast('No Internet Connection');
      throw Exception('No Internet Connection');
    } catch (e) {
      debugPrint('❌ PATCH error: $e');
      _showToast('Request failed. Please try again.');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  //  DELETE
  // ─────────────────────────────────────────────
  Future<dynamic> deleteRequest(String url, [Map<String, dynamic>? body]) async {
    try {
      final headers = await _getHeaders();
      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on SocketException {
      _showToast('No Internet Connection');
      throw Exception('No Internet Connection');
    } catch (e) {
      debugPrint('❌ DELETE error: $e');
      _showToast('Request failed. Please try again.');
      rethrow;
    }
  }

  // ─────────────────────────────────────────────
  //  Generic auth request (legacy compatibility)
  // ─────────────────────────────────────────────
  Future<Map<String, dynamic>> authResponse({
    Map<String, dynamic>? body,
    required String requestType,
    required String url,
  }) async {
    try {
      debugPrint('📡 API: $requestType $url');
      final headers = await _getHeaders();
      http.Response response;

      if (requestType.toUpperCase() == 'POST') {
        response = await http
            .post(Uri.parse(url), headers: headers, body: jsonEncode(body ?? {}))
            .timeout(_timeout);
      } else if (requestType.toUpperCase() == 'GET') {
        response = await http
            .get(Uri.parse(url), headers: headers)
            .timeout(_timeout);
      } else {
        throw Exception('Unsupported request type: $requestType');
      }

      debugPrint('📥 ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400 || response.statusCode == 422) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        debugPrint('⚠️ 401 Unauthorized — clearing tokens');
        await _secure.deleteAccessToken();
        await _secure.deleteRefreshToken();
        return {'error': 'Unauthorized'};
      } else {
        _showToast('Request failed (${response.statusCode})');
        throw Exception('Request failed: ${response.statusCode}');
      }
    } on SocketException {
      _showToast('No Internet Connection');
      return {'error': 'No Internet Connection'};
    } catch (e) {
      debugPrint('❌ authResponse error: $e');
      _showToast('Failed to connect to the server');
      return {'error': 'Failed to connect to the server'};
    }
  }

  // ─────────────────────────────────────────────
  //  Response handler
  // ─────────────────────────────────────────────
  dynamic _handleResponse(http.Response response) async {
    debugPrint('📥 ${response.statusCode}: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 404:
      case 422:
        return jsonDecode(response.body);
      case 401:
        debugPrint('⚠️ 401 Unauthorized — clearing tokens');
        await _secure.deleteAccessToken();
        await _secure.deleteRefreshToken();
        return null;
      case 500:
        customToast(message: 'Server Not Responding… Please try again');
        return jsonDecode(response.body);
      default:
        try {
          return jsonDecode(response.body);
        } catch (_) {
          throw Exception('Error: ${response.statusCode}');
        }
    }
  }

  // ─────────────────────────────────────────────
  //  Toast helper
  // ─────────────────────────────────────────────
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // ─────────────────────────────────────────────
  //  Redirect helper
  // ─────────────────────────────────────────────
  Future<String?> getRedirectLocation(String url) async {
    try {
      final headers = await _getHeaders();
      final request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);
      request.followRedirects = false;

      final streamedResponse = await request.send().timeout(_timeout);

      if (streamedResponse.isRedirect) {
        return streamedResponse.headers['location'];
      }

      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          if (body is Map && body.containsKey('url')) return body['url'];
        } catch (_) {}
      }
      return null;
    } catch (e) {
      debugPrint('❌ getRedirectLocation error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  //  File downloads
  // ─────────────────────────────────────────────
  Future<void> downloadFile({
    required String url,
    required String fileName,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/$fileName';
        await File(filePath).writeAsBytes(response.bodyBytes);
        debugPrint('📄 Downloaded: $filePath');
        await OpenFile.open(filePath);
      } else {
        _showToast('Failed to download file. Try again.');
      }
    } on SocketException {
      _showToast('No Internet Connection');
    } catch (e) {
      debugPrint('❌ downloadFile error: $e');
      _showToast('Something went wrong while downloading.');
    }
  }

  Future<String?> downloadFileOnly({
    required String url,
    required String fileName,
  }) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/$fileName';
        await File(filePath).writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        _showToast('Failed to download file. Try again.');
        return null;
      }
    } on SocketException {
      _showToast('No Internet Connection');
      return null;
    } catch (e) {
      debugPrint('❌ downloadFileOnly error: $e');
      _showToast('Something went wrong while downloading.');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  //  Image / file uploads
  // ─────────────────────────────────────────────
  Future<List<String>> uploadImages({
    required String url,
    required List<File> files,
    String folder = 'stores',
    String fieldName = 'images',
  }) async {
    if (files.isEmpty) return [];
    try {
      final headers = await _getHeaders();
      headers.remove('Content-Type');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['folder'] = folder;

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
        final parts = mimeType.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            file.path,
            contentType:
                MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
            filename:
                'image_${DateTime.now().millisecondsSinceEpoch}_$i.${file.path.split('.').last}',
          ),
        );
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        if (res['status'] == 1) {
          if (res['files'] != null && res['files'] is List) {
            return (res['files'] as List)
                .map((f) => f['fileName']?.toString() ?? '')
                .where((n) => n.isNotEmpty)
                .toList();
          } else if (res['fileName'] != null && res['fileName'] is List) {
            return List<String>.from(res['fileName']);
          }
        }
        return [];
      } else {
        final errorRes = jsonDecode(response.body);
        _showToast(
            'Upload failed: ${errorRes['error'] ?? errorRes['message'] ?? 'Unknown'}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ uploadImages error: $e');
      _showToast('Failed to upload images');
      return [];
    }
  }

  Future<Map<String, String>?> uploadImage({
    required String url,
    required File file,
    required String folder,
    String fieldName = 'image',
  }) async {
    try {
      final headers = {'Accept': 'application/json'};

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields['folder'] = folder;

      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType:
              MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
          filename:
              'image_${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}',
        ),
      );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final status = res['status'] ?? res['Status'];
        if (status.toString() == '1') {
          final fileName = res['fileName'] ?? res['data']?['fileName'];
          final fileUrl = res['fileUrl'] ?? res['data']?['fileUrl'];
          if (fileName != null && fileUrl != null) {
            return {
              'fileName': fileName.toString(),
              'fileUrl': fileUrl.toString(),
            };
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ uploadImage error: $e');
      return null;
    }
  }

  Future<bool> uploadFileRaw(String url, File file) async {
    try {
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final response = await http
          .put(
            Uri.parse(url),
            body: bytes,
            headers: {
              'Content-Type': mimeType,
              'Content-Length': bytes.length.toString(),
            },
          )
          .timeout(const Duration(seconds: 120));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('❌ uploadFileRaw error: $e');
      return false;
    }
  }

  Future<bool> uploadFileS3Post({
    required String url,
    required Map<String, dynamic> fields,
    required File file,
  }) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      fields.forEach((key, value) => request.fields[key] = value.toString());
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType:
              MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg'),
        ),
      );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 120));
      return streamedResponse.statusCode == 204 ||
          streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201;
    } catch (e) {
      debugPrint('❌ uploadFileS3Post error: $e');
      return false;
    }
  }
}
