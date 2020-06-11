import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/payment_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentTypeProvider with ChangeNotifier {
  String paymentType = 'api/mPOSXpress/readPaymentType';
  List<PaymentType> list = [];
  Future<List<PaymentType>> fetchPaymentType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$paymentType',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({}))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load payment type provider');
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var paytypelist = data['paymentTypeList'];
      if (paytypelist.length > 0) {
        paytypelist.forEach((value) {
          PaymentType item = PaymentType.fromJson(value);
          print("payment type $item");
          list.add(item);
        });
        print("pay type list in provider ${list.toString()}");
        return list;
      }
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception("Fail to load payment type provider");
    }
    return null;
  }
}
