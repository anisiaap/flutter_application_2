import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/event.dart';
import '../../model/guest.dart';
import '../../styleguide.dart';
import '../favorite/favservice.dart';
import '../homepage/map.dart';
import '../userpage/enrolledservice.dart';

class EventDetailsContent extends StatefulWidget {
  @override
  _EventDetailsContentState createState() => _EventDetailsContentState();
}

// Other existing code

class _EventDetailsContentState extends State<EventDetailsContent> {
  final EnrolledService _enrolledService = EnrolledService();
  final FavoriteService _favoriteService = FavoriteService();

  TextEditingController _questionController = TextEditingController();
  List<QuestionAnswer> _userQuestions = [];

  late bool isFavorited = false; // Declare as late to initialize later
  late bool isEnrolled = false; // Declare as late to initialize later

  // Other existing code

  @override
  void initState() {
    super.initState();
    _initializeValues(); // Call the function to initialize values
  }

  Future<void> _initializeValues() async {
    final user = FirebaseAuth.instance.currentUser;
    final event = Provider.of<Event>(context,
        listen: false); // Use listen: false since it's in initState
    if (user != null && event != null) {
      isFavorited = await _favoriteService.isEventFavorited(
          user.email ?? '', event.title);
      isEnrolled =
          await _enrolledService.isEventEnrolled(user.email ?? '', event.title);
      setState(() {}); // Refresh UI after getting initial values
    }
  }

  void _submitQuestion() async {
    final String question = _questionController.text.trim();
    if (question.isNotEmpty) {
      setState(() {
        _userQuestions.add(QuestionAnswer(question: question));
        _questionController.clear();
      });

      // Update the event document in Firestore with the new question
      final user = FirebaseAuth.instance.currentUser;
      final eventTitle = Provider.of<Event>(context, listen: false)?.title;
      if (user != null && eventTitle != null) {
        try {
          // Query Firestore to find the document with matching title
          final querySnapshot = await FirebaseFirestore.instance
              .collection('Events')
              .where('title', isEqualTo: eventTitle)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // Found a document with matching title, update its QA field
            final eventDoc = querySnapshot.docs.first.reference;
            await eventDoc.update({
              'QA': FieldValue.arrayUnion([question]),
            });
            print('Question submitted successfully!');
          } else {
            print('No document found with title: $eventTitle');
          }
        } catch (e) {
          print('Error submitting question: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final event = Provider.of<Event>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final themeData = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                  child: Text(
                    event.title,
                    style: eventWhiteTitleTextStyle,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
                  child: FittedBox(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "-",
                          style: eventLocationTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          event.location,
                          style: eventLocationTextStyle.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.24),
                  child: FittedBox(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "-",
                          style: eventLocationTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.date_range_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(event.date), // Use DateFormat
                          style: eventLocationTextStyle.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 75,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: event.punchLine1,
                        style: punchLine1TextStyle,
                      ),
                      TextSpan(
                        text: event.punchLine2,
                        style: punchLine2TextStyle,
                      ),
                    ]),
                  ),
                ),
                if (event.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      event.description,
                      style: eventLocationTextStyle,
                    ),
                  ),
                if (!event.galleryImages[0].toString().isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, top: 16, bottom: 16),
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                        fontSize: 24,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = Colors.black,
                      ),
                    ),
                  ),
                if (event.galleryImages.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (final galleryImagePath in event.galleryImages)
                          if (Uri.tryParse(galleryImagePath)?.isAbsolute ==
                              true)
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 32),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                child: Image.network(
                                  galleryImagePath,
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          bool newFavoritedStatus =
                              !isEnrolled; // Toggle favorited status
                          await _enrolledService.modifyEnrollmentStatus(
                              "${user?.email ?? ''}",
                              event.title,
                              newFavoritedStatus);
                          setState(() {
                            isEnrolled =
                                newFavoritedStatus; // Update favorited status in UI
                          });
                        },
                        icon: Icon(Icons.directions, color: Colors.white),
                        label: Text(
                          isEnrolled ? 'Unroll' : 'Enroll',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeData.primaryColor),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          bool newEnrolledStatus =
                              !isFavorited; // Toggle enrolled status
                          await _favoriteService.modifyFavoriteStatus(
                              "${user?.email ?? ''}",
                              event.title,
                              newEnrolledStatus);
                          setState(() {
                            isFavorited =
                                newEnrolledStatus; // Update enrolled status in UI
                          });
                        },
                        icon: Icon(Icons.star_border, color: Colors.white),
                        label: Text(
                          isFavorited ? 'Remove' : 'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeData.primaryColor),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Q&A",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      if (event.qa != null &&
                          event.qa
                              .isNotEmpty) // Check if event.qa is not null and not empty
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: event.qa!.map((question) {
                            // Use map to create widgets for each question
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$question",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),

                // User input section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Ask a question:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: "Type your question here...",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _submitQuestion,
                  child: Text("Submit"),
                ),
                // User submitted questions
                if (_userQuestions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        "Your Questions:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      for (final userQuestion in _userQuestions)
                        Text(
                          userQuestion.question,
                          style: TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 300, // Adjust the height as needed
            width: double.infinity, // Take the full width available
            child: MapSample(event: event), // Use any widget you want here
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}

class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({
    required this.question,
    this.answer = '', // Providing a default value for the answer
  });
}
