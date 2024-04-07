import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/model/event.dart';
import '../../model/eventservice.dart'; // Import EventService

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EventService _eventService = EventService(); // Initialize EventService

  Future<List<Event>> getFavoriteEvents(String userEmail) async {
    try {

      // Query Firestore to get favorite events for the given user email
      QuerySnapshot querySnapshot = await _firestore
          .collection(userEmail)
          .get();

      // Initialize a list to store favorite events
      List<Event> favoriteEvents = [];

      // Iterate through each document in the query snapshot
      for (DocumentSnapshot doc in querySnapshot.docs) {
        // Check if the 'favorite' field is true
        if (doc['favorite'] == true) {
          // Get the title of the favorite event
          String eventTitle = doc.id;

          // Retrieve the event from the main events collection by its title
          Event? event = await _eventService.getEventByTitle(eventTitle);

          // If the event is found, add it to the list of favorite events
          if (event != null) {
            favoriteEvents.add(event);
          }
        }
      }

      return favoriteEvents;
    } catch (e) {
      // Handle error if any
      print('Error retrieving favorite events: $e');
      return []; // Return an empty list in case of error
    }
  }
  Future<void> modifyFavoriteStatus(String userEmail, String eventTitle, bool isFavorite) async {
    try {

      // Check if the event already exists
      Event? existingEvent = await _eventService.getEventByTitle(eventTitle);

      if (existingEvent != null) {
        // If the event exists, update its 'favorite' field
        await _firestore.collection(userEmail).doc(eventTitle).update({
          'favorite': isFavorite,
        });
      } else {
        // If the event doesn't exist, create it with the 'favorite' field
        await _firestore.collection(userEmail).doc(eventTitle).set({
          'favorite': isFavorite,
          'enroll': false, // Assuming 'enroll' is another field to be set to false
        });
      }
    } catch (e) {
      await _firestore.collection(userEmail).doc(eventTitle).set({'favorite': isFavorite,
        'enroll': false});
      // Handle error if any
      print('Error modifying favorite status: $e');
    }
  }
  Future<bool> isEventFavorited(String userEmail, String eventTitle) async {
    try {
      // Check if the event is favorited for the given user
      DocumentSnapshot docSnapshot = await _firestore.collection(userEmail).doc(eventTitle).get();
      if (docSnapshot.exists) {
        return docSnapshot['favorite'] ?? false;
      }
      return false; // Default to false if document doesn't exist
    } catch (e) {
      // Handle error if any
      print('Error checking if event is favorited: $e');
      return false; // Default to false in case of error
    }
  }
}
