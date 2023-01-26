import '../../domain/avaible_court_model.dart';
import '../../domain/model/person_model.dart';
import '../../domain/model/reservation_model.dart';
import '../../domain/model/reservations_view_model.dart';

abstract class TennisCourtDataSource {
  Future<List<AvaibleTCourt>?> avaibleTCourt(int id, String scheduledDate);
  Future<bool> create(Reservation data, PersonModel person);
  Future<bool> delete(int reservationId);
  Future<List<ReservationView>> getAll();
  Future<int> createPerson(PersonModel data);
  Future<dynamic> getHttp();
}
