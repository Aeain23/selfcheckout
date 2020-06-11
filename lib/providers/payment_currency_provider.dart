import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/payment_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentCurrencyProvider with ChangeNotifier {
  List<Currency> currencyList = [];
  String _currency = "api/mPOSXpress/getCurrency";
  Future<List<Currency>> fetchCurrency() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_currency',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({}))
        .catchError((onError) {
      throw Exception("Fail currency service call! $onError");
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var currency = data['currencyList'];
      if (currency.length > 0) {
        currency.forEach((value) {
          Currency item = Currency.fromJson(value);
          currencyList.add(item);
        });
      }
      return currencyList;
    } 
      else if(response.statusCode == 404){
      return null;
    }
    else {
      throw Exception('Fail currency service call!');
    }
  }
}
