import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prueba_cancha/domain/model/person_model.dart';
import 'package:prueba_cancha/domain/model/reservation_model.dart';
import '../../data/interfaces/implementations/tennis_court_data_source_imp.dart';
import 'list.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  AddScreenState createState() => AddScreenState();
}

class AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  int tCourtId = 0;
  int personId = 0;
  double? rainfallRate;
  String scheduledDate = "";
  int scheduledHour = 0;
  bool available = false;
  String personName = "";
  String phone = "";

  @override
  Widget build(BuildContext context) {
    var courts = ["A", "B", "C"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añade un reserva'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !courts.contains(value.toUpperCase()) ||
                      value.length > 1) {
                    return 'Inserte una cancha válida';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre de cancha: A - B - C',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.toUpperCase() == "A") {
                      tCourtId = 1;
                    } else if (value.toUpperCase() == "B") {
                      tCourtId = 2;
                    } else if (value.toUpperCase() == "C") {
                      tCourtId = 3;
                    }
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserte un fecha';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Fecha de reserva: yyyy/MM/dd',
                ),
                onChanged: (value) {
                  setState(() {
                    scheduledDate = value;
                  });
                },
              ),
              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(),
                validator: (value) {
                  if (value != null) {
                    var hour = int.tryParse(value);
                    if (hour != null) {
                      if (hour > 22) {
                        return 'La hora debe ser de 0 a 22';
                      }
                    }
                  }
                  if (value == null || value.isEmpty) {
                    return 'Inserte la hora de la reserva';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Hora de la reserva: 0 a 22',
                ),
                onChanged: (value) {
                  setState(() {
                    scheduledHour = int.tryParse(value) ?? 0;
                  });
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserte un nombre';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre de quién reserva',
                ),
                onChanged: (value) {
                  setState(() {
                    personName = value;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserte un número de teléfono';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Número telefónico de contacto',
                ),
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool canSave = true;
                    var date = DateFormat('yyyy/MM/dd').parse(scheduledDate);
                    var listCourt = await TennisCourtDataSourceImpl()
                        .avaibleTCourt(tCourtId, date.toString());
                    if (listCourt != null) {
                      if (listCourt.length > 2) {
                        canSave = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Limite de reservas por día de esa cancha')),
                        );
                      } else {
                        List<int> hoursList = [];
                        for (var item in listCourt) {
                          hoursList.add(item.scheduledHour);
                          hoursList.add(item.scheduledHour + 1);
                          hoursList.add(item.scheduledHour + 2);
                        }
                        if (hoursList.contains(scheduledHour)) {
                          canSave = false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Esa hora no está disponible para ese día')),
                          );
                        }
                      }
                    }
                    if (canSave) {
                      await TennisCourtDataSourceImpl()
                          .create(
                              Reservation(
                                tCourtId: tCourtId,
                                personId: personId,
                                rainfallRate: rainfallRate,
                                scheduledDate:
                                    DateTime(date.year, date.month, date.day),
                                scheduledHour: scheduledHour,
                              ),
                              PersonModel(personName: personName, phone: phone))
                          .whenComplete(() => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ListScreen()),
                              ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Datos Incorrectos')),
                    );
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
