import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String avatar;

  UserProfile({required this.name, required this.email, required this.avatar});

  UserProfile copyWith({String? name, String? email, String? avatar}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => UserProfile(
        name: "Titan Attariq Alfath",
        email: "titan@chatplan.ai",
        avatar: "suit",
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateAvatar(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(() {
  return UserProfileNotifier();
});

class GamificationState {
  final int xp;
  final int level;
  final String mood;
  final double targetPercentage;

  GamificationState({
    required this.xp,
    required this.level,
    required this.mood,
    required this.targetPercentage,
  });

  GamificationState copyWith({
    int? xp,
    int? level,
    String? mood,
    double? targetPercentage,
  }) {
    return GamificationState(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      mood: mood ?? this.mood,
      targetPercentage: targetPercentage ?? this.targetPercentage,
    );
  }
}

class GamificationNotifier extends Notifier<GamificationState> {
  @override
  GamificationState build() => GamificationState(
        xp: 750,
        level: 5,
        mood: 'Fokus',
        targetPercentage: 80.0,
      );

  void addXp(int amount) {
    int newXp = state.xp + amount;
    int newLevel = state.level;
    if (newXp >= 1000) {
      newLevel += 1;
      newXp = newXp - 1000;
    }
    state = state.copyWith(xp: newXp, level: newLevel);
  }

  void removeXp(int amount) {
    int newXp = state.xp - amount;
    int newLevel = state.level;
    if (newXp < 0) {
      if (newLevel > 1) {
        newLevel -= 1;
        newXp = 1000 + newXp;
      } else {
        newXp = 0;
      }
    }
    state = state.copyWith(xp: newXp, level: newLevel);
  }

  void updateMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void updateTargetPercentage(double target) {
    state = state.copyWith(targetPercentage: target);
  }
}

final gamificationProvider = NotifierProvider<GamificationNotifier, GamificationState>(() {
  return GamificationNotifier();
});
