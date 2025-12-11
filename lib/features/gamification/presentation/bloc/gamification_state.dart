import '../../domain/entities/user_stats.dart';

class GamificationState {
  final UserStats stats;
  final bool hasLeveledUp; // To trigger UI effects

  const GamificationState({
    required this.stats,
    this.hasLeveledUp = false,
  });

  factory GamificationState.initial() {
    return GamificationState(stats: UserStats.initial());
  }

  GamificationState copyWith({
    UserStats? stats,
    bool? hasLeveledUp,
  }) {
    return GamificationState(
      stats: stats ?? this.stats,
      hasLeveledUp: hasLeveledUp ?? this.hasLeveledUp,
    );
  }
}
