import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_application/pages/phone_number.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  ProfilePage({this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  DateTime? _selectedDate; // Variable to store the selected date
  String? _selectedGender; // Variable to store the selected gender

  // Function to save user data to Firestore
  Future<void> saveUserData() async {
    String name = _nameController.text;
    String dob = _dobController.text;
    String gender = _selectedGender ?? ""; // Use the selected gender variable
    String aboutMe = _aboutMeController.text;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'name': name,
        'dob': dob,
        'gender': gender,
        'aboutMe': aboutMe,
      });

      AlertDialog(
        actions: [Text("data saved")],
      );
    } catch (error) {
      AlertDialog(
        actions: [Text("Error saving user data: $error")],
      );
      // print('Error saving user data: $error');
    }
  }

  Future<void> _signOutAndNavigateToPhoneAuth(BuildContext context) async {
    try {
      // Sign out the user using Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Navigate to the phone authentication screen (PhoneNumberPage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneNumberPage()),
      );
    } catch (error) {
      print('Error signing out: $error');
      // Handle sign-out error, if needed
    }
  }

  Future<void> _saveProfileData() async {
    // Replace this with your logic to save the data to Firebase or your backend
    bool isDataSaved = true; // Change to false if the data saving fails

    // Show an alert dialog based on the result
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Profile'),
          content: Text(isDataSaved
              ? 'Profile saved successfully'
              : 'Failed to save profile'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/background_img.jpeg',
            fit: BoxFit.cover, // Cover the entire screen
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _aboutMeController,
                  decoration: InputDecoration(
                    labelText: 'About Me',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  maxLines: 3, // Allow multiline input
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    saveUserData();
                    _saveProfileData();
                  },
                  child: Text('Save Profile'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _signOutAndNavigateToPhoneAuth(context);
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
