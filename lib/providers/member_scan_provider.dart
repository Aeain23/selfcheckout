import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/card_usage.dart';
import '../models/payment_data.dart';
import '../models/check_detail_item.dart';
import '../models/check_header_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';

class MemberScanProvider with ChangeNotifier {
  final _getmemberurl = 'api/t2p/QRScan';
  final _getPromationUse = 'api/t2p/promotionUse';
  final _getBusinessDate = 'api/v5/getBusinessDate';
  MemberScan memberScan;
  OrderValue orderValue;
  List<PromoUseValues> promouseList = [];
  String ref;
  Future<MemberScan> fetchMemberScan(String cardNO) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final userid = preferences.getString("userid");
    final username = preferences.getString("username");
    final getReward = preferences.getString("reward");
    final brandName = preferences.getString("brandName");
    final locationCode = preferences.getString("locationCode");
    final locationSyskey = preferences.getString("locationSyskey");
    final counterSyskey = preferences.getString("counterSyskey");
    var system = preferences.getString("name");
     final ref= preferences.getString("ref");
         print("fetch member use scan testing for ref >>>>>>>>>>>: $ref");
    Map data = json.decode(system);
    final branch = preferences.getString("branch");
    final response = await http
        .post('$_getUrl$_getmemberurl',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "userid": userid,
              "systemSetup": data,
              "userName": username,
              "brandName": brandName,
              "locationCode": locationCode,
              "branchName": branch,
              "t2pEndpoint": getReward,
              "posVersion": "2.1.37",
              "counterSK": counterSyskey,
              "locationsyskey": locationSyskey,
              "cardNo": cardNO,
              "uniqueLocCode": locationCode,
              "reqSource": "CardNotPresent",
              "cardRefCode": ref
             
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load stock_provider');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      memberScan = MemberScan.fromJson(data);
      return memberScan;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch scan');
    }
  }

  MemberScan getMemberScan() {
    return memberScan;
  }

  Future<PromotionUse> fetchPromotionUse(AccountValue accval,
      List<CheckDetailItem> check, CheckHeader checkHeader, ) async {
    print("Header in provider of t15 ${checkHeader.t15}");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final userid = preferences.getString("userid");
    final username = preferences.getString("username");
    final getReward = preferences.getString("reward");
    final brandName = preferences.getString("brandName");
    final locationCode = preferences.getString("locationCode");
    final counterSyskey = preferences.getString("counterSyskey");
    final ref = preferences.getString("ref");
    
    print("fetch promotion use scan testing for ref >>>>>>>>>>>: $ref");
    var system = preferences.getString("name");
    Map data = json.decode(system);
    final branch = preferences.getString("branch");
    final response = await http
        .post('$_getUrl$_getPromationUse',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "accountValue": {
                "identityNumber": accval.identityNumber,
                "primaryPhoneNumber": accval.primaryPhoneNumber,
                "passportNumber": accval.passportNumber,
                "isSetAccountPIN": accval.isSetAccountPIN,
                "primaryPhoneType": accval.primaryPhoneType,
                "accountNumber": accval.accountNumber,
                "accountLevel": accval.accountLevel,
                "accountType": accval.accountType,
                "lastName": accval.lastName,
                "birthDate": accval.birthDate,
                "titleName": accval.titleName,
                "firstName": accval.firstName,
                "emailAddress": accval.emailAddress,
                "accountStatus": accval.accountStatus,
                "gender": accval.gender
              },
              "headerData": checkHeader,
              "detailsData": check,
              "userid": userid,
              "systemSetup": data,
              "userName": username,
              "brandName": brandName,
              "branchName": branch,
              "t2pEndpoint": getReward,
              "posVersion": "2.1.38",
              "preCalOrSubmit": "precal",
              "counterSK": counterSyskey,
              "uniqueLocCode": locationCode,
              "serialDataList": [],
              "reqSource": "CardNotPresent",
              "cardRefCode": ref
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to promotion use');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      orderValue = OrderValue.fromJson(data['orderValue']);
      // print(orderValue);
      var promouseValues = data['promoUseValues'];

      List<PromoUseValues> list = [];
      promouseValues.forEach((value) {
        PromoUseValues item = PromoUseValues.fromJson(value);
        list.add(item);
      });
      promouseList = list;

      return PromotionUse.fromJson(data);
    } else {
      throw Exception('Failed to load fetch promotion used precal!!');
    }
  }

  OrderValue getOrderValue() {
    return orderValue;
  }

  List<PromoUseValues> getPromoUseValues() {
    return promouseList;
  }

  Future<PromotionUse> fetchPromotionUseSubmit(
      List<CheckDetailItem> checklist,
      CheckHeader checkHeader,
      MemberScan memberScan,
      OrderValue orderValue,
      List<PromoUseValues> promouseValueList,
      CardUsage cardUsage,
      List<PaymentData> paymentDataList,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final userid = preferences.getString("userid");
    final username = preferences.getString("username");
    final getReward = preferences.getString("reward");
    final brandName = preferences.getString("brandName");
    final locationCode = preferences.getString("locationCode");
    final counterSyskey = preferences.getString("counterSyskey");
    final branch = preferences.getString("branch");
    var system = preferences.getString("name");
   final ref = preferences.getString("ref");
   
    print("citycash widget and insert card screen promotion use submit testing for ref >>>>>>>>>>>: $ref");
    Map data = json.decode(system);
    var ordValue = orderValue.toJson();
    var p = json.encode(paymentDataList);

    print("Payment Data List : $paymentDataList");
    print("Payment Data List : $p");
    final response = await http
        .post('$_getUrl$_getPromationUse',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "orderValue": ordValue,
              "coupons": [],
              "promotionUses": promouseValueList,
              "rewards": [],
              "accountValue": {
                "emailAddress": memberScan.accountValue.emailAddress,
                "gender": memberScan.accountValue.gender,
                "identityNumber": memberScan.accountValue.identityNumber,
                "primaryPhoneNumber":
                    memberScan.accountValue.primaryPhoneNumber,
                "passportNumber": memberScan.accountValue.passportNumber,
                "primaryPhoneType": memberScan.accountValue.primaryPhoneType,
                "isSetAccountPIN": memberScan.accountValue.isSetAccountPIN,
                "birthDate": memberScan.accountValue.birthDate,
                "accountNumber": memberScan.accountValue.accountNumber,
                "titleName": memberScan.accountValue.titleName,
                "accountStatus": memberScan.accountValue.accountStatus,
                "accountLevel": memberScan.accountValue.accountLevel,
                "accountType": memberScan.accountValue.accountType,
                "lastName": memberScan.accountValue.lastName,
                "firstName": memberScan.accountValue.firstName
              },
              "headerData": checkHeader,
              "detailsData": checklist,
              "userid": userid,
              "systemSetup": data,
              "userName": username,
              "brandName": brandName,
              "branchName": branch,
              "t2pEndpoint": getReward,
              "posVersion": "2.1.38",
              "preCalOrSubmit": "submit",
              "paymentDataList": paymentDataList,
              "paymentDataListNew": paymentDataList,
              "counterSK": counterSyskey,
              "uniqueLocCode": locationCode,
              "serialDataList": [],
              "reqSource": "CardNotPresent",
              "cardRefCode": ref
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load promotionused submit exception');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return PromotionUse.fromJson(data);
    } else {
      throw Exception('Failed to load promotionused submit');
    }
  }

  Future fetchBusinessData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_getBusinessDate',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load Business Date');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load Business Date');
    }
  }
}
