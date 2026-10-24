import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  DBHelper._init();
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cogniq.db');
    return await openDatabase(
      path,
      version: 3, // تم رفع الإصدار من 1 إلى 2
      onCreate: _createTables,
      onUpgrade: _onUpgrade, // جديد: للتعامل مع التحديث لو التطبيق مثبت بالفعل
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE colleges (
        id   INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE exams (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        subject    TEXT NOT NULL,
        date       TEXT NOT NULL,
        color      INTEGER NOT NULL,
        college_id INTEGER,
        user_id    TEXT ,
        FOREIGN KEY (college_id) REFERENCES colleges (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        title      TEXT NOT NULL,
        content    TEXT NOT NULL,
        subject    TEXT NOT NULL,
        created_at TEXT NOT NULL,
        user_id    TEXT

      )
    ''');

    await _seedColleges(db);
  }

  // للأجهزة اللي عندها التطبيق مثبت بنسخة قديمة (version 1)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE colleges (
          id   INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE
        )
      ''');
      await db.execute('ALTER TABLE exams ADD COLUMN college_id INTEGER');
      await _seedColleges(db);
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE exams ADD COLUMN user_id TEXT');
      await db.execute('ALTER TABLE notes ADD COLUMN user_id TEXT');
    }
  }

  Future<void> _seedColleges(Database db) async {
    final colleges = [
      'كلية المختبرات الطبية',
      'كلية دراسات الحاسوب',
      'كلية الهندسة والعمارة',
      'كلية التصميم الداخلي',
      'كلية الفندقة والسياحة',
      'كلية العلوم الإدارية',
    ];
    for (final name in colleges) {
      await db.insert(
        'colleges',
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ---------- Colleges ----------
  Future<List<Map<String, dynamic>>> getColleges() async {
    final db = await database;
    return await db.query('colleges', orderBy: 'name ASC');
  }

  // ---------- Exams ----------
  Future<int> insertExam(Map<String, dynamic> exam) async {
    final db = await database;
    final examWithUserId = {
      ...exam,
      'user_id': _currentUserId, // إضافة معرف المستخدم الحالي
    };
    return await db.insert('exams', examWithUserId);
  }

  Future<List<Map<String, dynamic>>> getExams() async {
    final db = await database;
    return await db.query('exams',
        where: 'user_id = ?', whereArgs: [_currentUserId], orderBy: 'date ASC');
  }

  Future<List<Map<String, dynamic>>> getExamsByCollege(int collegeId) async {
    final db = await database;
    return await db.query(
      'exams',
      where: 'college_id = ?',
      whereArgs: [collegeId],
      orderBy: 'date ASC',
    );
  }

  Future<void> deleteExam(int id) async {
    final db = await database;
    await db.delete('exams', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Notes ----------
  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    final noteWithUserId = {
      ...note,
      'user_id': _currentUserId, // إضافة معرف المستخدم الحالي
    };
    return await db.insert('notes', noteWithUserId);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes',
        where: 'user_id = ?',
        whereArgs: [_currentUserId],
        orderBy: 'created_at DESC');
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
