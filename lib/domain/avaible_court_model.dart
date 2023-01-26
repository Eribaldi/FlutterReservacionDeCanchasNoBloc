import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

@immutable
class AvaibleTCourt extends Equatable {
  final int? tCourtId;
  // final int? nReservations;
  final String scheduledDate;
  final int scheduledHour;

  const AvaibleTCourt(
      {
      // required this.nReservations,
      required this.tCourtId,
      required this.scheduledDate,
      required this.scheduledHour});

  Map<String, dynamic> toMap() {
    return {
      // "cuantity": nReservations,
      "t_court_id": tCourtId,
      "scheduled_date": scheduledDate,
      "scheduled_hour": scheduledHour
    };
  }

  AvaibleTCourt.fromMap(Map<dynamic, dynamic> res)
      :
        // nReservations = res["cuantity"],
        tCourtId = res["t_court_id"],
        scheduledDate = res["scheduled_date"],
        scheduledHour = res["scheduled_hour"];

  @override
  List<Object?> get props => [
        // nReservations,
        tCourtId, scheduledDate, scheduledHour
      ];
}
