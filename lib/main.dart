import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_application/pages/phone_number.dart';
import 'package:login_application/screens/splash_screen.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyCmA6cib9kP5-GUGNyt2FETT_N9MTLrVRw",
//       appId: "1:191944359226:android:aeeb7df2109172339b6403",
//       messagingSenderId: "191944359226",
//       projectId: "login-application-5a55c",
//     ),
//   );
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
