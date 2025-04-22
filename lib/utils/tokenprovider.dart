import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenProvider with ChangeNotifier {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static String? currentToken;

  String? _accessToken;
  String? _refreshToken;
  SharedPreferences? _prefs;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoggedIn => _accessToken != null;

  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadFromPrefs();
    } catch (e) {
      debugPrint('Error initializing AccessTokenProvider: $e');
      // Initialize with empty prefs if fails
      _prefs ??= await SharedPreferences.getInstance();
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    currentToken = token;
  }

  static Future<String?> getToken() async {
    if (currentToken != null) return currentToken;
    final prefs = await SharedPreferences.getInstance();
    currentToken = prefs.getString('access_token');
    return currentToken;
  }

  Future<void> _loadFromPrefs() async {
    if (_prefs == null) {
      await initialize();
      return;
    }

    _accessToken = _prefs!.getString(_accessTokenKey);
    _refreshToken = _prefs!.getString(_refreshTokenKey);

    notifyListeners();
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiryDate,
  }) async {
    if (_prefs == null) {
      await initialize();
    }

    _accessToken = accessToken;
    _refreshToken = refreshToken;

    try {
      await _prefs!.setString(_accessTokenKey, accessToken);
      if (refreshToken != null) {
        await _prefs!.setString(_refreshTokenKey, refreshToken);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving tokens: $e');
      rethrow;
    }
  }

  Future<void> clearTokens() async {
    if (_prefs == null) {
      await initialize();
    }

    try {
      await _prefs!.remove(_accessTokenKey);
      await _prefs!.remove(_refreshTokenKey);
      _accessToken = null;
      _refreshToken = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
    }
  }
}
