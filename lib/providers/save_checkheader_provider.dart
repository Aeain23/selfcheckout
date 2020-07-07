import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/check_header_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/check_detail_item.dart';
import '../models/save_check_header.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SaveCheckHeaderProvider with ChangeNotifier {
  double total = 0.0;
  String _getUserName, _getLocationSyskey, _getCounterSyskey, _getUserId;
  String _getUserSyskey;
  final _saveHeader = 'api/mPOSXpress/saveCheckHeader';
  SaveCheckHeader saveCheckHeader;
  var chkHeader;
  var result;
  List<CheckDetailItem> _checkdtl = [];
  String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
  String formattedTime = DateFormat("HHmmss").format(DateTime.now());
  Future<SaveCheckHeader> fetchSaveHeader(
      double totalAmount, List<CheckDetailItem> checkDetailList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final _getLocationCode = preferences.getString("locationCode");
    _getUserName = preferences.getString("username");
    _getUserId = preferences.getString("userid");
    _getLocationSyskey = preferences.getString("locationSyskey");
    _getCounterSyskey = preferences.getString("counterSyskey");
    _getUserSyskey = preferences.getString("userSyskey");
    print("username $_getUserSyskey");
    print("locationSyskey $_getLocationSyskey");
    print("counterSyskey $_getCounterSyskey");
    total = totalAmount;
    final response = await http.post('$_getUrl$_saveHeader',
        headers: {
          "Accept": "application/json",
          'Content-type': 'application/json',
        },
        body: json.encode({
          "headerData": header,
          "detailsData": checkDetailList.map((e) => e.toJson()).toList(),
          "deletedData": [],
          "uniqueLocCode": _getLocationCode,
          "topupreqdtls": [],
          "topupresphdr": {},
          "topupdelreqdtls": []
        }));
    if (response.statusCode == 200) {
      Map<String,dynamic> data = json.decode(response.body);
      print('respond data ${response.body}');
      var chkDetails = data['chkDetails'];
      var header = data['chkHeader'];
      var result=data['result'];
      print("check detail $chkDetails");
      print("check header $chkHeader");
      print("table ${data['table']}");
      chkHeader = CheckHeader.fromJson(header);
      result=Result.fromJson(result);
      if (checkDetailList.length > 0) {
        _checkdtl = [];
        chkDetails.forEach((value) {
          CheckDetailItem item = CheckDetailItem.fromJson(value);
          _checkdtl.add(item);
        });
        return SaveCheckHeader(
            checkHeader: chkHeader,
            checkDetailItem: _checkdtl,
            checkHeaderList:null,
            table:null ,
            payment: null,
            t2psale: null,
            result: result,
            topupresphdr: null,
            topupreqdtl: null,
            activeShiftExist: null);
      }
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load save header provider');
    }

    return null;
  }
  CheckHeader get getHeader {
    return chkHeader;
  }
  List<CheckDetailItem> get getCheckDetailList {
    return _checkdtl;
  }

  dynamic get header {
    dynamic header;
    header = chkHeader;
    if (header == null) {
      return {
        "id": 0,
        "sysKey": 0,
        "createddate": formattedDate,
        "modifieddate": formattedDate,
        "userid": _getUserId,
        "username": _getUserName,
        "ref5": 0,
        "savestatus": 1,
        "recordstatus": 1,
        "t1": "",
        "t3": formattedDate,
        "t4": formattedDate,
        "t5": formattedDate,
        "t6": formattedDate,
        "t7": formattedDate,
        "t11": formattedTime,
        "t12": "",
        "t13": "",
        "t2": "",
        "t10": "",
        "n35": "1",
        "n16": _getLocationSyskey,
        "n23": "0",
        "n26": _getCounterSyskey,
        "userSysKey": _getUserSyskey,
        "n10": total,
        "n5": total,
        "n30": 1,
        "n36": 1,
        "locid": _getLocationSyskey,
        "n19": 0,
        "n20": 0
      };
    } else
      return header;
  }

  final _voidCheckHeader = 'api/mPOSXpress/voidCheckHeader';
  Future<VoidCheckHeader> fetchVoidCheckHeader(CheckHeader checkHeader) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_voidCheckHeader',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({"id": checkHeader.id}))
        .catchError((onError) {
      print(onError);
      throw Exception("Fail to void  $onError");
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return VoidCheckHeader.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to void');
    }
  }

  final skip = 'api/mPOSXpress/skipMember';
  Future<VoidCheckHeader> skipMember(CheckHeader checkHeader) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$skip',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({"id": checkHeader.id}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to skip member');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return VoidCheckHeader.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to skip member');
    }
  }
}
