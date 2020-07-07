import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/payment_data.dart';
import '../models/terminal_result_message.dart';
import '../models/card_usage.dart';
import '../models/check_detail_item.dart';
import '../models/check_header_item.dart';
import 'dart:convert';
import '../models/member_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardUsageProvider with ChangeNotifier {
  final _cardusage = 'api/t2p/cardUsage';
  String _getUserName,
      _getLocationSyskey,
      _getCounterSyskey,
      _getBrandname,
      _getLocationCode,
      _getUserId,
      ref;
  Future<CardUsage> fetchCardUsage(
    MemberScan memberScan,
    CheckHeader checkHeader,
    int total,
    int value,
    var cardorpoint,
    int remainvalue,
  ) async {
    int amount;
    var previousBalance;
    if (cardorpoint == 0) {
      cardorpoint = memberScan.cardBalance[0].creditCode;
      amount = value;
      previousBalance = memberScan.cardBalance[0].creditAmount;
    } else {
      cardorpoint = memberScan.cardBalance[1].creditCode;
      amount = remainvalue;
      previousBalance = memberScan.cardBalance[1].creditAmount;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final getReward = preferences.getString("reward");
    _getBrandname = preferences.getString("brandName");
    _getUserName = preferences.getString("username");
    _getUserId = preferences.getString("userid");
    _getLocationSyskey = preferences.getString("locationSyskey");
    _getCounterSyskey = preferences.getString("counterSyskey");
    _getLocationCode = preferences.getString("locationCode");
    var system = preferences.getString("name");
    ref = preferences.getString("ref");

    print("fetch member scan testing for ref >>>>>>>>>>>: $ref");
    Map data = json.decode(system);
    final branch = preferences.getString("branch");
    final response = await http
        .post('$_getUrl$_cardusage',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "userid": _getUserId,
              "systemSetup": data,
              "userName": _getUserName,
              "brandName": _getBrandname,
              "branchName": branch,
              "t2pEndpoint": getReward,
              "posVersion": "2.1.38",
              "counterSK": _getCounterSyskey,
              "locationsyskey": _getLocationSyskey,
              "accountNumber": memberScan.accountValue.accountNumber,
              "creditCode": cardorpoint,
              "creditAmt": amount.round(),
              "previousBalance": previousBalance,
              "headerData": checkHeader,
              "cardStatus": memberScan.cardStatus,
              "cardType": memberScan.cardType,
              "uniqueLocCode": _getLocationCode,
              "cardNo": memberScan.cardNumber,
              "reqSource": "CardNotPresent",
              "cardRefCode": ref
            }))
        .catchError((onError) {
      throw Exception('Failed to load card usage');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
 print("Card usage return $data");
      return CardUsage.fromJson(data);
    } else {
      throw Exception('Failed to load card usage');
    }
  }
}

class CardTypeListProvider with ChangeNotifier {
  List<CardTypeList> cardTypelist = [];
  final  _cardType = "api/t2p/getIncludeStatus";
  // Future<List<CardTypeList>> fetchCardTypeList(
    Future<dynamic> fetchCardTypeList(
    String cardTypeId
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    final response = await http
        .post('$_getUrl$_cardType',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({"cardTypeID":cardTypeId}))
        .catchError((onError) {
      throw Exception("Fail cardtype service call! $onError");
    });
    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      final data = json.decode(response.body);
       print(data);
      // if (data.length > 0) {
      //   data.forEach((value) {
      //     CardTypeList item = CardTypeList.fromJson(value);
      //     // print("card type $item");
      //     cardTypelist.add(item);
      //   });
      // }
      // print("Card type list in provider ${cardTypelist.toString()}");
      //return cardTypelist;
      return data;
    } else {
      throw Exception(
          'Failed to load card type list function in status code not equal 200');
    }
  }
}

