import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _profileKey = 'forge_profile';
  static const _onboardedKey = 'forge_onboarded';

  static Future<void> saveProfile(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_profileKey);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  static Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }

  static Future<void> markOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_onboardedKey);
  }

  static const _waterTodayKey = 'forge_water_today';

  /// Stores or updates today's water total in local storage.
  /// Resets automatically if the stored date differs from today.
  static Future<void> logWaterLocal(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateStr =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final existing = prefs.getString(_waterTodayKey);
    int currentTotal = 0;
    if (existing != null) {
      final decoded = jsonDecode(existing) as Map<String, dynamic>;
      if (decoded['date'] == dateStr) {
        currentTotal = (decoded['total_ml'] as int? ?? 0);
      }
      // else: date mismatch → reset to 0
    }
    currentTotal += ml;
    await prefs.setString(
      _waterTodayKey,
      jsonEncode({'date': dateStr, 'total_ml': currentTotal}),
    );
  }

  /// Reads today's locally stored water total in ml (0 if none or date mismatch).
  static Future<int> getLocalWaterTodayMl() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateStr =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final existing = prefs.getString(_waterTodayKey);
    if (existing == null) return 0;
    final decoded = jsonDecode(existing) as Map<String, dynamic>;
    if (decoded['date'] != dateStr) return 0;
    return decoded['total_ml'] as int? ?? 0;
  }
}
