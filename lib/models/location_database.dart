import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import './user_location.dart';

const dbName = 'location.db';
const sqlCreateTablePath = 'assets/sql/create.sql';
const sqlInsertPath = 'assets/sql/insert.sql';
const sqlGetAllPath = 'assets/sql/get_all.sql';

class LocationDatabase {
  final Database _db;

  LocationDatabase({required Database db}) : _db = db;

  // This should be called externally to create the database.
  static Future<LocationDatabase> open() async {
    // this will attempt to open the database and create the database if it doesn't exist
    final Database db = await openDatabase(dbName, version: 1,
        onCreate: (Database db, int version) async {
      // You can find this query in assets/sql/create.
      // It creates the location_entries table if it does not already exist.
      String query = await rootBundle.loadString(sqlCreateTablePath);
      await db.execute(query);
    });

    return LocationDatabase(db: db);
  }

  void close() async {
    await _db.close();
  }

  Future<List<UserLocation>> getLocations() async {
    String query = await rootBundle.loadString(sqlGetAllPath);
    List<Map> locationEntries = await _db.rawQuery(query);
    List<UserLocation> locations = [];
    for (final entry in locationEntries) {
      locations.add(UserLocation.fromJson(Map<String, dynamic>.from(entry)));
    }
    return locations;
  }

  void insertLocation(UserLocation location) async {
    await _db.transaction((txn) async {
      final String query = await rootBundle.loadString("assets/sql/insert.sql");
      final List<dynamic> rawInsertParameters = [
        location.latitude,
        location.longitude,
        location.city,
        location.state,
        location.zip
      ];
      await txn.rawInsert(query, rawInsertParameters);
    });
  }

  void deleteLocation(UserLocation location) async {
    final String query = await rootBundle.loadString("assets/sql/delete.sql");

    await _db.transaction((txn) async {
      await txn.rawDelete(query, [location.city, location.state, location.zip]);
    });
  }
}
