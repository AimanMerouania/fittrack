import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/themes/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/scheduled_workout_entity.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../cubit/calendar_cubit.dart';
import 'package:uuid/uuid.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(
        repository: context.read<CalendarRepository>(),
      )..loadMonth(DateTime.now()),
      child: const CalendarView(),
    );
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.neonPurple.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              title: const Text(
                'CALENDRIER',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = DateTime.now();
                  });
                  context.read<CalendarCubit>().selectDay(DateTime.now());
                },
                tooltip: 'Aujourd\'hui',
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Calendrier
                _buildCalendar(),

                const SizedBox(height: 24),

                // Statistiques du mois
                _buildMonthStats(),

                const SizedBox(height: 24),

                // Séances du jour sélectionné
                _buildSelectedDayWorkouts(),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWorkoutDialog(context),
        backgroundColor: AppTheme.neonPurple,
        icon: const Icon(Icons.add),
        label: const Text('PLANIFIER'),
      ),
    );
  }

  Widget _buildCalendar() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,

              // Style
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: AppTheme.neonPurple),
                todayDecoration: BoxDecoration(
                  color: AppTheme.neonBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.neonBlue, width: 2),
                ),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.neonPurple,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: AppTheme.neonGreen,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.white),
              ),

              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: AppTheme.neonBlue),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: AppTheme.neonBlue),
              ),

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                weekendStyle:
                    TextStyle(color: AppTheme.neonPurple.withOpacity(0.7)),
              ),

              // Events
              eventLoader: (day) {
                return context.read<CalendarCubit>().getWorkoutsForDay(day);
              },

              // Callbacks
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<CalendarCubit>().selectDay(selectedDay);
              },

              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
                context.read<CalendarCubit>().loadMonth(focusedDay);
              },

              // Custom builders
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;

                  final workouts = events.cast<ScheduledWorkoutEntity>();
                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: workouts.take(3).map((workout) {
                        return Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: _getWorkoutTypeColor(workout.type),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildMonthStats() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final completedWorkouts =
            state.scheduledWorkouts.where((w) => w.isCompleted).length;
        final totalWorkouts = state.scheduledWorkouts.length;
        final completionRate = totalWorkouts > 0
            ? (completedWorkouts / totalWorkouts * 100).toInt()
            : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.fitness_center,
                  label: 'Séances',
                  value: '$completedWorkouts/$totalWorkouts',
                  color: AppTheme.neonBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Taux',
                  value: '$completionRate%',
                  color: AppTheme.neonGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '5 jours',
                  color: AppTheme.neonPurple,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms);
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayWorkouts() {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (_selectedDay == null) {
          return const SizedBox.shrink();
        }

        final workouts = state.selectedDayWorkouts;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SÉANCES DU ${_selectedDay!.day}/${_selectedDay!.month}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              if (workouts.isEmpty)
                GlassCard(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Aucune séance planifiée',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...workouts
                    .map((workout) => _buildWorkoutCard(workout, context)),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms);
      },
    );
  }

  Widget _buildWorkoutCard(
      ScheduledWorkoutEntity workout, BuildContext context) {
    final color = _getWorkoutTypeColor(workout.type);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showWorkoutOptions(context, workout),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône de type
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  workout.type.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),

              const SizedBox(width: 16),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.workoutName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(
                          '${workout.scheduledDate.hour}:${workout.scheduledDate.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            workout.type.displayName,
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (workout.notes != null && workout.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        workout.notes!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Status
              if (workout.isCompleted)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 20,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: color,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getWorkoutTypeColor(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return Colors.orange;
      case WorkoutType.cardio:
        return AppTheme.neonBlue;
      case WorkoutType.flexibility:
        return AppTheme.neonGreen;
      case WorkoutType.fullBody:
        return AppTheme.neonPurple;
      case WorkoutType.upperBody:
        return const Color(0xFF00F3FF);
      case WorkoutType.lowerBody:
        return Colors.yellow;
      case WorkoutType.custom:
        return Colors.grey;
    }
  }

  void _showAddWorkoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddWorkoutSheet(
        selectedDate: _selectedDay ?? DateTime.now(),
      ),
    );
  }

  void _showWorkoutOptions(
      BuildContext context, ScheduledWorkoutEntity workout) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _WorkoutOptionsSheet(workout: workout),
    );
  }
}

// Sheet pour ajouter une séance
class _AddWorkoutSheet extends StatefulWidget {
  final DateTime selectedDate;

  const _AddWorkoutSheet({required this.selectedDate});

  @override
  State<_AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<_AddWorkoutSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  WorkoutType _selectedType = WorkoutType.strength;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppTheme.neonPurple.withOpacity(0.3),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle, color: AppTheme.neonPurple),
                const SizedBox(width: 12),
                const Text(
                  'Planifier une Séance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nom
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de la séance',
                hintText: 'ex: Programme Pectoraux',
                prefixIcon: Icon(Icons.fitness_center),
              ),
            ),

            const SizedBox(height: 16),

            // Type
            const Text(
              'Type d\'entraînement',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WorkoutType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text('${type.emoji} ${type.displayName}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  selectedColor: AppTheme.neonPurple.withOpacity(0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.neonPurple : Colors.white70,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Heure
            ListTile(
              leading: Icon(Icons.access_time, color: AppTheme.neonBlue),
              title: const Text('Heure'),
              subtitle: Text(_selectedTime.format(context)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                hintText: 'ex: Focus sur la technique',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // Boutons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Veuillez entrer un nom')),
                        );
                        return;
                      }

                      final scheduledDate = DateTime(
                        widget.selectedDate.year,
                        widget.selectedDate.month,
                        widget.selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );

                      final workout = ScheduledWorkoutEntity(
                        id: const Uuid().v4(),
                        workoutId: 'custom-${const Uuid().v4()}',
                        workoutName: _nameController.text,
                        scheduledDate: scheduledDate,
                        type: _selectedType,
                        notes: _notesController.text.isEmpty
                            ? null
                            : _notesController.text,
                      );

                      context.read<CalendarCubit>().scheduleWorkout(workout);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.neonPurple,
                    ),
                    child: const Text('Planifier'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Sheet pour les options d'une séance
class _WorkoutOptionsSheet extends StatelessWidget {
  final ScheduledWorkoutEntity workout;

  const _WorkoutOptionsSheet({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: AppTheme.neonPurple.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.play_arrow, color: AppTheme.neonGreen),
            title: const Text('Démarrer'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Naviguer vers la page de workout actif
            },
          ),
          if (!workout.isCompleted)
            ListTile(
              leading: Icon(Icons.check_circle, color: AppTheme.neonBlue),
              title: const Text('Marquer comme complété'),
              onTap: () {
                context.read<CalendarCubit>().markAsCompleted(workout.id);
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: Icon(Icons.edit, color: AppTheme.neonPurple),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Ouvrir le dialogue de modification
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer'),
            onTap: () {
              context.read<CalendarCubit>().deleteWorkout(workout.id);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
