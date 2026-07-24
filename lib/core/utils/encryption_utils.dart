import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionUtils {
  static const String _salt = "anispin_secure_salt_v2.1.0_2026";

  /// Encrypts the plain text using XOR with a key derived from SHA-256.
  static String encrypt(String input) {
    if (input.isEmpty) return "";
    final keyBytes = utf8.encode(_salt);
    final hash = sha256.convert(keyBytes).bytes;
    
    final inputBytes = utf8.encode(input);
    final encryptedBytes = List<int>.filled(inputBytes.length, 0);
    
    for (int i = 0; i < inputBytes.length; i++) {
      encryptedBytes[i] = inputBytes[i] ^ hash[i % hash.length];
    }
    
    return base64Url.encode(encryptedBytes);
  }

  /// Decrypts the encrypted base64url string back to plain text.
  static String decrypt(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return "";
    try {
      final keyBytes = utf8.encode(_salt);
      final hash = sha256.convert(keyBytes).bytes;
      
      final encryptedBytes = base64Url.decode(encryptedBase64);
      final decryptedBytes = List<int>.filled(encryptedBytes.length, 0);
      
      for (int i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes[i] = encryptedBytes[i] ^ hash[i % hash.length];
      }
      
      return utf8.decode(decryptedBytes);
    } catch (_) {
      return "";
    }
  }
}
