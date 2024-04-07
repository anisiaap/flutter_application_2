import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'package:flutter_application_2/ui/favorite/fav_background.dart';
import 'package:flutter_application_2/ui/homepage/event_widget.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:flutter_application_2/ui/favorite/bottom_tabs.dart';
import 'package:flutter_application_2/model/eventservice.dart';


import 'favservice.dart'; // Import FavoriteService

class FavePage extends StatelessWidget {
  final FavoriteService favoriteService = FavoriteService(); // Initialize FavoriteService

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                            "FAVORITE EVENTS",
                            style: fadedTextStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Event>>(
                      future: favoriteService.getFavoriteEvents("${user?.email ?? ''}"), // Retrieve favorite events add email from instance
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final favoriteEvents = snapshot.data; // Retrieve favorite events from snapshot
                          if (favoriteEvents == null || favoriteEvents.isEmpty) {
                            return Center(child: Text('No favorite events'));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: <Widget>[
                                  for (final event in favoriteEvents)
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
