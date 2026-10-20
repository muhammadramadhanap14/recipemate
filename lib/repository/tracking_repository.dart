import 'package:sqflite/sqflite.dart';
import '../models/model/user_tracking.dart';
import 'recipemate_database_helper.dart';

class TrackingRepository {
  final RecipemateDatabaseHelper _dbHelper = RecipemateDatabaseHelper.instance;

  Future<int> insertUserTracking(UserTracking tracking) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'user_tracking_entity',
      tracking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserTracking?> getActiveTracking(String nik, String todayStr) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'user_tracking_entity',
      where: 'user_create = ? AND tracking_status = 0 AND start_date LIKE ?',
      whereArgs: [nik, '$todayStr%'],
      orderBy: 'idTrc DESC',
      limit: 1,
    );

    if (results.isEmpty) return null;

    final sessionMap = results.first;
    final idTrc = sessionMap['idTrc'] as int;

    final detailsResult = await db.query(
      'tracking_details',
      where: 'idTrc = ?',
      whereArgs: [idTrc],
    );

    final details = detailsResult.map((d) => DetailTracking.fromJson(d)).toList();

    return UserTracking.fromMap(sessionMap, details: details);
  }

  Future<void> insertDetailTracking(int idTrc, DetailTracking detail) async {
    final db = await _dbHelper.database;
    final map = detail.toMap();
    map['idTrc'] = idTrc;
    await db.insert(
      'tracking_details',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateFinishTracking(int idTrc, double endLat, double endLng, String endDateStr) async {
    final db = await _dbHelper.database;
    await db.update(
      'user_tracking_entity',
      {
        'finish_date': endDateStr,
        'position_finish_lat': endLat,
        'position_finish_lng': endLng,
        'tracking_status': 1,
      },
      where: 'idTrc = ?',
      whereArgs: [idTrc],
    );
  }
}
