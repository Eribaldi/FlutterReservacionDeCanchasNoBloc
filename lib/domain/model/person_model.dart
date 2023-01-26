import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

@immutable
class PersonModel extends Equatable {
  final String? personName;
  final String? phone;

  const PersonModel({this.personName, this.phone});

  Map<String, dynamic> toMap() {
    return {"person_name": personName, "phone": phone};
  }

  PersonModel.fromMap(Map<dynamic, dynamic> res)
      : personName = res["person_name"],
        phone = res["phone"];

  @override
  List<Object?> get props => [personName, phone];
}
