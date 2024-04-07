import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/event.dart';
import 'package:flutter_application_2/styleguide.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'package:flutter_application_2/ui/search/search_background.dart';
import 'package:flutter_application_2/ui/homepage/event_widget.dart';
import 'package:flutter_application_2/ui/event_details/event_details_page.dart';
import 'package:flutter_application_2/ui/search/bottom_tabs.dart';

import '../../model/eventservice.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Event>> filteredEventsFuture;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    setState(() {
      filteredEventsFuture = filterEvents('');
    });
  }

  Future<List<Event>> filterEvents(String query) async {
    var events = await EventService().getEvents();
    return events
        .where((event) => event.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search Events',
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (query) {
            setState(() {
              filteredEventsFuture = filterEvents(query);
            });
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          SearchPageBackground(
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
                          "",
                          style: fadedTextStyle,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FutureBuilder<List<Event>>(
                      future: filteredEventsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Column(
                            children: <Widget>[
                              for (final event in snapshot.data!)
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
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
