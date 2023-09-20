import 'package:country_picker/country_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_application/pages/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'otp_verification_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _openGmailLoginPage() async {
    const url = 'https://accounts.google.com/login';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Gmail login page';
    }
  }

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  final TextEditingController _phoneNumberController = TextEditingController();

  void verifyPhoneNumber() async {
    String countryCode = selectedCountry.phoneCode;
    String phoneNumber = _phoneNumberController.text.trim();
    String phoneNumberWithCountryCode = '+$countryCode$phoneNumber';

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumberWithCountryCode,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        navigateToMainScreen();
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Phone verification failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              verificationId: verificationId,
              onPhoneNumberFetched: (String phoneNumber) {},
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationPage(
              verificationId: verificationId,
              onPhoneNumberFetched: (String phoneNumber) {},
            ),
          ),
        );
      },
    );
  }

  void navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // const SizedBox(height: 16.0),
                // Image.asset(
                //   'assets/images/background_img.jpeg',
                //   height: 200,
                //   width: 200,
                // ),
                const SizedBox(height: 32.0),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: verifyPhoneNumber,
                  child: const Text('Send OTP'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _handleSignIn();
                    _openGmailLoginPage();
                  },
                  child: Text('Sign in with Gmail'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
