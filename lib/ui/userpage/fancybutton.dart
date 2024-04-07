import 'package:flutter/material.dart';
import 'package:flutter_application_2/styleguide.dart';

import 'about_page.dart';
import 'enrolled_page.dart';
import 'post_page.dart';
import 'past_page.dart';


class FancyButton extends StatelessWidget {
  final String title;
  final String location;
  final String duration;
  final String page;

  const FancyButton({
    Key? key,
    required this.title,
    required this.location,
    required this.duration,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the specified page based on the 'page' variable
        if (page == "PostPage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage()),
          );

        }
        if (page == "PastPage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PastPage()),
          );

        }
        if (page == "EnrolledPage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EnrolledPage()),
          );

        }
        if (page == "AboutPage") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );

        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                title,
                style: eventTitleTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  if(location=="Create new events")
                    Icon(Icons.add),
                  if(location=="View past events")
                    Icon(Icons.arrow_back),
                  if(location=="Events you're attending")
                    Icon(Icons.location_on),
                  if(location=="App description")
                    Icon(Icons.apps),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    location,
                    style: eventLocationTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                duration.toUpperCase(),
                textAlign: TextAlign.right,
                style: eventLocationTextStyle.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
