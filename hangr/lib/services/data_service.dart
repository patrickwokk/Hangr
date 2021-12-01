import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:hangr/models/models.dart';
import 'package:http/http.dart' as http;



class DataService {

  
  Future<WeatherResponse> getWeather(String lat, String lon) async {
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    // api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&appid={API key}

    final queryParameters = {
      // 'q': city,
      'lat': lat,
      'lon': lon,
      'appid': '01e57d239145a9dce9b0786a3599314d',
      'units': 'metric'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}