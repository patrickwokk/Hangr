import 'package:flutter/material.dart';
import 'package:hangr/models/models.dart';
import 'package:hangr/services/data_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

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
  final _dataService = DataService();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  WeatherResponse _response;

  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }


  //handle fetching weather
  void _search() async {
    final response = await _dataService.getWeather(_currentPosition.latitude.toString(), _currentPosition.longitude.toString());
    setState(() => _response = response);
  }

  @override
  void initState() {  
    super.initState();
    _getCurrentLocation();
    _search();
  }

    //get current location
    _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  //get current address 
  _getAddressFromLatLng() async {
  try {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
    Placemark place = p[0];
    setState(() {
      _currentAddress =
      "${place.locality}, ${place.postalCode}";
    });
  } catch (e) {
    print(e);
  }
}

  //UI
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_response != null)
              Column(
                children: [
                  Image.network(_response.iconUrl),
                  Text(
                    /*_response.tempInfo.temperature.isNegative?
                    '${_response.tempInfo.temperature.floor()}°'
                    :*/'${_response.tempInfo.temperature.ceil()}°',
                    style: TextStyle(fontSize: 40),
                  ),
                  Text(_response.weatherInfo.description),
                  

                  if (_currentAddress != null)
                    Text(_currentAddress),
                ],
              ),

            ElevatedButton(onPressed: _search, child: Text('Fetch Weather'))
          ],
        ),
          ),
        ),
      bottomNavigationBar:  DotNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _handleIndexChanged,
          // dotIndicatorColor: Colors.black,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Colors.purple,
            ),

            /// Picture
            DotNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              selectedColor: Colors.pink,
            ),

            /// Closet
            DotNavigationBarItem(
              icon: Icon(Icons.search),
              selectedColor: Colors.orange,
            ),

            /// Profile ONLY
            DotNavigationBarItem(
              icon: Icon(Icons.person),
              selectedColor: Colors.teal,
            ),
            
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab { home, camera, search, profile }