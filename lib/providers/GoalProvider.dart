import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/Goal.dart';

class GoalProvider {
  Database db;

  GoalProvider(Database db) {
    this.db = db;
  }

  Future<Goal> insert(Goal goal) async {
    try {
      goal.id = await db.insert(tableGoal, goal.toMap());      
    } catch (e) {
      print(e.toString());
    }
    return goal;
  }

  Future<Iterable<Goal>> getAll() async {
    final List<Map> maps = await db.query(
      tableGoal,
      columns: [columnId, columnName],
    );

    return maps.map((map) => new Goal().fromMap(map)); 
  }
}