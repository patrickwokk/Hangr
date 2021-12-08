import 'package:flutter/material.dart';
import 'package:hangr/models/models.dart';
import 'package:hangr/services/data_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:hangr/views/camera.dart';
import 'package:hangr/views/home.dart';
import 'package:hangr/views/profile.dart';
import 'package:hangr/views/add.dart';
import 'package:hangr/views/search.dart';

class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    Search(),
    AddPicture(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {  
    super.initState();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: false,
      extendBody: true,
      // backgroundColor: Colors.transparent,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
        //to make bottom save route (not used)
        // IndexedStack(
        //   children: const <Widget>[
        //     Home(),
        //     Camera(),
        //     AddPicture(),
        //     Profile(),
        //   ],
        //   index: _selectedIndex,
        // ),
      ),
      bottomNavigationBar:  DotNavigationBar(
        // backgroundColor: Colors.black,
        // enableFloatingNavBar: true,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // dotIndicatorColor: Colors.black,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.home),
            selectedColor: Colors.amber,
          ),

          /// Picture
          DotNavigationBarItem(
            icon: Icon(Icons.search),
            selectedColor: Colors.amber,

          ),

          /// Closet
          DotNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            selectedColor: Colors.amber,
          ),

          /// Profile ONLY
          DotNavigationBarItem(
            icon: Icon(Icons.person),
            selectedColor: Colors.amber,
          ),
          
        ],
      ),
    );
  }
}