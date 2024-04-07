import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'package:flutter_application_2/ui/favorite/fav_background.dart';
import 'package:flutter_application_2/ui/homepage/event_widget.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:flutter_application_2/ui/favorite/bottom_tabs.dart';
import 'package:flutter_application_2/model/eventservice.dart'; // Import EventService

class PastPage extends StatelessWidget {
  final EventService eventService = EventService(); // Initialize EventService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            FavePageBackground(
              screenHeight: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Past Events",
                            style: fadedTextStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Event>>(
                      future: eventService.getEvents(), // Fetch events asynchronously
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final events = snapshot.data; // Retrieve events from snapshot
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: <Widget>[
                                for (final event in events!)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsPage(event: event),
                                        ),
                                      );
                                    },
                                    child: EventWidget(
                                      event: event,
                                    ),
                                  )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
