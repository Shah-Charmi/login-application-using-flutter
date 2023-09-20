import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_application/pages/profile_page.dart';

typedef PhoneNumberCallback = void Function(String phoneNumber);

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final PhoneNumberCallback onPhoneNumberFetched;

  OTPVerificationPage({
    required this.verificationId,
    required this.onPhoneNumberFetched,
  });

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();

  Future<void> signInWithOTP() async {
    String otp = _otpController.text.trim();

    try {
      final authCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      final authResult = await _auth.signInWithCredential(authCredential);

      String phoneNumber = authResult.user?.phoneNumber ?? '';

      widget.onPhoneNumberFetched(phoneNumber);

      navigateToMainScreen();
    } catch (e) {
      print('OTP verification failed: $e');
    }
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
                // Image.asset('assets/images/background_img.jpeg',
                //     height: 300, width: 400, fit: BoxFit.cover),
                const SizedBox(height: 32.0),
                const Text(
                  'Verify OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: signInWithOTP,
                  child: const Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
