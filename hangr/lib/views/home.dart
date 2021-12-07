import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hangr/models/models.dart';
import 'package:hangr/models/models_picture.dart';
import 'package:hangr/services/data_service.dart';
import 'package:hangr/views/picture_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _dataService = DataService();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  String _season = "";

  WeatherResponse _response;

  List<PhotoItem> _items = [];

  void _search() async {
    final response = await _dataService.getWeather(_currentPosition.latitude.toString(), _currentPosition.longitude.toString());
    setState(() { 
      _response = response;
      double temperature = _response.tempInfo.temperature;
      if( temperature <= 10){
        _season = "Winter";
      }
      else if (11<= temperature && temperature <=15){
        _season = "Spring";
      }
      else if (16<= temperature && temperature <=22){
        _season = "Fall";
      }
      else if (23<= temperature){
        _season = "Summer";
      }
      print(_season);
      });
  }

  @override
  void initState() {  
    super.initState();
    _getCurrentLocation();
    _search();
    decodePref();
  }

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

  decodePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedItemsJson = prefs.getString('items'); // read

    final List<dynamic> itemsDeserialized = json.decode(savedItemsJson); //decode
    setState(() {
        _items = itemsDeserialized.map((json) => PhotoItem.fromJson(json)).toList(); // part of decode (mapping process)
    });
  
    print(_items);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
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
        SizedBox(height: 10,),
        Container(
          height: 199,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            itemBuilder: (context,index){
              if(_items[index].season == _season){
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PictureDetails(
                            imagePath: _items[index].imagePath, 
                            name: _items[index].name, 
                            category:_items[index].category, 
                            season: _items[index].season,),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      // color: Colors.amber,
                    ),
                    child: Image.file(File(_items[index].imagePath)),
                              ),
                );
              }
              else {
                return null;
              }
            }),
        ),
        SizedBox(height: 10,),
        SizedBox(
          width: size.width * 0.3,
          height: size.height * 0.0657,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                splashFactory: NoSplash.splashFactory,
                primary: Colors.amber, // background
                onPrimary: Colors.white, // foreground
                shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(29)))),
            onPressed: () {
              _search();
            },
            child: const Text(
                "Refresh",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ),
      ],
    );
  }
}