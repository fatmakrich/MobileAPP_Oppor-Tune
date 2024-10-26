import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Home_Page.dart';
import 'Landing_Page.dart';
import 'SigninScreen.dart';
import 'SignupWidget.dart';
import 'jobList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => FirstPage(),
        '/signin': (context) => SigninScreen(),
        '/signup': (context) => SignupWidget(),
        '/hr_signup': (context) => HrRepresentativeSignupScreen(),
        '/job_seeker_signup': (context) => JobSeekerSignupScreen(),
        '/home': (context) => HomePage(isUser: true),
        '/company_home': (context) => JobList(),
      },
    );
  }
}
