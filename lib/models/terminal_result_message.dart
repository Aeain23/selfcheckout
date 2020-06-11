import 'package:flutter/foundation.dart';

class TerminalResultMessage {
  final int etx;
  final int len;
  final String mAccountNo;
  final double mAmount;
  final String mApprovalCode;
  final String mCardType;
  final String mCurrencyCode;
  final String mDate;
  final String mExpDate;
  final String mInvoiceNo;
  final String mMerchantID;
  final String mPAN;
  final String mPOSEntry;
  final String mRRN;
  final String mRespCode;
  final String mSTAN;
  final String mTerminalID;
  final String mTime;
  final int stx;
  TerminalResultMessage({
    @required this.etx,
    @required this.len,
    @required this.mAccountNo,
    @required this.mAmount,
    @required this.mApprovalCode,
    @required this.mCardType,
    @required this.mCurrencyCode,
    @required this.mDate,
    @required this.mExpDate,
    @required this.mInvoiceNo,
    @required this.mMerchantID,
    @required this.mPAN,
    @required this.mPOSEntry,
    @required this.mRRN,
    @required this.mRespCode,
    @required this.mSTAN,
    @required this.mTerminalID,
    @required this.mTime,
    @required this.stx,
  });
  factory TerminalResultMessage.fromJson(Map<String, dynamic> json) {
    return TerminalResultMessage(
        etx: json['etx'],
        len: json['len'],
        mAccountNo: json['mAccountNo'],
        mAmount: json['mAmount'],
        mApprovalCode: json['mApprovalCode'],
        mCardType: json['mCardType'],
        mCurrencyCode: json['mCurrencyCode'],
        mDate: json['mDate'],
        mExpDate: json['mExpDate'],
        mInvoiceNo: json['mInvoiceNo'],
        mMerchantID: json['mMerchantID'],
        mPAN: json['mPAN'],
        mPOSEntry: json['mPOSEntry'],
        mRRN: json['mRRN'],
        mRespCode: json['mRespCode'],
        mSTAN: json['mSTAN'],
        mTerminalID: json['mTerminalID'],
        mTime: json['mTime'],
        stx: json['stx']);
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['stx'] = stx;
  //   data['len'] = len;
  //   data['etx'] = etx;
  //   data['paymentInfo'] = paymentInfo;
  //   return data;
  // }
}

class KBZPaymentInfo {
  final String mAccountNo;
  final double mAmount;
  final String mApprovalCode;
  final String mCardType;
  final String mCurrencyCode;
  final String mDate;
  final String mExpDate;
  final String mInvoiceNo;
  final String mMerchantID;
  final String mPAN;
  final String mPOSEntry;
  final String mRRN;
  final String mRespCode;
  final String mSTAN;
  final String mTerminalID;
  final String mTime;
  KBZPaymentInfo(
      {@required this.mAccountNo,
      @required this.mAmount,
      @required this.mApprovalCode,
      @required this.mCardType,
      @required this.mCurrencyCode,
      @required this.mDate,
      @required this.mExpDate,
      @required this.mInvoiceNo,
      @required this.mMerchantID,
      @required this.mPAN,
      @required this.mPOSEntry,
      @required this.mRRN,
      @required this.mRespCode,
      @required this.mSTAN,
      @required this.mTerminalID,
      @required this.mTime});
  factory KBZPaymentInfo.fromJson(Map<String, dynamic> json) {
    return KBZPaymentInfo(
        mAccountNo: json['mAccountNo'],
        mAmount: json['mAmount'],
        mApprovalCode: json['mApprovalCode'],
        mCardType: json['mCardType'],
        mCurrencyCode: json['mCurrencyCode'],
        mDate: json['mDate'],
        mExpDate: json['mExpDate'],
        mInvoiceNo: json['mInvoiceNo'],
        mMerchantID: json['mMerchantID'],
        mPAN: json['mPAN'],
        mPOSEntry: json['mPOSEntry'],
        mRRN: json['mRRN'],
        mRespCode: json['mRespCode'],
        mSTAN: json['mSTAN'],
        mTerminalID: json['mTerminalID'],
        mTime: json['mTime']);
  }
}
