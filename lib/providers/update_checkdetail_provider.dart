import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/check_detail_item.dart';
import '../models/check_header_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateCheckDetailProvider with ChangeNotifier {
  final updateCheckDetails = "api/mPOSXpress/updateCheckDetails";
  Future<bool> updateCheckDetailsForDelete(
      CheckHeader checkHeader, CheckDetailItem checkDetailItem) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    print("Url $_getUrl");
    print("check header ${checkHeader.syskey}");
    print("check detail ${checkDetailItem.syskey}");
    final response = await http.post('$_getUrl$updateCheckDetails',
        headers: {
          "Accept": "application/json",
          'Content-type': 'application/json',
        },
        body: json.encode(
            {"headerData": checkHeader, "checkdetails": checkDetailItem}));
    print("response ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("response delete data $data");
      bool state = data['state'];
      return state;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load delete provider');
    }
  }
}
