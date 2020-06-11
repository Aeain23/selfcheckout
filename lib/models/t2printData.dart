import 'package:flutter/foundation.dart';
import '../models/promotion_use.dart';

class T2pPaymentList {
  final String paymentType;
  final String paidBy;
  final String cardNumber;
  final String prevPoint;
  final String pointBalance;
  final String prevAmt;
  final String amtBalance;
  T2pPaymentList(
      {@required this.paymentType,
      @required this.paidBy,
      @required this.cardNumber,
      @required this.prevPoint,
      @required this.pointBalance,
      @required this.prevAmt,
      @required this.amtBalance});
  Map<String, dynamic> toJson() => {
        "paymentType": paymentType,
        "paidBy": paidBy,
        "cardNumber": cardNumber,
        "prevPoint": prevPoint,
        "pointBalance": pointBalance,
        "prevAmt": prevAmt,
        "amtBalance": amtBalance
      };
}

class T2printData {
  final String cardType;
  final String cardNumber;
  final String holderName;

  final String rewardDesc;
  final int rewardPoint;
  final List<Reward> reward;
  final String earnedPoint;
  var creditExpirePoint;
  // final String creditExpirePoint;
  final String expireDate;
  T2printData(
      {@required this.cardType,
      @required this.cardNumber,
      @required this.holderName,
      @required this.rewardDesc,
      @required this.rewardPoint,
      @required this.reward,
      @required this.earnedPoint,
      @required this.creditExpirePoint,
      @required this.expireDate});

  Map<String, dynamic> toJson() => {
        "cardType": cardType,
        "cardNumber": cardNumber,
        "holderName": holderName,
        "rewardDesc": rewardDesc,
        "rewardPoint": rewardPoint,
        "rewards": reward,
        "earnedPoint": earnedPoint,
        "creditExpirePoint": creditExpirePoint,
        "expireDate": expireDate
      };
}
