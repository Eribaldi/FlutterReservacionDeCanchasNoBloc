import 'package:flutter/material.dart';

import '../../data/interfaces/implementations/tennis_court_data_source_imp.dart';
import '../../domain/avaible_court_model.dart';
import '../../domain/model/reservations_view_model.dart';
import 'add.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late TennisCourtDataSourceImpl handler;
  Future<List<ReservationView>>? _todo;

  @override
  void initState() {
    super.initState();
    handler = TennisCourtDataSourceImpl();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        _todo = getAll();
      });
    });
  }

  Future<List<AvaibleTCourt>?> avaibleTCourt(
      int id, String scheduledDate) async {
    return await handler.avaibleTCourt(id, scheduledDate);
  }

  Future<List<ReservationView>> getAll() async {
    return await handler.getAll();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _todo = getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservación de canchas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScreen()),
          );
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ReservationView>>(
        future: _todo,
        builder: (BuildContext context,
            AsyncSnapshot<List<ReservationView>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final items = snapshot.data ?? <ReservationView>[];
            return Scrollbar(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever),
                      ),
                      key: ValueKey<String>(items[index].personName),
                      onDismissed: (DismissDirection direction) async {
                        await handler.delete(items[index].id ?? 0);
                        setState(() {
                          items.remove(items[index]);
                        });
                      },
                      child: Card(
                          child: ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        leading: Text(items[index].tCourtName),
                        title: Text(items[index].personName),
                        subtitle: Text(
                            "${items[index].scheduledDate?.year}-${items[index].scheduledDate?.month}-${items[index].scheduledDate?.day} de: ${items[index].scheduledHour} a ${items[index].scheduledHour + 2}"),
                        trailing: Text(items[index].rainfallRate.toString()),
                      )),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
