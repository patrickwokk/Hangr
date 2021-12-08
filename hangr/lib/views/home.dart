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
      double temperature = _response.tempInfo.temperature.toDouble();
      if( temperature <= 10.99){
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        if (_response != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.09),
              Center(
                child: Container(
                  height: 120,
                  width: size.width * 0.86,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFF5F5F5),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 10,
                          spreadRadius: 4,
                          offset: Offset(0.0, 8.0)),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 12,
                        top: 15,
                        child: Image.network(_response.iconUrl),
                      ),

                      Positioned(
                        left: 108,
                        top: 40,
                        child: Text(
                          /*_response.tempInfo.temperature.isNegative?
                          '${_response.tempInfo.temperature.floor()}°'
                          :*/'${_response.tempInfo.temperature.ceil()}°',
                          style: TextStyle(fontSize: 43),
                        ),
                      ),

                      Positioned(
                        right: 15,
                        top: 24,
                        child: Text(
                          _response.weatherInfo.description,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                      ),

                      Positioned(
                        right: 125,
                        top: 76,
                        child: Image.asset(
                          "assets/png/placeholder.png",
                          height: 20,
                          width: 20,
                        ),
                      ),

                      Positioned(
                        right: 14,
                        top: 80,
                        child: _currentAddress == null
                        ?Text("Location Unkown")
                        :Text(_currentAddress,
                        style: TextStyle(
                              fontSize: 11,
                            )
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Padding(
                padding: EdgeInsets.only(left: 30,bottom: 20, top: 10),
                child: Text(
                  "Top picks for you",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 29,),
          child: SizedBox(
            height: 250,
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
                      // color: Colors.amber,
                      margin: const EdgeInsets.only(right: 11),
                      height: 200,
                      width: 190,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(File(_items[index].imagePath,))),
                    ),
                  );
                }
                else {
                  return SizedBox.shrink();
                }
              }),
          ),
        ),
        SizedBox(height: 35,),
        Center(
          child: SizedBox(
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
                      BorderRadius.all(Radius.circular(8)))),
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
        ),
      ],
    );
  }
}