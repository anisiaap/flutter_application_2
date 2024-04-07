import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/model/eventservice.dart';

class Event {
  String imagePath,
      title,
      description,
      location,
      duration,
      punchLine1,
      punchLine2;
  DateTime date;
  List <int> categoryIds;
  List <String> galleryImages, qa;

  Event(
      {required this.imagePath,
      required this.title,
      required this.description,
      required this.location,
      required this.duration,
      required this.punchLine1,
      required this.punchLine2,
      required this.categoryIds,
      required this.galleryImages,
      required this.qa,
      required this.date});
}

Future<List<Event>> fetchEvents() async {
  var eventsFuture = EventService().getEvents();
  var events = await eventsFuture;
  return events;
}

extension FilterEventsExtension on List<Event> {
  List<Event> whereCategoryId(int selectedCategoryId) {
    return this
        .where((event) => event.categoryIds.contains(selectedCategoryId))
        .toList();
  }
}