class SavePaymentProvider with ChangeNotifier {
  final _savePayment = 'api/mPOSXpress/savePayment';
  String _getLocationCode;
  String counter, branch;
  Future<SavePayment> fetchSavePayment(
    List<PaymentData> paymentDataList,
    CheckHeader checkHeader,
    List<CheckDetailItem> check,
    MemberScan memberScan,
    KBZPaymentInfo kbzPaymentInfo,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final _getUrl = preferences.getString("url");
    _getLocationCode = preferences.getString("locationCode");
    counter = preferences.getString("getCounter");
    branch = preferences.getString("branch");
    //  var ss = json.encode(paymentDataList);
    //                     // print("Cdgkjgk Save header $ss");
    // print("Payment DataList in cardusage provider $ss");

    final response = await http
        .post('$_getUrl$_savePayment',
            headers: {
              "Accept": "application/json",
              'Content-type': 'application/json',
            },
            body: json.encode({
              "paymentDataList": paymentDataList,
              "detailsData": check,
              "deletedData": [],
              "headerData": checkHeader,
              "t2pSales": memberScan != null
                  ? [
                      {
                        "username": checkHeader.username,
                        "cardid": memberScan.cardNumber,
                        "cardserial": "",
                        "cardtype": memberScan.cardType,
                        "cardstatus": memberScan.cardStatus,
                        "refcode1": "",
                        "reqnumber": memberScan.requestValue.requestNumber,
                        "branch": branch,
                        "counter": counter,
                        "usetype": "PromotionUse-POS",
                        "returnresultref": "0",
                        "syncstatus": 0
                      }
                    ]
                  : [],
              "uniqueLocCode": _getLocationCode,
              "terminalPaymentInfo": kbzPaymentInfo != null
                  ? {
                      "mAccountNo": kbzPaymentInfo.mAccountNo,
                      "mAmount": kbzPaymentInfo.mAmount,
                      "mApprovalCode": kbzPaymentInfo.mApprovalCode,
                      "mCardType": kbzPaymentInfo.mCardType,
                      "mCurrencyCode": kbzPaymentInfo.mCurrencyCode,
                      "mDate": kbzPaymentInfo.mDate,
                      "mExpDate": kbzPaymentInfo.mExpDate,
                      "mInvoiceNo": kbzPaymentInfo.mInvoiceNo,
                      "mMerchantID": kbzPaymentInfo.mMerchantID,
                      "mPAN": kbzPaymentInfo.mPAN,
                      "mPOSEntry": kbzPaymentInfo.mPOSEntry,
                      "mRespCode": kbzPaymentInfo.mRespCode,
                      "mRRN": kbzPaymentInfo.mRRN,
                      "mSTAN": kbzPaymentInfo.mSTAN,
                      "mTerminalID": kbzPaymentInfo.mTerminalID,
                      "mTime": kbzPaymentInfo.mTime,
                    }
                  : kbzPaymentInfo,
              "topupreqdtls": [],
              "topupresphdr": {
                "sysKey": "0",
                "createdDate": "",
                "modifiedDate": "",
                "userID": "",
                "userName": "",
                "territoryCode": 0,
                "salesCode": 0,
                "projectCode": 0,
                "ref1": 0,
                "ref2": 0,
                "ref3": 0,
                "ref4": 0,
                "ref5": 0,
                "ref6": 0,
                "saveStatus": 0,
                "recordStatus": 0,
                "syncStatus": 0,
                "syncBatch": 0,
                "transType": 0,
                "manualRef": "",
                "userRefNo": "",
                "deliveredDate": "",
                "documentDate": "",
                "requestedDate": "",
                "promisedDate": "",
                "postDate": "",
                "currCode": "",
                "remark": "",
                "crossRef": "",
                "externalRef": "",
                "cVIDSK": "0",
                "cBSK": 0,
                "addressSK": "0",
                "currRate": 0,
                "totalAmount": 0,
                "cashAmount": 0,
                "discountAmount": 0,
                "r3": 0,
                "headerDiscountAmount": 0,
                "beforeTaxAmount": 0,
                "taxSK": 0,
                "taxPercent": 0,
                "isTaxInclusive": 0,
                "taxAmount": 0,
                "settledAmount": 0,
                "batchNo": "0",
                "postedToGL": 0,
                "skipPosting": 0,
                "isQuickEntryRecord": 0,
                "isOpeningEntry": 0,
                "userSK": "0",
                "termsType": 0,
                "nReference1": 0,
                "nReference2": 0,
                "nReference3": 0,
                "nReference4": "0",
                "nReference5": "0",
                "nReference6": 0,
                "nReference7": "0",
                "tReference1": "",
                "tReference2": "",
                "tReference3": "",
                "tReference4": "",
                "tReference5": "",
                "tReference6": "",
                "tReference7": "",
                "userSysKey": "0",
                "subTransType": 0,
                "sG": 0,
                "r1": 0,
                "nReference8": 0,
                "nReference9": 0,
                "nReference10": 0,
                "nReference11": 0,
                "nReference12": 0,
                "nReference13": 0,
                "nReference14": 0,
                "nReference15": 0,
                "nReference16": 0,
                "nReference17": 0,
                "nReference18": 0,
                "nReference19": 0,
                "nReference20": 0,
                "nReference21": 0,
                "nReference22": 0,
                "tReference8": "",
                "tReference9": "",
                "tReference10": "",
                "tReference11": "",
                "tReference12": "",
                "tReference13": "",
                "tReference14": "",
                "tReference15": "",
                "tReference16": "",
                "tReference17": "",
                "tReference18": "",
                "tReference19": "",
                "tReference20": "",
                "tReference21": "",
                "tReference22": "",
                "nReference23": 0,
                "taxType": 0,
                "nReference25": 0,
                "nReference26": 0,
                "nReference27": 0,
                "nReference28": 0,
                "taxAccSK": 0,
                "nReference30": 0,
                "nReference31": 0,
                "nReference32": 0,
                "tReference23": "",
                "tReference24": "",
                "tReference25": "",
                "tReference26": "",
                "tReference27": "",
                "tReference28": "",
                "tReference29": "",
                "tReference30": "",
                "tReference31": "",
                "tReference32": "",
                "tReference33": "",
                "transactionID": "",
                "gLTransID": "",
                "createdTime": "",
                "modifiedTime": ""
              },
              "topupdelreqdtls": [],
              "osUrl": "http://localhost:8070/",
              "paidStatus": "1"
            }))
        .catchError((onError) {
      throw Exception('Failed to load savepayment');
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return SavePayment.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load savepayment rr');
    }
  }
}
