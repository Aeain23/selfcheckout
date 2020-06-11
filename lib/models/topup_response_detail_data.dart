import 'package:flutter/foundation.dart';

class TopUpResponseDetailData {
  final String sysKey;
  final String createdDate;
  final String modifiedDate;
  final String userID;
  final String userName;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final String userSysKey;
  final String parentID;
  final String stockSK;
  final String refNo;
  final int itemType;
  final String stockCode;
  final String description;
  final String serialNo;
  final String pinCode;
  final String sellByDate;
  final String useByDate;
  final String merchantID;
  final String terminalID;
  final String aPIID;
  final String aPIKEY;
  final String r1;
  final String r2;
  final String r3;
  final String r4;
  final String r5;
  final int status;
  final String sourceHeaderTransSK;
  final int sourceHeaderTransType;
  final int qty;
  final String sourceDetailTransSK;
  final int n8;
  final double r6;
  final double r7;
  final int r8;
  final int r9;
  final int r10;
  final int r11;
  final String r12;
  final int assignedStatus;
  TopUpResponseDetailData(
      {@required this.sysKey,
      @required this.createdDate,
      @required this.modifiedDate,
      @required this.userID,
      @required this.userName,
      @required this.recordStatus,
      @required this.syncStatus,
      @required this.syncBatch,
      @required this.userSysKey,
      @required this.parentID,
      @required this.stockSK,
      @required this.refNo,
      @required this.itemType,
      @required this.stockCode,
      @required this.description,
      @required this.serialNo,
      @required this.pinCode,
      @required this.sellByDate,
      @required this.useByDate,
      @required this.merchantID,
      @required this.terminalID,
      @required this.aPIID,
      @required this.aPIKEY,
      @required this.r1,
      @required this.r2,
      @required this.r3,
      @required this.r4,
      @required this.r5,
      @required this.status,
      @required this.sourceHeaderTransSK,
      @required this.sourceHeaderTransType,
      @required this.qty,
      @required this.sourceDetailTransSK,
      @required this.n8,
      @required this.r6,
      @required this.r7,
      @required this.r8,
      @required this.r9,
      @required this.r10,
      @required this.r11,
      @required this.r12,
      @required this.assignedStatus});
  factory TopUpResponseDetailData.fromJson(Map<String, dynamic> json) =>
      TopUpResponseDetailData(
          sysKey: json['sysKey'],
          createdDate: json['createdDate'],
          modifiedDate: json['modifiedDate'],
          userID: json['userID'],
          userName: json['userName'],
          recordStatus: json['recordStatus'],
          syncStatus: json['syncStatus'],
          syncBatch: json['syncBatch'],
          userSysKey: json['userSysKey'],
          parentID: json['parentID'],
          stockSK: json['stockSK'],
          refNo: json['refNo'],
          itemType: json['itemType'],
          stockCode: json['stockCode'],
          description: json['description'],
          serialNo: json['serialNo'],
          pinCode: json['pinCode'],
          sellByDate: json['sellByDate'],
          useByDate: json['useByDate'],
          merchantID: json['merchantID'],
          terminalID: json['terminalID'],
          aPIID: json['aPIID'],
          aPIKEY: json['aPIKEY'],
          r1: json['r1'],
          r2: json['r2'],
          r3: json['r3'],
          r4: json['r4'],
          r5: json['r5'],
          status: json['status'],
          sourceHeaderTransSK: json['sourceHeaderTransSK'],
          sourceHeaderTransType: json['sourceHeaderTransType'],
          qty: json['qty'],
          sourceDetailTransSK: json['sourceDetailTransSK'],
          n8: json['n8'],
          r6: json['r6'],
          r7: json['r7'],
          r8: json['r8'],
          r9: json['r9'],
          r10: json['r10'],
          r11: json['r11'],
          r12: json['r12'],
          assignedStatus: json['assignedStatus']);
}
