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

  // ─── AI Mentor configuration ────────────────────────────────────────────────
  static const _aiProviderKey = 'forge_ai_provider'; // 'gemini' | 'openrouter'
  static const _geminiKeyKey = 'forge_gemini_key';
  static const _openrouterKeyKey = 'forge_openrouter_key';
  static const _openrouterModelKey = 'forge_openrouter_model';

  /// Currently selected AI provider. Defaults to 'gemini'.
  static Future<String> getAiProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_aiProviderKey) ?? 'gemini';
  }

  static Future<void> saveAiProvider(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_aiProviderKey, value);
  }

  /// Stored Gemini API key. Empty by default — the AppConfig.geminiApiKey
  /// fallback happens at call time inside MentorRepository, not here.
  static Future<String> getGeminiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_geminiKeyKey) ?? '';
  }

  static Future<void> saveGeminiKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyKey, value);
  }

  /// Stored OpenRouter API key. Empty by default.
  static Future<String> getOpenRouterKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_openrouterKeyKey) ?? '';
  }

  static Future<void> saveOpenRouterKey(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openrouterKeyKey, value);
  }

  /// Selected OpenRouter model id. Defaults to 'google/gemini-flash-1.5'.
  static Future<String> getOpenRouterModel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_openrouterModelKey) ?? 'google/gemini-flash-1.5';
  }

  static Future<void> saveOpenRouterModel(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openrouterModelKey, value);
  }
}
