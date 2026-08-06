import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/widget/home_widget_service.dart';

class UserProfile {
  final String? name;
  final DateTime birthDate;
  final int lifeExpectancyYears;
  final bool onboardingCompleted;

  const UserProfile({
    this.name,
    required this.birthDate,
    this.lifeExpectancyYears = 80,
    this.onboardingCompleted = false,
  });

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    int? lifeExpectancyYears,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      lifeExpectancyYears: lifeExpectancyYears ?? this.lifeExpectancyYears,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'lifeExpectancyYears': lifeExpectancyYears,
        'onboardingCompleted': onboardingCompleted,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String?,
        birthDate: DateTime.parse(json['birthDate'] as String),
        lifeExpectancyYears: json['lifeExpectancyYears'] as int? ?? 80,
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      );
}

class UserProfileRepository {
  static const _key = 'user_profile';
  final SharedPreferences _prefs;

  UserProfileRepository(this._prefs);

  UserProfile? getProfile() {
    final json = _prefs.getString(_key);
    if (json == null) return null;
    return UserProfile.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_key, jsonEncode(profile.toJson()));
  }

  Future<void> deleteProfile() async {
    await _prefs.remove(_key);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(sharedPreferencesProvider));
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return UserProfileNotifier(repo);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final UserProfileRepository _repo;

  UserProfileNotifier(this._repo) : super(null) {
    state = _repo.getProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _repo.saveProfile(profile);
    state = profile;
    await HomeWidgetService.syncProfile(profile);
  }

  Future<void> updateProfile(UserProfile Function(UserProfile) updater) async {
    if (state == null) return;
    final updated = updater(state!);
    await _repo.saveProfile(updated);
    state = updated;
    await HomeWidgetService.syncProfile(updated);
  }

  /// Выход из текущего профиля, чтобы можно было завести другого человека.
  Future<void> logout() async {
    await _repo.deleteProfile();
    state = null;
    await HomeWidgetService.syncProfile(null);
  }
}
