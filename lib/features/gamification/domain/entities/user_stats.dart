class UserStats {
  final int level;
  final int currentXP;
  final int maxXP;
  final String title;

  const UserStats({
    required this.level,
    required this.currentXP,
    required this.maxXP,
    required this.title,
  });

  factory UserStats.initial() {
    return const UserStats(
      level: 1,
      currentXP: 0,
      maxXP: 100, // XP needed for level 2
      title: "Novice",
    );
  }

  UserStats copyWith({
    int? level,
    int? currentXP,
    int? maxXP,
    String? title,
  }) {
    return UserStats(
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      maxXP: maxXP ?? this.maxXP,
      title: title ?? this.title,
    );
  }
}
