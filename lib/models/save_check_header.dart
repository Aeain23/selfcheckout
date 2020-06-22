import 'package:flutter/foundation.dart';
import 'package:self_check_out/models/topup_request_detail_data.dart';
import '../models/check_detail_item.dart';
import '../models/check_header_item.dart';

class SaveCheckHeader {
  final CheckHeader checkHeader;
  final List<CheckDetailItem> checkDetailItem;
  final List<CheckHeader> checkHeaderList;
  final Table table;
  final List payment;
  final String t2psale;
  final Result result;
  final Topupresphdr topupresphdr;
  final List<TopUpRequestDetailData> topupreqdtl;
  final bool activeShiftExist;

  SaveCheckHeader(
      {@required this.checkHeader,
      @required this.checkDetailItem,
      @required this.checkHeaderList,
      @required this.table,
      @required this.payment,
      @required this.t2psale,
      @required this.result,
      @required this.topupresphdr,
      @required this.topupreqdtl,
      @required this.activeShiftExist});

  factory SaveCheckHeader.fromJson(Map<String, dynamic> json) =>
      SaveCheckHeader(
          checkHeader: CheckHeader.fromJson(json['checkHeader']),
          // checkHeader: json['checkHeader']
          //     .map<CheckHeader>((value) => new CheckHeader.fromJson(value)),
          checkDetailItem: json['checkDetailItem']
              .map<CheckDetailItem>(
                  (value) => new CheckDetailItem.fromJson(value))
              .toList(),
          checkHeaderList: json['checkHeaderList'].map<CheckHeader>((value)=>new CheckHeader.fromJson(value)),
          table: Table.fromJson(json['table']),
          // table: json['table']
          //     .map<Table>((value) => new Table.fromJson(value)),
          // .toList(),
          payment: json['payment'] as List,
          t2psale: json['t2psale'],
          result: Result.fromJson(json['result']),
          topupresphdr: Topupresphdr.fromJson(json['topupresphdr']),
          // result: json['result']
          //     .map<Result>((value) => new Result.fromJson(value)),
          // .toList(),
          // topupresphdr: json['topupresphdr']
          //     .map<Topupresphdr>((value) => new Topupresphdr.fromJson(value)),
          // .toList(),
          topupreqdtl: json['topupreqdtl'].map((value)=>new TopUpRequestDetailData.fromJson((value))),
          activeShiftExist: json['activeShiftExist']);
}

class Result {
  final bool state;
  final String msgCode;
  final String msgDesc;
  final List longResult;
  final List stringResult;

  Result(
      {@required this.state,
      @required this.msgCode,
      @required this.msgDesc,
      @required this.longResult,
      @required this.stringResult});
  factory Result.fromJson(Map<String, dynamic> json) => Result(
      state: json['state'],
      msgCode: json['msgCode'],
      msgDesc: json['msgDesc'],
      longResult: json['longResult'],
      stringResult: json['stringResult']);
}

class Topupresphdr {
  final String sysKey;
  final String createdDate;
  final String modifiedDate;
  final String userID;
  final String userName;
  final int territoryCode;
  final int salesCode;
  final int projectCode;
  final int ref1;
  final int ref2;
  final int ref3;
  final int ref4;
  final int ref5;
  final int ref6;
  final int saveStatus;
  final int recordStatus;
  final int syncStatus;
  final int syncBatch;
  final int transType;
  final String manualRef;
  final String userRefNo;
  final String deliveredDate;
  final String documentDate;
  final String requestedDate;
  final String promisedDate;
  final String postDate;
  final String currCode;
  final String remark;
  final String crossRef;
  final String externalRef;
  final String cVIDSK;
  final int cBSK;
  final String addressSK;
  final double currRate;
  final double totalAmount;
  final double cashAmount;
  final double discountAmount;
  final double r3;
  final double headerDiscountAmount;
  final double beforeTaxAmount;
  final int taxSK;
  final double taxPercent;
  final int isTaxInclusive;
  final double taxAmount;
  final double settledAmount;
  final String batchNo;
  final int postedToGL;
  final int skipPosting;
  final int isQuickEntryRecord;
  final int isOpeningEntry;
  final String userSK;
  final int termsType;
  final int nReference1;
  final int nReference2;
  final int nReference3;
  final String nReference4;
  final String nReference5;
  final int nReference6;
  final String nReference7;
  final String tReference1;
  final String tReference2;
  final String tReference3;
  final String tReference4;
  final String tReference5;
  final String tReference6;
  final String tReference7;
  final String userSysKey;
  final int subTransType;
  final double sG;
  final double r1;
  final double nReference8;
  final double nReference9;
  final double nReference10;
  final double nReference11;
  final double nReference12;
  final double nReference13;
  final double nReference14;
  final double nReference15;
  final double nReference16;
  final double nReference17;
  final double nReference18;
  final double nReference19;
  final double nReference20;
  final double nReference21;
  final double nReference22;
  final String tReference8;
  final String tReference9;
  final String tReference10;
  final String tReference11;
  final String tReference12;
  final String tReference13;
  final String tReference14;
  final String tReference15;
  final String tReference16;
  final String tReference17;
  final String tReference18;
  final String tReference19;
  final String tReference20;
  final String tReference21;
  final String tReference22;
  final int nReference23;
  final int taxType;
  final int nReference25;
  final int nReference26;
  final int nReference27;
  final int nReference28;
  final int taxAccSK;
  final int nReference30;
  final int nReference31;
  final int nReference32;
  final String tReference23;
  final String tReference24;
  final String tReference25;
  final String tReference26;
  final String tReference27;
  final String tReference28;
  final String tReference29;
  final String tReference30;
  final String tReference31;
  final String tReference32;
  final String tReference33;
  final String transactionID;
  final String gLTransID;
  final String createdTime;
  final String modifiedTime;

