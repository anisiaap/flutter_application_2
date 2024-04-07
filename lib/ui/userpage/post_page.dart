import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? _image;
  String? _imageUrl;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController punchLine1Controller = TextEditingController();
  TextEditingController punchLine2Controller = TextEditingController();
  List<int> categoryIds = [0];
  DateTime? _selectedDate;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    if (_image != null) {
      // Upload image to Firebase Storage
      Reference referenceDirImages =
          FirebaseStorage.instance.ref().child('images');
      Reference referenceImageToUpload = referenceDirImages
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      try {
        await referenceImageToUpload.putFile(_image!);
        _imageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submit() async {
    if (_image == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and date')),
      );
      return;
    }

    // Convert categoryIds list to a map with boolean values

    // Construct dataToSave map
    Map<String, dynamic> dataToSave = {
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'duration': durationController.text,
      'punchLine1': punchLine1Controller.text,
      'punchLine2': punchLine2Controller.text,
      'categoryIds': categoryIds,
      'imagePath': _imageUrl,
      'QA': [""], // Initialize with an empty array for Q&A
      'galleryImages': [
        ""
      ], // Initialize with an empty array for gallery images
      'date': _selectedDate, // Use the selected date
    };



    // Add Gallery Images
    // Note: You can add image URLs to the 'galleryImages' array similarly

    await FirebaseFirestore.instance.collection('Events').add(dataToSave);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Page"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Select Image from Camera'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Select Image from Gallery'),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text("Food"),
              value: categoryIds.contains(2),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(2);
                  } else {
                    categoryIds.remove(2);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text("Music"),
              value: categoryIds.contains(1),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(1);
                  } else {
                    categoryIds.remove(1);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text("Culture"),
              value: categoryIds.contains(6),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(6);
                  } else {
                    categoryIds.remove(6);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text("Politics"),
              value: categoryIds.contains(5),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(5);
                  } else {
                    categoryIds.remove(5);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text("Health"),
              value: categoryIds.contains(4),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(4);
                  } else {
                    categoryIds.remove(4);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text("Sports"),
              value: categoryIds.contains(3),
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    categoryIds.add(3);
                  } else {
                    categoryIds.remove(3);
                  }
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Duration'),
            ),
            TextField(
              controller: punchLine1Controller,
              decoration: InputDecoration(labelText: 'Punch Line 1'),
            ),
            TextField(
              controller: punchLine2Controller,
              decoration: InputDecoration(labelText: 'Punch Line 2'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
