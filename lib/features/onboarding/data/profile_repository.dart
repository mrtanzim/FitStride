import '../../../core/services/supabase_client.dart';
import 'profile_model.dart';

class ProfileRepository {
  Future<ProfileModel?> fetchProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return ProfileModel.fromJson(data);
  }

  Future<void> upsertProfile(ProfileModel profile) async {
    await supabase
        .from('profiles')
        .upsert(profile.toJson());
  }

  Future<void> markOnboarded() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    await supabase
        .from('profiles')
        .update({'onboarded': true, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }
}
