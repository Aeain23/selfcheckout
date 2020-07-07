import 'package:flutter/material.dart';
import '../models/counter.dart';
import '../models/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  // String station;

  final _getPromationUse = 'api/v5/location/';
  Future<LocationData> fetchLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_getPromationUse',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load location provider');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return LocationData.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load location provider');
    }
  }

  final _getCounter = 'api/v5/getCounterData';
  Future<CounterData> fetchCounter(String station) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_getCounter',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({"nstation": station}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load counter provider');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return CounterData.fromJson(data);
    } else {
      throw Exception('Failed to load counter provider');
    }
  }

  final _getcheckCounter = 'api/v5/checkCounter';
    Counter _counter;
    String getT3;
  Future<Counter> fetchCheckCounter(Counter checkCounter, String station) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_getcheckCounter',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({"counter": checkCounter.toJson(), "code": station}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load counter provider');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("check counte data $data");
      _counter = Counter.fromJson(data);
      // getT3=_counter.t3;
        // print('t3 in station ${_counter.t3}');
      return _counter;
    } else {
      throw Exception('Failed to load counter provider');
    }
  }

  // String get station {
  //   String station;
  //   station = getT3;
  //   if (station == null) {
  //     return "";
  //   } else {
  //     return station;
  //   }
  // }
}
