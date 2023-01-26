import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

@immutable
class TennisCourt extends Equatable {
  final String name;
  final String? scheduledDate;
  final String? personName;
  final int cuantityPerDay;
  final double rainfallRate;
  final int available;

  const TennisCourt(
      {required this.name,
      this.scheduledDate,
      this.personName,
      required this.cuantityPerDay,
      required this.rainfallRate,
      required this.available});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "scheduledDate": scheduledDate,
      "personName": personName,
      "cuantityPerDay": cuantityPerDay,
      "rainfallRate": rainfallRate,
      "available": available,
    };
  }

  TennisCourt.fromMap(Map<dynamic, dynamic> res)
      : name = res["name"],
        scheduledDate = res["scheduledDate"],
        personName = res["personName"],
        cuantityPerDay = res["cuantityPerDay"],
        rainfallRate = res["rainfallRate"],
        available = res["available"];

  @override
  List<Object?> get props => [
        name,
        scheduledDate,
        personName,
        cuantityPerDay,
        rainfallRate,
        available
      ];
}
