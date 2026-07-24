import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';
import '../../../core/utils/encryption_utils.dart';
import '../../settings/providers/settings_provider.dart';
import '../pages/oauth_webview_screen.dart';
import '../../../core/sync/sync_service.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref _ref;
  AuthService(this._ref);

  String _generateCodeVerifier() {
    final rand = Random.secure();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    return List.generate(128, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  // ==========================================
  // ANILIST AUTHENTICATION
  // ==========================================

  Future<void> loginWithAniList(BuildContext context) async {
    final authUrl = "https://anilist.co/api/v2/oauth/authorize?client_id=${ApiConfig.aniListClientId}&response_type=token";
    
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => OAuthWebViewScreen(
          authUrl: authUrl,
          redirectUri: ApiConfig.aniListRedirectUri,
          onRedirectMatched: (redirectUrl) async {
            final fragment = Uri.parse(redirectUrl.replaceFirst('#', '?')).queryParameters;
            final token = fragment['access_token'];
            
            if (token != null && token.isNotEmpty) {
              final profile = await _fetchAniListProfile(token);
              if (profile != null) {
                final username = profile['name'] as String;
                final userId = profile['id'] as int;
                final avatarUrl = profile['avatar']?['large'] as String?;
                
                final settings = _ref.read(settingsNotifierProvider);
                await _ref.read(settingsNotifierProvider.notifier).updateSettings(
                  settings.copyWith(
                    aniListToken: EncryptionUtils.encrypt(token),
                    aniListUsername: username,
                    aniListUserId: userId,
                    aniListAvatar: avatarUrl,
                    aniListLastSync: DateTime.now().toIso8601String(),
                  ),
                );
                
                if (context.mounted) {
                  Navigator.of(context).pop(true); // Pop with success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Successfully connected AniList account: $username")),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.of(context).pop(false); // Pop with failure
                }
              }
            }
          },
        ),
      ),
    );

    if (context.mounted) {
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login cancelled.")),
        );
      } else if (result == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to connect to AniList. Please try again later.")),
        );
      } else if (result == true) {
        _ref.read(syncServiceProvider).importLibraryAfterLogin(context);
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchAniListProfile(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': 'query { Viewer { id name avatar { large } } }',
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['Viewer'];
      }
    } catch (_) {}
    return null;
  }

  Future<void> logoutAniList() async {
    final settings = _ref.read(settingsNotifierProvider);
    await _ref.read(settingsNotifierProvider.notifier).updateSettings(
      settings.copyWith(
        clearAniListToken: true,
      ),
    );
  }

  // ==========================================
  // MYANIMELIST AUTHENTICATION
  // ==========================================

  Future<void> loginWithMyAnimeList(BuildContext context) async {
    final verifier = _generateCodeVerifier();
    final authUrl = "https://myanimelist.net/v1/oauth2/authorize?response_type=code&client_id=${ApiConfig.malClientId}&redirect_uri=${Uri.encodeComponent(ApiConfig.malRedirectUri)}&code_challenge=$verifier&code_challenge_method=plain";

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => OAuthWebViewScreen(
          authUrl: authUrl,
          redirectUri: ApiConfig.malRedirectUri,
          onRedirectMatched: (redirectUrl) async {
            final uri = Uri.parse(redirectUrl);
            final code = uri.queryParameters['code'];
            
            if (code != null && code.isNotEmpty) {
              final tokenData = await _exchangeMalCodeForToken(code, verifier);
              if (tokenData != null) {
                final accessToken = tokenData['access_token'] as String;
                final profile = await _fetchMalProfile(accessToken);
                if (profile != null) {
                  final username = profile['name'] as String;
                  final avatarUrl = profile['picture'] as String?;
                  
                  final settings = _ref.read(settingsNotifierProvider);
                  await _ref.read(settingsNotifierProvider.notifier).updateSettings(
                    settings.copyWith(
                      malToken: EncryptionUtils.encrypt(accessToken),
                      malRefreshToken: EncryptionUtils.encrypt(tokenData['refresh_token'] as String),
                      malTokenExpiresAt: tokenData['expires_at'] as String,
                      malUsername: username,
                      malAvatar: avatarUrl,
                      malLastSync: DateTime.now().toIso8601String(),
                    ),
                  );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop(true); // Pop with success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Successfully connected MyAnimeList account: $username")),
                    );
                  }
                } else {
                  if (context.mounted) Navigator.of(context).pop(false);
                }
              } else {
                if (context.mounted) Navigator.of(context).pop(false);
              }
            }
          },
        ),
      ),
    );

    if (context.mounted) {
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login cancelled.")),
        );
      } else if (result == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to connect to MyAnimeList. Please try again later.")),
        );
      } else if (result == true) {
        _ref.read(syncServiceProvider).importLibraryAfterLogin(context);
      }
    }
  }

  Future<Map<String, dynamic>?> _exchangeMalCodeForToken(String code, String verifier) async {
    try {
      final response = await http.post(
        Uri.parse('https://myanimelist.net/v1/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': ApiConfig.malClientId,
          if (ApiConfig.malClientSecret.isNotEmpty) 'client_secret': ApiConfig.malClientSecret,
          'grant_type': 'authorization_code',
          'code': code,
          'code_verifier': verifier,
          'redirect_uri': ApiConfig.malRedirectUri,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final expiresIn = data['expires_in'] as int;
        final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
        
        return {
          'access_token': data['access_token'] as String,
          'refresh_token': data['refresh_token'] as String,
          'expires_at': expiresAt.toIso8601String(),
        };
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> _fetchMalProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.myanimelist.net/v2/users/@me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}
    return null;
  }

  Future<void> logoutMyAnimeList() async {
    final settings = _ref.read(settingsNotifierProvider);
    await _ref.read(settingsNotifierProvider.notifier).updateSettings(
      settings.copyWith(
        clearMalToken: true,
      ),
    );
  }

  // ==========================================
  // SESSION RECOVERY AND REFRESH TOKEN
  // ==========================================

  Future<bool> refreshMalTokenIfNeeded() async {
    final settings = _ref.read(settingsNotifierProvider);
    final encryptedToken = settings.malToken;
    final encryptedRefresh = settings.malRefreshToken;
    final expiresAtStr = settings.malTokenExpiresAt;
    
    if (encryptedToken == null || encryptedRefresh == null || expiresAtStr == null) {
      return false;
    }
    
    final expiresAt = DateTime.tryParse(expiresAtStr);
    if (expiresAt == null) return false;
    
    // Refresh token if it expires in less than 2 days
    if (expiresAt.difference(DateTime.now()).inDays > 2) {
      return true; // Token still valid
    }
    
    final refreshToken = EncryptionUtils.decrypt(encryptedRefresh);
    try {
      final response = await http.post(
        Uri.parse('https://myanimelist.net/v1/oauth2/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': ApiConfig.malClientId,
          'client_secret': ApiConfig.malClientSecret,
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access_token'] as String;
        final newRefreshToken = data['refresh_token'] as String;
        final expiresIn = data['expires_in'] as int;
        final newExpiresAt = DateTime.now().add(Duration(seconds: expiresIn));
        
        await _ref.read(settingsNotifierProvider.notifier).updateSettings(
          settings.copyWith(
            malToken: EncryptionUtils.encrypt(newAccessToken),
            malRefreshToken: EncryptionUtils.encrypt(newRefreshToken),
            malTokenExpiresAt: newExpiresAt.toIso8601String(),
          ),
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<void> restoreSessionsOnLaunch() async {
    await refreshMalTokenIfNeeded();
  }
}
