import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:self_check_out/models/topup_request_detail_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/check_detail_item.dart';
import '../models/stock_item.dart';
import 'package:http/http.dart' as http;

class StockProvider with ChangeNotifier {
  final _getstockbyCodeurl = "api/v5/getstockbyCode";
  StockItem stock;
  Future<StockItem> fetchStockbybarCode(String barcode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final _getLocationCode = preferences.getString("locationCode");
    final _getLocationSyskey = preferences.getString("locationSyskey");
    final _getCounterSyskey = preferences.getString("counterSyskey");
    final _getUserId = preferences.getString("userid");
    final _getCounterCode = preferences.getString("getCounter");
    print("get Counter code $_getCounterCode");
    print("get user id $_getUserId");
    var system = preferences.getString("name");
    Map data = json.decode(system);
    print('calling stockprovider');
    final response = await http
        .post('$_getUrl$_getstockbyCodeurl',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "digit": "13",
              "orgCode": null,
              "code": barcode,
              "locationsyskey": _getLocationSyskey,
              "binsk": "0",
              "priceBandsk": "0",
              "isAuthenticated": "false",
              "uniqueLocCode": _getLocationCode,
              "epinDomain": "",
              "counterSK": _getCounterSyskey,
              "userid": _getUserId,
              "countercode": _getCounterCode,
              "systemSetup": data
            }))
        .catchError((onError) {
      print(onError);
      throw Exception('Failed to load stock_provider');
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var chkDtls = data['chkDtls'];
      var mobilestockList = data['mobilestocklist'];
      List<TopUpRequestDetailData> _mobilestklist = [];
      if (mobilestockList.length > 0) {
        mobilestockList.forEach((value) {
          TopUpRequestDetailData detaildata =
              TopUpRequestDetailData.fromJson(value);
          _mobilestklist.add(detaildata);
        });
      }
      if (chkDtls.length > 0) {
        List<CheckDetailItem> _checkdtl = [];
        chkDtls.forEach((value) {
          CheckDetailItem item = CheckDetailItem.fromJson(value);
          _checkdtl.add(item);
        });
        return StockItem(mobilestocklist: _mobilestklist, chkDtls: _checkdtl);
      } else {
        List<TopUpRequestDetailData> _mobilestklist = [];
        List<CheckDetailItem> _checkdtl = [];
        return StockItem(mobilestocklist: _mobilestklist, chkDtls: _checkdtl);
      }
    } else if (response.statusCode == 404) {
      return stock;
    } else {
      throw Exception('Failed to load stock_provider');
    }
  }

  List<CheckDetailItem> chkdtlsList = [];

  addstocktoList(CheckDetailItem chkdtls) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUserName = preferences.getString("username");
    final _getUserid = preferences.getString("userid");
    bool _checkflag = false;
    //String _samebarcode;
    chkdtls.userid = _getUserid;
    chkdtls.username = _getUserName;
    print("object $_getUserName and $_getUserid");
    if (chkdtlsList.length == 0) {
      chkdtlsList.add(chkdtls);
      print('Length ${chkdtlsList[0].t3}');
    } else {
      for (final i in chkdtlsList) {
        if (chkdtls.t1 == i.t1 &&
            chkdtls.n31 != 70 &&
            i.n42 != 1520 &&
            i.n42 != 2015 &&
            i.n42 != 202520 &&
            i.n42 != 152520 &&
            !(i.t1.length == 13 && i.t1.substring(0, 2) == "55") &&
            i.recordStatus != 4) {
          _checkflag = true;
          i.n8 += 1;
          double amount = 0;

          if (i.n19 != 0) {
            amount = (i.n14 * i.n8) - (i.n19 * i.n8);
          } else {
            amount = i.n14 * i.n8;
          }

          i.n34 = amount;
        }
        // if (chkdtls.t1 == i.t1) {
        //   if (chkdtls.t1.length == 13 && chkdtls.t1.substring(0, 2) == "55") {
        //     _checkflag = false;
        //   } else if (i.recordStatus == 4 && chkdtls.t1!=i.t1) {
        //     _checkflag = false;
        //   } else if (i.recordStatus == 4 &&
        //       chkdtls.t1.length == 13 &&
        //       chkdtls.t1.substring(0, 2) == "55") {
        //     _checkflag = false;
        //   } else {
        //     _checkflag = true;
        //   }

        //   _samebarcode = chkdtls.t1;
        //   break;
        // } else {
        //   _checkflag = false;
        // }
      }
      if (!_checkflag) {
        chkdtlsList.add(chkdtls);
      }
      //   if (_checkflag) {
      //     for (final i in chkdtlsList) {
      //       if (_samebarcode == i.t1) {
      //         i.n8++;
      //         i.n34 += i.n14;
      //         break;
      //       }
      //     }
      //   } else {
      //     chkdtlsList.add(chkdtls);
      //   }
    }
    notifyListeners();
  }

  List<CheckDetailItem> getchkdtlsList() {
    print(
        "Stock provider in get check list of length is :${chkdtlsList.length}");
    return chkdtlsList;
  }

  int getchkdetlsCount() {
    int count = 0;
    for (int i = 0; i < chkdtlsList.length; i++) {
      if (chkdtlsList[i].recordStatus != 4) {
        count++;
      }
    }
    return count;
  }

  changeChkdtlsList(List<CheckDetailItem> list) {
    chkdtlsList = [];
// List<CheckDetailItem> newchkdtl = [];
//    for(int i=0;i<chkdtlsList.length;i++){
//     for(int j=0;j<list.length;j++){
//       if(chkdtlsList[i].syskey!=list[j].syskey){
//         newchkdtl.add(chkdtlsList[i]);
//       }
//     }
//    }
    //  chkdtlsList = newchkdtl;
    list.forEach((item) {
      chkdtlsList.add(item);
    });
    print("Change check detail list of length :$chkdtlsList");
    notifyListeners();
  }

  removechkdtls(CheckDetailItem chkdtls) {
    chkdtlsList.remove(chkdtls);
    notifyListeners();
  }

  prepareCheckDetail(List<CheckDetailItem> item) {
    chkdtlsList = [];
    for (final i in item) {
      chkdtlsList.add(i);
    }

    notifyListeners();
  }

  double get qty {
    double count = 0.0;
    for (int i = 0; i < chkdtlsList.length; i++) {
      // count +=chkdtlsList[i].n8;
      if (chkdtlsList[i].recordStatus == 4) {
        count = count;
      } else {
        if (chkdtlsList[i].t1.length == 13 &&
            chkdtlsList[i].t1.substring(0, 2) == "55") {
          // chkdtlsList[i].n8 = 1;
          count += 1;
        } else {
          count += chkdtlsList[i].n8;
        }
      }
      count = count;
    }
    return count;
  }

  double get totalAmount {
    double total = 0.0;
    for (int i = 0; i < chkdtlsList.length; i++) {
      if (chkdtlsList[i].recordStatus == 4) {
        total = total;
      } else {
        total += chkdtlsList[i].n34;
      }
      total = total;
    }
    return total;
  }

  set totalAmount(index) {
    notifyListeners();
  }

  // double get stockTotalAmt {
  //   var total = 0.0;
  //   for (int i = 0; i < chkdtlsList.length; i++) {
  //     if (chkdtlsList[i].t3 == "Large Plastic Bag" ||
  //         chkdtlsList[i].t3 == "Small Plastic Bag") {
  //       total = total;
  //     } else {
  //       total += chkdtlsList[i].n34;
  //     }
  //   }
  //   return total;
  // }

  // set stockTotalAmt(index) {
  //   notifyListeners();
  // }
}
