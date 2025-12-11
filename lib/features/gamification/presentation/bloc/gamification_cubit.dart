import 'package:flutter_bloc/flutter_bloc.dart';
import 'gamification_state.dart';
import '../../domain/entities/user_stats.dart';

class GamificationCubit extends Cubit<GamificationState> {
  GamificationCubit() : super(GamificationState.initial());

  void addXP(int amount) {
    int newXP = state.stats.currentXP + amount;
    int currentLevel = state.stats.level;
    int maxXP = state.stats.maxXP;
    String title = state.stats.title;
    bool leveledUp = false;

    // Level Up Logic
    while (newXP >= maxXP) {
      newXP -= maxXP;
      currentLevel++;
      maxXP = (maxXP * 1.2).round(); // Increase difficulty by 20% each level
      leveledUp = true;
    }

    // Assign Titles based on level
    if (currentLevel >= 5) title = "Athlète";
    if (currentLevel >= 10) title = "Guerrier";
    if (currentLevel >= 20) title = "Titan";
    if (currentLevel >= 50) title = "Légende";

    emit(state.copyWith(
      stats: UserStats(
        level: currentLevel,
        currentXP: newXP,
        maxXP: maxXP,
        title: title,
      ),
      hasLeveledUp: leveledUp,
    ));
    
    // Reset the "leveled up" flag after a short delay so it doesn't trigger repeatedly
    if (leveledUp) {
      Future.delayed(const Duration(seconds: 1), () {
        emit(state.copyWith(hasLeveledUp: false));
      });
    }
  }
}
