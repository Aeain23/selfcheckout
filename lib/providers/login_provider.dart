import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  final login = 'api/v5/login';
  SystemSetup systemSetup;
  Future<Login> fetchLogin(String userId, String password,
      String locationSyskey, String counterSyskey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final _locationCode = preferences.getString("locationCode");
    print(counterSyskey);
    print(locationSyskey);

    print('location code $_locationCode');
    final response = await http
        .post('$_getUrl$login',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "userid": userId,
              "passcode": password,
              "locationsyskey": locationSyskey,
              "counterSK": counterSyskey,
              "usePasscode": "1",
              "uniqueLocCode": _locationCode
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load stock_provider');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      systemSetup = SystemSetup.fromJson(data['systemSetup']);
      print(" login data: $systemSetup");
      return Login.fromJson(data);
    } else {
      throw Exception('Failed to load login');
    }
  }

  SystemSetup getSystemSetup() {
    return systemSetup;
  }
}

class SlipNoProvider with ChangeNotifier {
  final getSlip = "api/mPOSXpress/getSlipNo";
  Future<String> fetchSlipNo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final counterSyskey = preferences.getString("counterSyskey");
    print('counter syskey $counterSyskey');
    final response = await http
        .post('$_getUrl$getSlip',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "counterSK": counterSyskey,
              "isRefund": false,
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load slip provider');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(" slip data: $data");
      return data;
    } 
      else if(response.statusCode == 404){
      return null;
    }
    else {
      throw Exception('Failed to load slip no');
    }
  }
}
