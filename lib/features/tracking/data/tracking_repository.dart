import '../../../core/services/supabase_client.dart';

class TrackingRepository {
  String? get _userId => supabase.auth.currentUser?.id;

  // ── Water ──────────────────────────────────────────────────────────────────
  Future<void> logWater(int amountMl) async {
    if (_userId == null) return;
    await supabase.from('water_logs').insert({
      'user_id': _userId,
      'amount_ml': amountMl,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }

  /// Total water logged today (local date)
  Future<int> getTodayWaterMl() async {
    if (_userId == null) return 0;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).toIso8601String();
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    final rows = await supabase
        .from('water_logs')
        .select('amount_ml')
        .eq('user_id', _userId!)
        .gte('logged_at', start)
        .lte('logged_at', end);
    int total = 0;
    for (final r in rows) {
      total += (r['amount_ml'] as int? ?? 0);
    }
    return total;
  }

  // ── Food / Protein ─────────────────────────────────────────────────────────
  Future<void> logFood({
    required String label,
    double proteinG = 0,
    int calories = 0,
    int costBdt = 0,
  }) async {
    if (_userId == null) return;
    await supabase.from('food_logs').insert({
      'user_id': _userId,
      'label': label,
      'protein_g': proteinG,
      'calories': calories,
      'cost_bdt': costBdt,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }

  /// Total protein logged today
  Future<double> getTodayProteinG() async {
    if (_userId == null) return 0;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).toIso8601String();
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    final rows = await supabase
        .from('food_logs')
        .select('protein_g')
        .eq('user_id', _userId!)
        .gte('logged_at', start)
        .lte('logged_at', end);
    double total = 0;
    for (final r in rows) {
      total += (r['protein_g'] as num? ?? 0).toDouble();
    }
    return total;
  }

  // ── Weight ─────────────────────────────────────────────────────────────────
  Future<void> logWeight(double weightKg) async {
    if (_userId == null) return;
    await supabase.from('weight_logs').insert({
      'user_id': _userId,
      'weight_kg': weightKg,
      'logged_at': DateTime.now().toIso8601String(),
    });
  }

  Future<double?> getLatestWeight() async {
    if (_userId == null) return null;
    final rows = await supabase
        .from('weight_logs')
        .select('weight_kg')
        .eq('user_id', _userId!)
        .order('logged_at', ascending: false)
        .limit(1);
    if (rows.isEmpty) return null;
    return (rows.first['weight_kg'] as num?)?.toDouble();
  }
}
