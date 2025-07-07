import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_helper_exceptions.dart';

class SharedPrefHelper {
  static const _backupSuffix = '.bak';
  static final _helperInstance = SharedPrefHelper._internal();
  factory SharedPrefHelper() => _helperInstance;
  SharedPrefHelper._internal();

  SharedPreferences? _instance;
  static SharedPreferences get instance {
    if (_helperInstance._instance == null) {
      throw SharedPrefHelperExceptions('SharedPrefHelper not initialized');
    }
    return _helperInstance._instance!;
  }

  Future<void> init() async {
    if (_instance != null) return;
    try {
      _instance = await SharedPreferences.getInstance().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          throw SharedPrefHelperExceptions('SharedPrefHelper not initialized');
        },
      );
      backup();
    } catch (e) {
      debugPrint('🔄 SharedPreferences Error: $e');
      await _attemptRestore();

      try {
        _instance = await SharedPreferences.getInstance();
      } catch (e) {
        debugPrint('🔄 SharedPreferences still failing, deleting file...');
        final file = await _getWindowsPrefsFile();
        await file.delete();
        _instance = await SharedPreferences.getInstance();
      }
    }
  }

  static Future<void> backup() async {
    debugPrint('🔄 Backing up SharedPreferences...');
    final file = await _getWindowsPrefsFile();
    final backup = await _getBackupFile();
    if (await file.exists()) {
      await file.copy(backup.path);
    }
  }

  static Future<File> _getWindowsPrefsFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/shared_preferences.json');
  }

  static Future<File> _getBackupFile() async {
    final prefs = await _getWindowsPrefsFile();
    return File('${prefs.path}$_backupSuffix');
  }

  static Future<void> _attemptRestore() async {
    debugPrint('🔄 Restoring SharedPreferences from backup...');
    final file = await _getWindowsPrefsFile();
    final backup = await _getBackupFile();

    if (await backup.exists()) {
      debugPrint("✅ Restoring SharedPreferences from backup.");
      await backup.copy(file.path);
    } else {
      debugPrint("❌ No backup found. Resetting SharedPreferences.");
      await file.delete();
    }
  }
}
