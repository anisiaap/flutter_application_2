import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:flutter_application_2/ui/userpage/fancybutton.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'package:flutter_application_2/ui/userpage/fav_background.dart';
import 'package:flutter_application_2/ui/userpage/fancybutton.dart';
import 'package:flutter_application_2/ui/homepage/event_widget.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:flutter_application_2/ui/userpage/bottom_tabs.dart';
import 'package:flutter_application_2/ui/user/login.dart'; // Import the login page
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for logout

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var userEvents = []; // Initialize userEvents with an empty list
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
                            "User Details",
                            style: fadedTextStyle,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                                    (Route<dynamic> route) => false, // Removes all routes from the stack
                              );
                            },
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          // Display user's email
                          Text(
                            "Email: ${user?.email ?? ''}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: <Widget>[
                              FancyButton(title: "Post Events", location: "Create new events", duration: "Tap to post", page:"PostPage"),
                              SizedBox(height: 20),
                              FancyButton(title: "Past Events", location: "View past events", duration: "Tap to view",page:"PastPage"),
                              SizedBox(height: 20),
                              FancyButton(title: "Going To", location: "Events you're attending", duration: "Tap to view",page:"EnrolledPage"),
                              SizedBox(height: 20),
                              FancyButton(title: "About Us", location: "", duration: "Tap for more",page:"AboutPage"),
                            ],
                          ),
                        ],
                      ),
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

class UserEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Event Details"),
      ),
      body: Center(
        child: Text("User Event Details Page"),
      ),
    );
  }
}
