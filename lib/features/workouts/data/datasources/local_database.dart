import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fittrack.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // 0 or 1
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Table Workouts
    await db.execute('''
CREATE TABLE workouts (
  id $idType,
  name $textType,
  date TEXT,
  duration $intType,
  notes $textType,
  isTemplate $boolType
)
''');

    // Table WorkoutExercises
    await db.execute('''
CREATE TABLE workout_exercises (
  id $idType,
  workoutId $textType,
  exerciseId $textType,
  exerciseName $textType,
  notes $textType,
  FOREIGN KEY (workoutId) REFERENCES workouts (id) ON DELETE CASCADE
)
''');

    // Table Sets
    await db.execute('''
CREATE TABLE sets (
  id $idType,
  workoutExerciseId $textType,
  setIndex $intType,
  weight $realType,
  reps $intType,
  isCompleted $boolType,
  FOREIGN KEY (workoutExerciseId) REFERENCES workout_exercises (id) ON DELETE CASCADE
)
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
