import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/model/event.dart';
import '../../model/eventservice.dart'; // Import EventService

class EnrolledService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EventService _eventService = EventService(); // Initialize EventService

  Future<List<Event>> getEnrolledEvents(String userEmail) async {
    try {
      // Query Firestore to get enrolled events for the given user email
      QuerySnapshot querySnapshot = await _firestore
          .collection(userEmail)
          .get();

      // Initialize a list to store enrolled events
      List<Event> enrolledEvents = [];

      // Iterate through each document in the query snapshot
      for (DocumentSnapshot doc in querySnapshot.docs) {
        // Check if the 'enrolled' field is true
        if (doc['enroll'] == true) {
          // Get the title of the enrolled event
          String eventTitle = doc.id;

          // Retrieve the event from the main events collection by its title
          Event? event = await _eventService.getEventByTitle(eventTitle);

          // If the event is found, add it to the list of enrolled events
          if (event != null) {
            enrolledEvents.add(event);
          }
        }
      }

      return enrolledEvents;
    } catch (e) {
      // Handle error if any
      print('Error retrieving enrolled events: $e');
      return []; // Return an empty list in case of error
    }
  }


  Future<void> modifyEnrollmentStatus(String userEmail, String eventTitle, bool isEnrolled) async {
    try {

      // Check if the event already exists
      Event? existingEvent = await _eventService.getEventByTitle(eventTitle);

      if (existingEvent != null) {
        // If the event exists, update its 'favorite' field
        await _firestore.collection(userEmail).doc(eventTitle).update({
          'enroll': isEnrolled,
        });
      } else {
        // If the event doesn't exist, create it with the 'favorite' field
        await _firestore.collection(userEmail).doc(eventTitle).set({
          'favorite': false,
          'enroll': isEnrolled, // Assuming 'enroll' is another field to be set to false
        });
      }
    } catch (e) {
      await _firestore.collection(userEmail).doc(eventTitle).set({ 'favorite': false,
        'enroll': isEnrolled});
      // Handle error if any
      print('Error modifying favorite status: $e');
    }
  }
  Future<bool> isEventEnrolled(String userEmail, String eventTitle) async {
    try {
      // Check if the event is favorited for the given user
      DocumentSnapshot docSnapshot = await _firestore.collection(userEmail).doc(eventTitle).get();
      if (docSnapshot.exists) {
        return docSnapshot['enroll'] ?? false;
      }
      return false; // Default to false if document doesn't exist
    } catch (e) {
      // Handle error if any
      print('Error checking if event is enroll: $e');
      return false; // Default to false in case of error
    }
  }
}
