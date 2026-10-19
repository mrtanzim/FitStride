import '../../../core/services/supabase_client.dart';

class MentorRepository {
  /// Calls the mentor-chat Edge Function.
  /// Returns {reply: String, messagesLeft: int} or throws.
  Future<Map<String, dynamic>> sendMessage(String message) async {
    final session = supabase.auth.currentSession;
    if (session == null) {
      // Offline mode: return a static reply
      return {
        'reply': 'Sign in to unlock real AI mentor responses. Offline mode active.',
        'messagesLeft': 0,
      };
    }

    final response = await supabase.functions.invoke(
      'mentor-chat',
      body: {'message': message},
    );

    if (response.status != 200) {
      final err = response.data?['error'] ?? 'Unknown error';
      throw Exception(err);
    }

    return {
      'reply': response.data['reply'] as String,
      'messagesLeft': response.data['messagesLeft'] as int? ?? 30,
    };
  }

  /// Load last 20 messages from Supabase
  Future<List<Map<String, dynamic>>> loadHistory() async {
    if (supabase.auth.currentSession == null) return [];
    final rows = await supabase
        .from('mentor_messages')
        .select('role, content, created_at')
        .order('created_at', ascending: true)
        .limit(20);
    return List<Map<String, dynamic>>.from(rows);
  }
}
