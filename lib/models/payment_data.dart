import 'package:flutter/foundation.dart';

class PaymentData {
  final String id;
  final int syskey;
  final double autokey;
  final String createddate;
  final String modifieddate;
  final String userid;
  final String username;
  final double territorycode;
  final double salescode;
  final double projectcode;
  final double ref1;
  final double ref2;
  final double ref3;
  final double ref4;
  final double ref5;
  final double ref6;
  final int saveStatus;
  final int parentid;
  final int recordStatus;
  final int syncStatus;
  final double syncBatch;
  final String t1;
  final String t2;
  final String n1;
  final int n2;
  final double n3;
  final double n4;
  final int n5;
  final int n6;
  final String n7;
  final String n8;
  final String userSysKey;
  final String t3;
  final String payTypecode;
  PaymentData(
      {@required this.id,
      @required this.syskey,
      @required this.autokey,
      @required this.createddate,
      @required this.modifieddate,
      @required this.userid,
      @required this.username,
      @required this.territorycode,
      @required this.salescode,
      @required this.projectcode,
      @required this.ref1,
      @required this.ref2,
      @required this.ref3,
      @required this.ref4,
      @required this.ref5,
      @required this.ref6,
      @required this.saveStatus,
      @required this.parentid,
      @required this.recordStatus,
      @required this.syncStatus,
      @required this.syncBatch,
      @required this.t1,
      @required this.t2,
      @required this.n1,
      @required this.n2,
      @required this.n3,
      @required this.n4,
      @required this.n5,
      @required this.n6,
      @required this.n7,
      @required this.n8,
      @required this.userSysKey,
      @required this.t3,
      @required this.payTypecode});
  Map<String, dynamic> toJson() => {
        "syskey": syskey,
        "createddate": createddate,
        "modifieddate": modifieddate,
        "userid": userid,
        "username": username,
        "territorycode": territorycode,
        "salescode": salescode,
        "projectcode": projectcode,
        "ref1": ref1,
        "ref2": ref2,
        "ref3": ref3,
        "ref4": ref4,
        "ref5": ref5,
        "ref6": ref6,
        "saveStatus": saveStatus,
        "recordStatus": recordStatus,
        "t1": t1,
        "t2": t2,
        "n1": n1,
        "n2": n2,
        "n3": n3,
        "n4": n4,
        "n5": n5,
        "n7": n7,
        "n8": n8,
        "payTypeCode": payTypecode,
        "userSysKey": userSysKey,
        "t3": t3,
        "autokey": autokey,
        "parentid": parentid,
        "syncStatus": syncStatus,
        "syncBatch": syncBatch
      };
}
