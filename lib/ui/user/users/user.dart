import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';

import 'package:flutter_application_2/ui/userpage/fav_background.dart';
import 'package:flutter_application_2/ui/homepage/event_widget.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:flutter_application_2/ui/userpage/bottom_tabs.dart';
import 'package:flutter_application_2/ui/user/login.dart'; // Import the login page
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for logout
class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  List<Event> goingEvents = [];
  List<Event> postedEvents = [];
  List<Event> pastEvents = [];
  List<Event> moreEvents = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    user = _auth.currentUser;
    await fetchUserEvents();
  }

  Future<void> fetchUserEvents() async {
    // Fetch events for each category and update the respective lists
    // Example:
    // goingEvents = await fetchGoingEvents();
    // postedEvents = await fetchPostedEvents();
    // pastEvents = await fetchPastEvents();
    // moreEvents = await fetchMoreEvents();

    // Simulated data for demonstration


    setState(() {}); // Update the UI after fetching data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: [
          buildEventSection('Going', goingEvents),
          buildEventSection('Posted', postedEvents),
          buildEventSection('Past', pastEvents),
          buildEventSection('More', moreEvents),
        ],
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }

  Widget buildEventSection(String title, List<Event> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetailsPage(event: event),
                  ),
                );
              },
              child: EventWidget(event: event),
            );
          },
        ),
      ],
    );
  }
}
