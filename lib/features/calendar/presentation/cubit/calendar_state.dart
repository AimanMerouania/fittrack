part of 'calendar_cubit.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  final CalendarStatus status;
  final List<ScheduledWorkoutEntity> scheduledWorkouts;
  final List<ScheduledWorkoutEntity> selectedDayWorkouts;
  final DateTime selectedMonth;
  final DateTime? selectedDay;
  final String? errorMessage;

  CalendarState({
    this.status = CalendarStatus.initial,
    this.scheduledWorkouts = const [],
    this.selectedDayWorkouts = const [],
    DateTime? selectedMonth,
    this.selectedDay,
    this.errorMessage,
  }) : selectedMonth = selectedMonth ?? DateTime.now();

  CalendarState copyWith({
    CalendarStatus? status,
    List<ScheduledWorkoutEntity>? scheduledWorkouts,
    List<ScheduledWorkoutEntity>? selectedDayWorkouts,
    DateTime? selectedMonth,
    DateTime? selectedDay,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      scheduledWorkouts: scheduledWorkouts ?? this.scheduledWorkouts,
      selectedDayWorkouts: selectedDayWorkouts ?? this.selectedDayWorkouts,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        scheduledWorkouts,
        selectedDayWorkouts,
        selectedMonth,
        selectedDay,
        errorMessage,
      ];
}