  Topupresphdr(
      {@required this.sysKey,
      @required this.createdDate,
      @required this.modifiedDate,
      @required this.userID,
      @required this.userName,
      @required this.territoryCode,
      @required this.salesCode,
      @required this.projectCode,
      @required this.ref1,
      @required this.ref2,
      @required this.ref3,
      @required this.ref4,
      @required this.ref5,
      @required this.ref6,
      @required this.saveStatus,
      @required this.recordStatus,
      @required this.syncStatus,
      @required this.syncBatch,
      @required this.transType,
      @required this.manualRef,
      @required this.userRefNo,
      @required this.deliveredDate,
      @required this.documentDate,
      @required this.requestedDate,
      @required this.promisedDate,
      @required this.postDate,
      @required this.currCode,
      @required this.remark,
      @required this.crossRef,
      @required this.externalRef,
      @required this.cVIDSK,
      @required this.cBSK,
      @required this.addressSK,
      @required this.currRate,
      @required this.totalAmount,
      @required this.cashAmount,
      @required this.discountAmount,
      @required this.r3,
      @required this.headerDiscountAmount,
      @required this.beforeTaxAmount,
      @required this.taxSK,
      @required this.taxPercent,
      @required this.isTaxInclusive,
      @required this.taxAmount,
      @required this.settledAmount,
      @required this.batchNo,
      @required this.postedToGL,
      @required this.skipPosting,
      @required this.isQuickEntryRecord,
      @required this.isOpeningEntry,
      @required this.userSK,
      @required this.termsType,
      @required this.nReference1,
      @required this.nReference2,
      @required this.nReference3,
      @required this.nReference4,
      @required this.nReference5,
      @required this.nReference6,
      @required this.nReference7,
      @required this.tReference1,
      @required this.tReference2,
      @required this.tReference3,
      @required this.tReference4,
      @required this.tReference5,
      @required this.tReference6,
      @required this.tReference7,
      @required this.userSysKey,
      @required this.subTransType,
      @required this.sG,
      @required this.r1,
      @required this.nReference8,
      @required this.nReference9,
      @required this.nReference10,
      @required this.nReference11,
      @required this.nReference12,
      @required this.nReference13,
      @required this.nReference14,
      @required this.nReference15,
      @required this.nReference16,
      @required this.nReference17,
      @required this.nReference18,
      @required this.nReference19,
      @required this.nReference20,
      @required this.nReference21,
      @required this.nReference22,
      @required this.tReference8,
      @required this.tReference9,
      @required this.tReference10,
      @required this.tReference11,
      @required this.tReference12,
      @required this.tReference13,
      @required this.tReference14,
      @required this.tReference15,
      @required this.tReference16,
      @required this.tReference17,
      @required this.tReference18,
      @required this.tReference19,
      @required this.tReference20,
      @required this.tReference21,
      @required this.tReference22,
      @required this.nReference23,
      @required this.taxType,
      @required this.nReference25,
      @required this.nReference26,
      @required this.nReference27,
      @required this.nReference28,
      @required this.taxAccSK,
      @required this.nReference30,
      @required this.nReference31,
      @required this.nReference32,
      @required this.tReference23,
      @required this.tReference24,
      @required this.tReference25,
      @required this.tReference26,
      @required this.tReference27,
      @required this.tReference28,
      @required this.tReference29,
      @required this.tReference30,
      @required this.tReference31,
      @required this.tReference32,
      @required this.tReference33,
      @required this.transactionID,
      @required this.gLTransID,
      @required this.createdTime,
      @required this.modifiedTime});

