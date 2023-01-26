import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

@immutable
class Reservation extends Equatable {
  final int tCourtId;
  final int personId;
  final double? rainfallRate;
  final DateTime? scheduledDate;
  final int scheduledHour;

  const Reservation({
    required this.tCourtId,
    required this.personId,
    this.rainfallRate,
    this.scheduledDate,
    required this.scheduledHour,
  });

  Map<String, dynamic> toMap() {
    return {
      "t_court_id": tCourtId,
      "person_id": personId,
      "rainfallRate": rainfallRate,
      "scheduled_date": scheduledDate,
      "scheduled_hour": scheduledHour,
    };
  }

  Reservation.fromMap(Map<dynamic, dynamic> res)
      : tCourtId = res["t_court_id"],
        personId = res["person_id"],
        rainfallRate = res["rainfallRate"],
        scheduledDate = res["scheduled_date"],
        scheduledHour = res["scheduled_hour"];

  @override
  List<Object?> get props =>
      [tCourtId, personId, rainfallRate, scheduledDate, scheduledHour];
}
