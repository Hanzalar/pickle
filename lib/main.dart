import 'package:flutter/material.dart';
import 'score_model.dart';  // Update with your actual import path.
import 'score_view.dart';  // Update with your actual import path.
import 'profile_model.dart';
import 'profile_view.dart';
import 'community_model.dart';
import 'community_view.dart';
import 'checkin_model.dart';
import 'checkin_view.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScoreModel()),
        ChangeNotifierProvider(create: (context) => ProfileModel()),
        ChangeNotifierProvider(create: (context) => CommunityModel()),
        ChangeNotifierProvider(create: (context) => CheckinModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyAppStateful(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyAppStateful extends StatefulWidget {
  @override
  _MyAppStateful createState() => _MyAppStateful();
}

class _MyAppStateful extends State<MyAppStateful> {
  int _selectedPage = 0;
  final _pageOptions = [
    ScoreView(),
    ProfileView(),
    CommunityView(),
    CheckinView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.scoreboard),
            label: 'Scoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Check In',
          ),
        ],
      ),
    );
  }
}