  factory Topupresphdr.fromJson(Map<String, dynamic> json) => Topupresphdr(
      sysKey: json['sysKey'],
      createdDate: json['createdDate'],
      modifiedDate: json['modifiedDate'],
      userID: json['userID'],
      userName: json['userName'],
      territoryCode: json['territoryCode'],
      salesCode: json['salesCode'],
      projectCode: json['projectCode'],
      ref1: json['ref1'],
      ref2: json['ref2'],
      ref3: json['ref3'],
      ref4: json['ref4'],
      ref5: json['ref5'],
      ref6: json['ref6'],
      saveStatus: json['saveStatus'],
      recordStatus: json['recordStatus'],
      syncStatus: json['syncStatus'],
      syncBatch: json['syncBatch'],
      transType: json['transType'],
      manualRef: json['manualRef'],
      userRefNo: json['userRefNo'],
      deliveredDate: json['deliveredDate'],
      documentDate: json['documentDate'],
      requestedDate: json['requestedDate'],
      promisedDate: json['promisedDate'],
      postDate: json['postDate'],
      currCode: json['currCode'],
      remark: json['remark'],
      crossRef: json['crossRef'],
      externalRef: json['externalRef'],
      cVIDSK: json['cVIDSK'],
      cBSK: json['cBSK'],
      addressSK: json['addressSK'],
      currRate: json['currRate'],
      totalAmount: json['totalAmount'],
      cashAmount: json['cashAmount'],
      discountAmount: json['discountAmount'],
      r3: json['r3'],
      headerDiscountAmount: json['headerDiscountAmount'],
      beforeTaxAmount: json['beforeTaxAmount'],
      taxSK: json['taxSK'],
      taxPercent: json['taxPercent'],
      isTaxInclusive: json['isTaxInclusive'],
      taxAmount: json['taxAmount'],
      settledAmount: json['settledAmount'],
      batchNo: json['batchNo'],
      postedToGL: json['postedToGL'],
      skipPosting: json['skipPosting'],
      isQuickEntryRecord: json['isQuickEntryRecord'],
      isOpeningEntry: json['isOpeningEntry'],
      userSK: json['userSK'],
      termsType: json['termsType'],
      nReference1: json['nReference1'],
      nReference2: json['nReference2'],
      nReference3: json['nReference3'],
      nReference4: json['nReference4'],
      nReference5: json['nReference5'],
      nReference6: json['nReference6'],
      nReference7: json['nReference7'],
      tReference1: json['tReference1'],
      tReference2: json['tReference2'],
      tReference3: json['tReference3'],
      tReference4: json['tReference4'],
      tReference5: json['tReference5'],
      tReference6: json['tReference6'],
      tReference7: json['tReference7'],
      userSysKey: json['userSysKey'],
      subTransType: json['subTransType'],
      sG: json['sG'],
      r1: json['r1'],
      nReference8: json['nReference8'],
      nReference9: json['nReference9'],
      nReference10: json['nReference10'],
      nReference11: json['nReference11'],
      nReference12: json['nReference12'],
      nReference13: json['nReference13'],
      nReference14: json['nReference14'],
      nReference15: json['nReference15'],
      nReference16: json['nReference16'],
      nReference17: json['nReference17'],
      nReference18: json['nReference18'],
      nReference19: json['nReference19'],
      nReference20: json['nReference20'],
      nReference21: json['nReference21'],
      nReference22: json['nReference22'],
      tReference8: json['tReference8'],
      tReference9: json['tReference9'],
      tReference10: json['tReference10'],
      tReference11: json['tReference11'],
      tReference12: json['tReference12'],
      tReference13: json['tReference13'],
      tReference14: json['tReference14'],
      tReference15: json['tReference15'],
      tReference16: json['tReference16'],
      tReference17: json['tReference17'],
      tReference18: json['tReference18'],
      tReference19: json['tReference19'],
      tReference20: json['tReference20'],
      tReference21: json['tReference21'],
      tReference22: json['tReference22'],
      nReference23: json['nReference23'],
      taxType: json['taxType'],
      nReference25: json['nReference25'],
      nReference26: json['nReference26'],
      nReference27: json['nReference27'],
      nReference28: json['nReference28'],
      taxAccSK: json['taxAccSK'],
      nReference30: json['nReference30'],
      nReference31: json['nReference31'],
      nReference32: json['nReference32'],
      tReference23: json['tReference23'],
      tReference24: json['tReference24'],
      tReference25: json['tReference25'],
      tReference26: json['tReference26'],
      tReference27: json['tReference27'],
      tReference28: json['tReference28'],
      tReference29: json['tReference29'],
      tReference30: json['tReference30'],
      tReference31: json['tReference31'],
      tReference32: json['tReference32'],
      tReference33: json['tReference33'],
      transactionID: json['transactionID'],
      gLTransID: json['gLTransID'],
      createdTime: json['createdTime'],
      modifiedTime: json['modifiedTime']);
}
