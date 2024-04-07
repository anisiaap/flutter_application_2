import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:provider/provider.dart';

import '../event_details/event_details_page.dart';
import '../homepage/event_widget.dart';
import 'enrolledservice.dart';

class EnrolledPage extends StatefulWidget {
  @override
  _EnrolledPageState createState() => _EnrolledPageState();
}

class _EnrolledPageState extends State<EnrolledPage> {
  final user = FirebaseAuth.instance.currentUser;
  final EventController _eventController = EventController();
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final EnrolledService _enrolledService = EnrolledService(); // Initialize EnrolledService
  late List<Event> _events = []; // Initialize the events list to an empty list

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _fetchEnrolledEvents();
  }

  void _fetchEnrolledEvents() async {
    // Fetch events from enrolled service
    final events = await _enrolledService.getEnrolledEvents(user?.email ?? '');

    setState(() {
      _events = events; // Assign fetched events to the _events variable
      for (final event in events) {
        // Convert Event to CalendarEventData
        final calendarEvent = CalendarEventData(
          date: event.date,
          title: event.title,
          description: event.description,
        );
        _eventController.add(calendarEvent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrolled Events'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Calendar View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Month View
                  SizedBox(
                    height: 300, // Fixed height for MonthView
                    child: CalendarControllerProvider(
                      controller: _eventController,
                      child: MonthView(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Event List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _events.isEmpty // Check if events list is empty
                        ? Center(child: CircularProgressIndicator()) // Show loading indicator if events are being fetched
                        : Column(
                      children: <Widget>[
                        for (final event in _events)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsPage(event: event),
                                ),
                              );
                            },
                            child: EventWidget(
                              event: event,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
