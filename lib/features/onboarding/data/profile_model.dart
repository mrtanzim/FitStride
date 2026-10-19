class ProfileModel {
  final String id;
  final String? displayName;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final String? goal;
  final String? experienceLevel;
  final String? trainingPlace;
  final int dailyBudgetBdt;
  final List<String> foodsEaten;
  final List<String> foodsAvoided;
  final bool onboarded;

  const ProfileModel({
    required this.id,
    this.displayName,
    this.age,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.experienceLevel,
    this.trainingPlace,
    this.dailyBudgetBdt = 650,
    this.foodsEaten = const [],
    this.foodsAvoided = const [],
    this.onboarded = false,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as String,
    displayName: json['display_name'] as String?,
    age: json['age'] as int?,
    heightCm: (json['height_cm'] as num?)?.toDouble(),
    weightKg: (json['weight_kg'] as num?)?.toDouble(),
    goal: json['goal'] as String?,
    experienceLevel: json['experience_level'] as String?,
    trainingPlace: json['training_place'] as String?,
    dailyBudgetBdt: (json['daily_budget_bdt'] as int?) ?? 650,
    foodsEaten: List<String>.from(json['foods_eaten'] ?? []),
    foodsAvoided: List<String>.from(json['foods_avoided'] ?? []),
    onboarded: (json['onboarded'] as bool?) ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (displayName != null) 'display_name': displayName,
    if (age != null) 'age': age,
    if (heightCm != null) 'height_cm': heightCm,
    if (weightKg != null) 'weight_kg': weightKg,
    if (goal != null) 'goal': goal,
    if (experienceLevel != null) 'experience_level': experienceLevel,
    if (trainingPlace != null) 'training_place': trainingPlace,
    'daily_budget_bdt': dailyBudgetBdt,
    'foods_eaten': foodsEaten,
    'foods_avoided': foodsAvoided,
    'onboarded': onboarded,
  };

  ProfileModel copyWith({
    String? displayName,
    int? age,
    double? heightCm,
    double? weightKg,
    String? goal,
    String? experienceLevel,
    String? trainingPlace,
    int? dailyBudgetBdt,
    List<String>? foodsEaten,
    List<String>? foodsAvoided,
    bool? onboarded,
  }) => ProfileModel(
    id: id,
    displayName: displayName ?? this.displayName,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    goal: goal ?? this.goal,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    trainingPlace: trainingPlace ?? this.trainingPlace,
    dailyBudgetBdt: dailyBudgetBdt ?? this.dailyBudgetBdt,
    foodsEaten: foodsEaten ?? this.foodsEaten,
    foodsAvoided: foodsAvoided ?? this.foodsAvoided,
    onboarded: onboarded ?? this.onboarded,
  );
}
