import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/category.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/model/eventservice.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';

import 'category_widget.dart';
import 'event_widget.dart';
import 'home_page_background.dart';
import 'package:flutter_application_2/ui/homepage/bottom_tabs.dart';

class HomePage extends StatelessWidget {
  final EventService eventService = EventService(); // Initialize EventService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            HomePageBackground(
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
                            "LOCAL EVENTS",
                            style: fadedTextStyle,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "What's Up in Timisoara",
                        style: whiteHeadingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final category in categories)
                                CategoryWidget(category: category)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) {
                          return FutureBuilder<List<Event>>(
                            future: eventService
                                .getEvents(), // Fetch events asynchronously
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child:
                                        CircularProgressIndicator()); // Show loading indicator while fetching data
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final List<Event>? events = snapshot.data
                                    as List<
                                        Event>?; // Retrieve events from snapshot
                                return Column(
                                  children: <Widget>[
                                    if (events != null)
                                      for (final event in events.where((e) =>
                                          e.categoryIds.contains(
                                              appState.selectedCategoryId)))
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetailsPage(
                                                        event: event),
                                              ),
                                            );
                                          },
                                          child: EventWidget(
                                            event: event,
                                          ),
                                        ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                      ),
                    )
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
