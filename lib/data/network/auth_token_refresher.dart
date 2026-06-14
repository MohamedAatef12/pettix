import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:talker/talker.dart';

@lazySingleton
class AuthTokenRefresher {
  final ICacheManager _cache;
  final Talker _talker;

  AuthTokenRefresher(this._cache, this._talker);

  String normalizeToken(String token) {
    const prefix = 'Bearer ';
    return token.startsWith(prefix) ? token.substring(prefix.length) : token;
  }

  Future<String?> refresh() async {
    try {
      final refreshToken = await _cache.getRefreshToken();
      final accessToken = await _cache.getToken();

      if (refreshToken == null ||
          refreshToken.isEmpty ||
          accessToken == null ||
          accessToken.isEmpty) {
        _talker.error('Refresh token flow: missing access or refresh token.');
        return null;
      }

      _talker.info('Refresh token flow: requesting new access token...');

      final dio = Dio(
        BaseOptions(
          baseUrl: Constants.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final response = await dio.post(
        '/api/Security/Authentication/refresh-token',
        data: {
          'refreshToken': refreshToken,
          'accessToken': normalizeToken(accessToken),
        },
      );

      final data = response.data;
      final result = data is Map ? (data['result'] ?? data) : null;
      final newToken = result?['token'] ?? result?['accessToken'];
      final newRefreshToken = result?['refreshToken'];

      if (newToken == null || newToken.toString().isEmpty) {
        _talker.error('Refresh token flow: response has no token. Data: $data');
        return null;
      }

      await _cache.setToken(normalizeToken(newToken.toString()));
      if (newRefreshToken != null && newRefreshToken.toString().isNotEmpty) {
        await _cache.setRefreshToken(newRefreshToken.toString());
      }

      _talker.info('Refresh token flow: token refreshed successfully.');
      return normalizeToken(newToken.toString());
    } catch (e) {
      if (e is DioException) {
        _talker.error(
          'Refresh token flow failed: ${e.response?.statusCode} ${e.response?.data ?? e.message}',
        );
      } else {
        _talker.error('Refresh token flow failed: $e');
      }
      return null;
    }
  }
}
