import 'dart:async';
import 'package:cowin/district_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  return await openDatabase(
    join(await getDatabasesPath(), 'cowin.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE district(id INTEGER, name TEXT, state TEXT)",
      );
    },
    version: 1,
  );
}

Future<void> insertDistricts(District district) async {
  // Get a reference to the database.
  final Database db = await getDatabase();

  // Insert the Dog into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'district',
    district.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<District>> getDistricts() async {
  // Get a reference to the database.
  final Database db = await getDatabase();

  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('district');

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return District(
      id: maps[i]['id'],
      name: maps[i]['name'],
      state: maps[i]['state'],
    );
  });
}

Future<void> deleteDistrict(District district) async {
  // Get a reference to the database.
  final db = await getDatabase();

  // Remove the Dog from the database.
  await db.delete(
    'district',
    // Use a `where` clause to delete a specific dog.
    where: "id = ?",
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [district.id],
  );
}
