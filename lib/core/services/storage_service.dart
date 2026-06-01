// lib/core/services/storage_service.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🟢 FIXED: Exposes SharedPreferences and its static factory initializers

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Synchronous initialization factory for registering into GetIt Service Locator
  static Future<StorageService> init() async {
    // 🟢 RESOLVED: getInstance() is now fully recognized by the analyzer
    final sharedPrefsInstance = await SharedPreferences.getInstance();
    return StorageService(sharedPrefsInstance);
  }

  /// Persists a string value to local device storage
  Future<bool> writeString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      debugPrint('StorageService Error [writeString]: $e');
      return false;
    }
  }

  /// Retrieves a string value from local device storage
  String? readString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      debugPrint('StorageService Error [readString]: $e');
      return null;
    }
  }

  /// Persists a boolean flag to local device storage
  Future<bool> writeBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      debugPrint('StorageService Error [writeBool]: $e');
      return false;
    }
  }

  /// Retrieves a boolean flag from local device storage
  bool? readBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      debugPrint('StorageService Error [readBool]: $e');
      return null;
    }
  }

  /// Evicts an explicit database entry index key from cache storage
  Future<bool> removeKey(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      debugPrint('StorageService Error [removeKey]: $e');
      return false;
    }
  }

  /// Completely wipes persistent caches (Used during forced security resets/logouts)
  Future<bool> wipeAllData() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      debugPrint('StorageService Error [wipeAllData]: $e');
      return false;
    }
  }
}