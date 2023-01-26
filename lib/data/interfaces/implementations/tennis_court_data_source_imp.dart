import 'dart:convert';
import 'package:prueba_cancha/domain/model/person_model.dart';
import 'package:prueba_cancha/domain/model/reservation_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../../../domain/avaible_court_model.dart';
import '../../../domain/model/reservations_view_model.dart';
import '../tennis_court_data.dart';

import 'package:dio/dio.dart';

class TennisCourtDataSourceImpl implements TennisCourtDataSource {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tennis_court.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE t_court(id INTEGER PRIMARY KEY, t_court_name, cuantityPerDay INTEGER, hoursReservation INTEGER)',
        );
        await database.execute(
          'CREATE TABLE reservations(id INTEGER PRIMARY KEY, t_court_id INTEGER, person_id INTEGER, rainfallRate REAL, scheduled_date TEXT, scheduled_hour INTEGER)',
        );
        await database.execute(
          'CREATE TABLE persons(id INTEGER PRIMARY KEY, person_name TEXT, phone TEXT)',
        );
        await database.rawInsert(
            'INSERT INTO t_Court(t_court_name, cuantityPerDay, hoursReservation) VALUES(?, ?, ?)',
            ["A", 3, 2]);
        await database.rawInsert(
            'INSERT INTO t_Court(t_court_name, cuantityPerDay, hoursReservation) VALUES(?, ?, ?)',
            ["B", 3, 2]);
        await database.rawInsert(
            'INSERT INTO t_Court(t_court_name, cuantityPerDay, hoursReservation) VALUES(?, ?, ?)',
            ["C", 3, 2]);
      },
      version: 1,
    );
  }

  @override
  Future<dynamic> getHttp() async {
    try {
      //If the other auth key didn´t work use this one, exist a limit of 10 uses per day
      // "a8eaca4e-9d26-11ed-bc36-0242ac130002-a8eacae4-9d26-11ed-bc36-0242ac130002"
      const lat = 58.7984;
      const lng = 17.8081;
      const params = 'humidity';
      var dio = Dio();
      dio.options.headers["authorization"] =
          "4eb1bdaa-9d2e-11ed-bc36-0242ac130002-4eb1be0e-9d2e-11ed-bc36-0242ac130002";
      var response = await dio.get(
          'https://api.stormglass.io/v2/weather/point?lat=$lat&lng=$lng&params=$params');
      return response;
    } catch (e) {
      return 0.1;
    }
  }

  @override
  Future<bool> create(Reservation data, PersonModel person) async {
    final db = await initializeDB();
    double posibility = 0.0;
    try {
      var time = await getHttp();
      Map<String, dynamic> jsonMap = json.decode(time.toString());
      var dataMap = jsonMap["hours"];
      var humedity = dataMap[0];
      var humedityList = humedity["humidity"];
      posibility = humedityList["dwd"] as double;
    } catch (e) {
      posibility = 0.1;
    }

    var personId = await db.rawInsert(
        'INSERT INTO persons( person_name, phone) VALUES(?, ?)',
        [person.personName, person.phone]);
    var id = await db.rawInsert(
        'INSERT INTO reservations(t_court_id, person_id, rainfallRate, scheduled_date, scheduled_hour) VALUES(?, ?, ?, ?, ?)',
        [
          data.tCourtId,
          personId,
          posibility,
          data.scheduledDate.toString(),
          data.scheduledHour
        ]);
    return id > 0;
  }

  @override
  Future<int> createPerson(PersonModel data) async {
    final db = await initializeDB();
    var id = await db.rawInsert(
        'INSERT INTO persons( person_name, phone) VALUES(?, ?)',
        [data.personName, data.phone]);
    return id;
  }

  @override
  Future<bool> delete(int reservationId) async {
    final db = await initializeDB();
    var id = await db.delete(
      'reservations',
      where: 'id = ?',
      whereArgs: [reservationId],
    );
    return id > 0;
  }

  @override
  Future<List<ReservationView>> getAll() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'SELECT reservations.id AS id, t_court.t_court_name AS t_court_name, persons.person_name AS person_name, reservations.rainfallRate AS rainfallRate, reservations.scheduled_date AS scheduled_date, reservations.scheduled_hour AS scheduled_hour FROM reservations INNER JOIN t_court ON t_court.id = reservations.t_court_id INNER JOIN persons ON persons.id = reservations.person_id ORDER BY reservations.scheduled_date DESC',
    );

    var result = queryResult.map((e) => ReservationView.fromMap(e)).toList();
    for (var element in result) {
      element.scheduledDate?.add(Duration(hours: element.scheduledHour));
    }
    result.sort(((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!)));
    return result;
    // return result.sort(((a, b) => a.scheduledDate.compareTo(b.scheduledDate)));
  }

  @override
  Future<List<AvaibleTCourt>?> avaibleTCourt(
      int id, String scheduledDate) async {
    final db = await initializeDB();
    List<Map> maps = await db.rawQuery(
        'SELECT reservations.t_court_id AS t_court_id, reservations.scheduled_date AS scheduled_date, reservations.scheduled_hour AS scheduled_hour FROM reservations WHERE reservations.t_court_id = ? AND reservations.scheduled_date = ?',
        [id, scheduledDate]);
    if (maps.isNotEmpty) {
      var result = maps.map((e) => AvaibleTCourt.fromMap(e)).toList();
      return result;
    }
    return null;
  }
}
