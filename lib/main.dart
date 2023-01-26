import 'package:flutter/material.dart';
import 'package:prueba_cancha/presentation/views/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de canchas',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const ListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


