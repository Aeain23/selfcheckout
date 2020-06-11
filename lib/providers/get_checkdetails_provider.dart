import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/check_detail_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetCheckDetailsProvider with ChangeNotifier {
  String getCheckDetails = "api/mPOSXpress/getCheckDetailsbyParentId?headerSK=";

  Future<List<CheckDetailItem>> getCheckDetailsByParentId(
      int headerSyskey) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http.get('$_getUrl$getCheckDetails$headerSyskey');
    print("check url ${'$_getUrl$getCheckDetails$headerSyskey'}");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // print("get data by headersk $data");
      var checkDetails = data['checkdetails'];

      List<CheckDetailItem> _chkList = [];
      if (checkDetails.length > 0) {
        checkDetails.forEach((value) {
          CheckDetailItem item = CheckDetailItem.fromJson(value);
          _chkList.add(item);
        });
        print("get check list in provider ${checkDetails.length}");
      }
      return _chkList;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load getcheckdetails provider');
    }
  }
}
