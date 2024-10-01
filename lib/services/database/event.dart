import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String name;
  String? musicGenre;
  String eventDetails;
  String date;
  String time;
  String? specials;
  int? tickets;
  double? ticketCost;
  String? instagram;
  String? facebook;
  String? tiktok;
  String? imageUrl; // New field
  String? eventImage;
  String? discount;

  Event(
      {required this.id,
      required this.name,
      required this.musicGenre,
      required this.eventDetails,
      required this.date,
      required this.time,
      this.specials,
      this.tickets,
      this.ticketCost,
      this.instagram,
      this.facebook,
      this.tiktok,
      this.discount,
      this.imageUrl, // New field
      this.eventImage});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
        id: doc.id,
        name: data['name'] ?? '',
        date: data['date'] ?? '',
        time: data['time'] ?? '',
        musicGenre: data['musicGenre'] ?? '',
        specials: data['specials'],
        tickets: data['tickets'],
        discount: data['discount'],
        ticketCost: (data['ticketCost'] ?? 0.0).toDouble(),
        eventDetails: data['eventDetails'] ?? '',
        instagram: data['instagram'],
        facebook: data['facebook'],
        tiktok: data['tiktok'],
        imageUrl: data['imageUrl'], // New field
        eventImage: data["event_image"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'musicGenre': musicGenre,
      'specials': specials,
      'tickets': tickets,
      'ticketCost': ticketCost,
      'discount': discount,
      'eventDetails': eventDetails,
      'instagram': instagram,
      'facebook': facebook,
      'tiktok': tiktok,
      'imageUrl': imageUrl, // New field
      'event_image': eventImage
    };
  }
}
