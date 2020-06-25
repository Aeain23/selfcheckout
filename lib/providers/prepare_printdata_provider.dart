import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/check_detail_item.dart';
import '../models/check_header_item.dart';
import '../models/member_scan.dart';
import '../models/payment_data.dart';
import '../models/promotion_use.dart';
import '../models/t2printData.dart';
import 'dart:convert';

class PreparePrintDataProvider with ChangeNotifier {
 Future<String> fetchPrint(
      CheckHeader checkHeader,
      MemberScan memberScan,
      List<CheckDetailItem> saveCheckHeader,
      int value,
      int remainValue,
      PromotionUse promotionUse,
      List<PaymentData> paymentData,
      List<T2pPaymentList> t2pPayment,
      int cuponCount) async {
    String branch;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    branch = sharedPreferences.getString("branch");
    print('branch in getData $branch');

    String paymentString = json.encode(paymentData);
    var payment = '"paymentData":$paymentString,';
    String t2payment = json.encode(t2pPayment);
    var t2pPaymentlist = '"t2pPaymentList":$t2payment,';
    String header = json.encode(checkHeader);
    String member = '{"headerData":$header,';
    String detailString = json.encode(saveCheckHeader);
    var detail = '"detailsData":$detailString,';
    String reward;
    String rewardDesc = "";
    double rewardAmount = 0.0;
    if (promotionUse != null) {
      reward = json.encode(promotionUse.rewards);
      if (promotionUse.rewards.length > 0) {
        rewardDesc = promotionUse.rewards[0].rewardDescription;
        rewardAmount = promotionUse.rewards[0].rewardAmount;
      }
    }
    var t2printData;
    if (memberScan == null) {
      t2printData = '"t2pPrintData":{},';
    } else {
      t2printData =
          '"t2pPrintData":{"cardType":"${memberScan.cardType}","cardNumber":${memberScan.cardNumber},"holderName":"${memberScan.name}","rewardDesc":"$rewardDesc","rewardPoint":"$rewardAmount","rewards": $reward,"earnedPoint":"${memberScan.cardBalance[1].creditAmount}","creditExpirePoint":"${memberScan.cardBalance[1].creditExpireAmount}","expireDate":"${memberScan.cardBalance[1].creditExpireDate}"},';
    }
    var serialDataList = '"serialDataList": [],';
    var couponCount = '"couponCount": $cuponCount,';
    var savedLocationCode = ' "savedLocationCode": "$branch"}';
    return "$member$payment$detail$t2printData$t2pPaymentlist$serialDataList$couponCount$savedLocationCode";
  }
}
