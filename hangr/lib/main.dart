import 'package:flutter/material.dart';
import 'package:hangr/services/data_service.dart';
import 'package:hangr/views/homepage.dart';
import 'models/models.dart';
import 'package:geolocator/geolocator.dart';

import 'views/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangr',
      // theme: ThemeData(
      //   primaryColor: Colors.blue,
      // ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/homepage': (context) => homepage(),
      },
      );
  }
}