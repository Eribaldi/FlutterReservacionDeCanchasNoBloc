import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

@immutable
class ReservationView extends Equatable {
  final int? id;
  final String tCourtName;
  final String personName;
  final double? rainfallRate;
  final DateTime? scheduledDate;
  final int scheduledHour;

  const ReservationView({
    this.id,
    required this.tCourtName,
    required this.personName,
    this.rainfallRate,
    this.scheduledDate,
    required this.scheduledHour,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "t_court_name": tCourtName,
      "person_name": personName,
      "rainfallRate": rainfallRate,
      "scheduled_date": scheduledDate,
      "scheduled_hour": scheduledHour,
    };
  }

  ReservationView.fromMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        tCourtName = res["t_court_name"],
        personName = res["person_name"],
        rainfallRate = res["rainfallRate"],
        scheduledDate = DateTime.parse(res["scheduled_date"]),
        scheduledHour = res["scheduled_hour"];

  @override
  List<Object?> get props =>
      [id, tCourtName, personName, rainfallRate, scheduledDate, scheduledHour];
}
