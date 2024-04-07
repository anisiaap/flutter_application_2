import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/model/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvents({List<String>? categoryIds}) async {
    List<Event> events = [];

    try {
      Query<Map<String, dynamic>> query = _firestore.collection('Events');

      //Apply where clause if categoryIds are provided
      if (categoryIds != null && categoryIds.isNotEmpty) {
        query = query.where('categoryIds', arrayContainsAny: categoryIds);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      snapshot.docs.forEach((doc) {
        Event event = Event(
          categoryIds: List<int>.from(doc['categoryIds']),
          imagePath: doc['imagePath'],
          title: doc['title'],
          description: doc['description'],
          location: doc['location'],
          duration: doc['duration'],
          punchLine1: doc['punchLine1'],
          punchLine2: doc['punchLine2'],
          qa: List<String>.from(doc['QA']),
          galleryImages: List<String>.from(doc['galleryImages'] ?? []),
          date: (doc['date'] as Timestamp).toDate(),
        );
        events.add(event);
      });

      return events;
    } catch (e) {
      print('Error retrieving events: $e');
      return [];
    }
  }

  Future<Event?> getEventByTitle(String title) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Events')
          .where('title', isEqualTo: title)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        Event event = Event(
          categoryIds: List<int>.from(doc['categoryIds']),
          imagePath: doc['imagePath'],
          title: doc['title'],
          description: doc['description'],
          location: doc['location'],
          duration: doc['duration'],
          punchLine1: doc['punchLine1'],
          punchLine2: doc['punchLine2'],
          qa: List<String>.from(doc['QA']),
          galleryImages: List<String>.from(doc['galleryImages'] ?? []),
          date: (doc['date'] as Timestamp).toDate(),
        );
        return event;
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving event by title: $e');
      return null;
    }
  }
}
