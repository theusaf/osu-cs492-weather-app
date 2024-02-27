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
      // TODO #1: Instead of an empty string, use the rootBundle.loadstring to load the insert query from the sql file
      // Read through the query in insert.sql to see how it looks. What do the ? represent?
      String query = "";

      // TODO #2: Update the parameters to pull latitude, longitude, city, state, and zip from location
      List<dynamic> rawInsertParameters = [];
      await txn.rawInsert(query, rawInsertParameters);
    });
  }

  void deleteLocation(UserLocation location) async {
    // TODO #3: Build this using insertLocation as a guide
    // create the sql file with the proper code for deleting
    // add the sql file to the assets in the pubspec.yaml
    // add the constant to the path at the top of this file with the other constants

    // Use the transaction function: rawDelete rather than rawInsert
    // use the city, state, and zip to dictate the proper deletion

    // For the next TODO, look in location.dart.
  }
}
