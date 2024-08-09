import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:jahnhalle/services/database/event.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Event>> streamEvents() {
    return _db.collection('events').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<Drink>> streamDrinks() {
    return _db.collection('drinks').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList(),
    );
  }
}
