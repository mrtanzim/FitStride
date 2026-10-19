// ignore_for_file: deprecated_member_use
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/services/local_storage_service.dart';
import '../data/profile_model.dart';
import '../data/profile_repository.dart';

// ---------------------------------------------------------------------------
// Repository provider — kept for future Supabase sync
// ---------------------------------------------------------------------------

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

// ---------------------------------------------------------------------------
// Onboarding state
// ---------------------------------------------------------------------------

class OnboardingState {
  final ProfileModel? profile;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? error,
  }) =>
      OnboardingState(
        profile: profile ?? this.profile,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  static const _goalMap = {
    'muscle': 'hypertrophy',
    'fat': 'deficit',
    'fit': 'endurance',
  };

  static const _levelLabels = [
    'novice',
    'intermediate',
    'advanced',
    'proficient',
    'elite',
  ];

  /// Loads any existing local profile; creates a blank one if none found.
  Future<void> initWithUserId(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await LocalStorageService.loadProfile();
      final existing = data != null ? ProfileModel.fromJson(data) : null;
      state = state.copyWith(
        isLoading: false,
        profile:
            existing ?? ProfileModel(id: userId.isEmpty ? 'local' : userId),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        profile: ProfileModel(id: userId.isEmpty ? 'local' : userId),
        error: e.toString(),
      );
    }
  }

  /// Called after Step 1 (About You).
  void setBasics({
    required int age,
    required double heightCm,
    required double weightKg,
    required String goalUiKey,
  }) {
    final dbGoal = _goalMap[goalUiKey] ?? goalUiKey;
    state = state.copyWith(
      profile: state.profile?.copyWith(
        age: age,
        heightCm: heightCm,
        weightKg: weightKg,
        goal: dbGoal,
      ),
    );
  }

  /// Called after Step 2 (Experience).
  void setExperience({
    required int levelIndex,
    required String trainingPlace,
  }) {
    final level = _levelLabels[levelIndex.clamp(0, _levelLabels.length - 1)];
    state = state.copyWith(
      profile: state.profile?.copyWith(
        experienceLevel: level,
        trainingPlace: trainingPlace,
      ),
    );
  }

  /// Called after Step 3 (Food Budget).
  void setFood({
    required int budgetBdt,
    required List<String> foodsEaten,
    required List<String> foodsAvoided,
  }) {
    state = state.copyWith(
      profile: state.profile?.copyWith(
        dailyBudgetBdt: budgetBdt,
        foodsEaten: foodsEaten,
        foodsAvoided: foodsAvoided,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Async provider for reading the locally persisted profile.
final localProfileProvider = FutureProvider<ProfileModel?>((ref) async {
  final data = await LocalStorageService.loadProfile();
  if (data == null) return null;
  return ProfileModel.fromJson(data);
});
