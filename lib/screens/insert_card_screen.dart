import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/models/check_header_item.dart';
import 'package:self_check_out/providers/connectionprovider.dart';
import 'package:self_check_out/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_currency.dart';
import '../localization/language_constants.dart';
import '../models/card_usage.dart';
import '../models/payment_data.dart';
import '../models/payment_type.dart';
import '../models/promotion_use.dart';
import '../models/terminal_result_message.dart';
import '../providers/card_usage_provider.dart';
import '../providers/member_scan_provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/payment_successful_screen.dart';
import '../screensize_reducer.dart';
import '../widgets/app_bar_widget.dart';
import '../models/t2printData.dart';

class InsertCardScreen extends StatefulWidget {
  final String cash;
  final CardUsage cardUsage;
  final int point;
  final List<T2pPaymentList> t2pPaymentList;
  final bool terOpenFlag;
  final int couponCount;
  final int cashorpoint;
  final List<Currency> currencyList;
  final List<PaymentType> payTypeList;
  final TerminalResultMessage resultMessage;
  final bool cardUsageDuplicate;

  InsertCardScreen(
      this.cash,
      this.cardUsage,
      this.point,
      this.t2pPaymentList,
      this.terOpenFlag,
      this.couponCount,
      this.cashorpoint,
      this.currencyList,
      this.payTypeList,
      this.resultMessage,
      this.cardUsageDuplicate);

  @override
  _InsertCardScreenState createState() => _InsertCardScreenState();
}

class _InsertCardScreenState extends State<InsertCardScreen> {
  String payReturn = '';
  String formattedDate = DateFormat.yMMMd().format(DateTime.now());
  List<PaymentData> paymentdataList = [];
  List<PaymentData> paymentdataListNew = [];
  PaymentData paymentData;
  PaymentType paymentType;
  PromotionUse promotionUse;
  String counter, username, macAddress, system;
  CardUsage crdUsage;
  String payTypeCode = "";
  String locCode, ref;
  // bool flag ;
  int count;

  void getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(
      () {
        counter = sharedPreferences.getString("getCounter");
        username = sharedPreferences.getString("username");
        macAddress = sharedPreferences.getString("macAddress");
        system = sharedPreferences.getString("name");
        locCode = sharedPreferences.getString("locationCode");
        ref = sharedPreferences.getString("ref");
      },
    );
  }

  String branch;
  void readSystem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      branch = preferences.getString("branch");
      print("Location Code in pint $branch");
    });
  }

  void payment1(TerminalResultMessage terminal) {
    // Fluttertoast.showToast(
    //     msg:
    //         "function call from inital state resultMessage: ${terminal.mInvoiceNo}",
    //     timeInSecForIosWeb: 5);
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final memberScanProvider =
        Provider.of<MemberScanProvider>(context, listen: false);
    try {
      if (terminal != null) {
        int i = 0;
        i++;

        if (terminal.mCardType == "01") {
          // Fluttertoast.showToast(msg: '01', timeInSecForIosWeb: 5);
          widget.payTypeList.forEach((value) {
            if (value.t2 == "VISA") {
              // Fluttertoast.showToast(msg: 'VISA', timeInSecForIosWeb: 5);
              paymentType = value;
            }
          });
        } else if (terminal.mCardType == "02") {
          widget.payTypeList.forEach((value) {
            if (value.t2 == "MASTER") {
              //  Fluttertoast.showToast(msg:'MASTER', timeInSecForIosWeb: 5);
              paymentType = value;
            }
          });
        } else if (terminal.mCardType == "03") {
          widget.payTypeList.forEach((value) {
            if (value.t2 == "JCB") {
              //  Fluttertoast.showToast(msg:'JCB', timeInSecForIosWeb: 5);
              paymentType = value;
            }
          });
        } else if (terminal.mCardType == "04") {
          widget.payTypeList.forEach((value) {
            if (value.t2 == "MPU") {
              // Fluttertoast.showToast(msg:'MPU', timeInSecForIosWeb: 5);
              paymentType = value;
            }
          });
        } else if (terminal.mCardType == "05") {
          widget.payTypeList.forEach((value) {
            // Fluttertoast.showToast(msg:'02', timeInSecForIosWeb: 5);
            // print('02');
            if (value.t2 == "UPI") {
              // Fluttertoast.showToast(msg:'UPI', timeInSecForIosWeb: 5);
              // print('UPI');
              paymentType = value;
            }
          });
        } else {
          // Fluttertoast.showToast(msg:'paytype length ${widget.payTypeList.length}', timeInSecForIosWeb: 5);
          for (int i = 0; i < widget.payTypeList.length; i++) {
            // Fluttertoast.showToast(msg: 'i: $i', timeInSecForIosWeb: 5);
            // print('i $i');
            if (widget.payTypeList[i].t2 == "MPU") {
              // Fluttertoast.showToast(msg: 'MPU', timeInSecForIosWeb: 5);
              // print('MPU');
              paymentType = widget.payTypeList[i];
            }
          }
        }
        // Fluttertoast.showToast(msg:'payment type $paymentType', timeInSecForIosWeb: 5);
        // Fluttertoast.showToast(msg:'payment type ${paymentType.syskey}', timeInSecForIosWeb: 5);
        // print('payment type $paymentType');
        // print('payment type syskey ${paymentType.syskey}');

        payTypeCode = paymentType.t2;
        paymentData = new PaymentData(
            id: "0",
            syskey: 0,
            autokey: 0,
            createddate: providerheader.chkHeader.createddate,
            modifieddate: providerheader.chkHeader.modifieddate,
            userid: providerheader.chkHeader.userid,
            username: providerheader.chkHeader.username,
            territorycode: 0,
            salescode: 0,
            projectcode: 0,
            ref1: 0.0,
            ref2: 0.0,
            ref3: 0.0,
            ref4: 0.0,
            ref5: 0.0,
            ref6: 0.0,
            saveStatus: 8,
            parentid: providerheader.chkHeader.id,
            recordStatus: 1,
            syncStatus: 0,
            syncBatch: 0,
            t1: terminal.mInvoiceNo.toString(),
            t2: paymentType.t3,
            n1: paymentType.syskey,
            n2: i,
            n3: terminal.mAmount,
            n4: getCurrencyRate(paymentType.t3),
            n5: 1,
            n6: 0,
            n7: providerheader.chkHeader.n26,
            n8: "0",
            userSysKey: providerheader.chkHeader.userSysKey,
            t3: providerheader.chkHeader.modifieddate,
            payTypecode: payTypeCode);

        paymentdataList.add(paymentData);

        paymentData = new PaymentData(
            id: "0",
            syskey: 0,
            autokey: 0,
            createddate: providerheader.chkHeader.createddate,
            modifieddate: providerheader.chkHeader.modifieddate,
            userid: payTypeCode,
            username: providerheader.chkHeader.username,
            territorycode: 0,
            salescode: 0,
            projectcode: 0,
            ref1: 0.0,
            ref2: 0.0,
            ref3: 0.0,
            ref4: 0.0,
            ref5: 0.0,
            ref6: 0.0,
            saveStatus: 8,
            parentid: providerheader.chkHeader.id,
            recordStatus: 1,
            syncStatus: 0,
            syncBatch: 0,
            t1: terminal.mInvoiceNo.toString(),
            t2: paymentType.t3,
            n1: paymentType.syskey,
            n2: i,
            n3: terminal.mAmount,
            n4: getCurrencyRate(paymentType.t3),
            n5: 1,
            n6: 0,
            n7: providerheader.chkHeader.n26,
            n8: "0",
            userSysKey: providerheader.chkHeader.userSysKey,
            t3: providerheader.chkHeader.modifieddate,
            payTypecode: payTypeCode);

        paymentdataListNew.add(paymentData);

        if ((widget.cardUsage != null &&
                widget.cardUsage.resultCode == "200") ||
            widget.cardUsageDuplicate == true) {
          if (widget.cashorpoint == 1) {
            i++;
            widget.payTypeList.forEach((value) {
              if (value.t1 == "20") {
                // Fluttertoast.showToast(msg: '20', timeInSecForIosWeb: 5);
                // print('20');
                paymentType = value;
              }
            });
            payTypeCode = "20";

            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: providerheader.chkHeader.userid,
                username:
                    widget.cardUsage == null ? "" : widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "20",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataList.add(paymentData);

            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: payTypeCode,
                username:
                    widget.cardUsage == null ? "" : widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "20",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataListNew.add(paymentData);

          } else {
            i++;
            widget.payTypeList.forEach((value) {
              if (value.t1 == "19") {
                // Fluttertoast.showToast(msg: '19', timeInSecForIosWeb: 5);
                // print('19');
                paymentType = value;
              }
            });
            print("payment type $paymentType");
            print("t2 ${paymentType.t3}");
            payTypeCode = "19";
            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: providerheader.chkHeader.userid,
                username: widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "19",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataList.add(paymentData);

            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: payTypeCode,
                username: widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "19",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataListNew.add(paymentData);
          }
        }
        if (widget.cardUsage == null) {
          crdUsage = new CardUsage();
          print('widget cardusage null >> ');
        } else {
          crdUsage = widget.cardUsage;
          print('crdUsage widget cardusage >> ');
        }
        if (paymentdataList.length > 0) {
          String formattedTime = DateFormat("HHmmss").format(DateTime.now());
          CheckHeader chkHdr =  providerheader.chkHeader;
          chkHdr.t11 = formattedTime;
          // dialog.show();
          //  Fluttertoast.showToast(msg: 'paymentdatalist length check :${paymentdataList.length}', timeInSecForIosWeb:5);
          Provider.of<SavePaymentProvider>(context, listen: false)
              .fetchSavePayment(
                  paymentdataList,
                  chkHdr,
                  stockProvider.getchkdtlsList(),
                  memberScanProvider.getMemberScan(),
                  KBZPaymentInfo(
                      mRespCode: terminal.mRespCode.toString(),
                      mPAN: terminal.mPAN.toString(),
                      mSTAN: terminal.mSTAN.toString(),
                      mApprovalCode: terminal.mApprovalCode.toString(),
                      mAccountNo: terminal.mAccountNo.toString(),
                      mExpDate: terminal.mExpDate.toString(),
                      mTime: terminal.mTime.toString(),
                      mDate: terminal.mDate.toString(),
                      mAmount: terminal.mAmount.toDouble(),
                      mRRN: terminal.mRRN.toString(),
                      mPOSEntry: terminal.mPOSEntry.toString(),
                      mTerminalID: terminal.mTerminalID.toString(),
                      mMerchantID: terminal.mMerchantID.toString(),
                      mInvoiceNo: terminal.mInvoiceNo.toString(),
                      mCurrencyCode: terminal.mCurrencyCode.toString(),
                      mCardType: terminal.mCardType.toString()))
              .catchError((onError) {
            print("save Payment error $onError");
            // dialog.hide().whenComplete(() {
            Fluttertoast.showToast(
                msg: "Save Payment Error! $onError", timeInSecForIosWeb: 5);
          })
              // })
              .then((onResult) {
            // Fluttertoast.showToast(
            //     msg: 'save payment result $onResult', timeInSecForIosWeb: 5);
            print('save payment result $onResult');
            if (onResult != null && onResult.result == "Success") {
              if (providerheader.chkHeader.t15 != "") {
                Provider.of<MemberScanProvider>(context, listen: false)
                    .fetchPromotionUseSubmit(
                  stockProvider.getchkdtlsList(),
                  providerheader.chkHeader,
                  memberScanProvider.getMemberScan(),
                  memberScanProvider.getOrderValue(),
                  memberScanProvider.getPromoUseValues(),
                  widget.cardUsage,
                  paymentdataList,
                  paymentdataListNew,
                )
                    .catchError((onError) {
                  // dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "Promotion Use Error! $onError",
                      timeInSecForIosWeb: 5);
                })
                    // })
                    .then((onValue) {
                  memberScanProvider
                      .fetchMemberScan(providerheader.chkHeader.t15)
                      .catchError((onError) {
                    // dialog.hide().whenComplete(() {
                    Fluttertoast.showToast(
                        msg: "Member Scan Error! $onError",
                        timeInSecForIosWeb: 5);
                    // });
                  }).then((onResult) {
                    // Fluttertoast.showToast(
                    //     msg: 'navigate to paymentsucessscreen result $onResult',
                    //     timeInSecForIosWeb: 5);
                    // dialog.hide().whenComplete(() {
                    // setState(() {
                    //   flag= false;
                    // });

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(
                              onResult,
                              int.parse(widget.cash),
                              widget.point,
                              onValue,
                              paymentdataList,
                              widget.t2pPaymentList,
                              widget.couponCount,
                              chkHdr)),
                    );
                    // });
                  });
                });
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(
                          null,
                          int.parse(widget.cash),
                          widget.point,
                          null,
                          paymentdataList,
                          widget.t2pPaymentList,
                          widget.couponCount,
                          providerheader.chkHeader)),
                );
                // });
              }
            } else {
              Fluttertoast.showToast(
                  msg: "${onResult.result}", timeInSecForIosWeb: 5);
                    if (onResult.result=="This Slip is already paid!") {
              stockProvider.removeAll();
              providerheader.chkHeader = null;
              if (stockProvider.totalAmount == 0.0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashsScreen(),
                  ),
                );
              }
            }
            }
          });
        }

        //  else {
        //   dialog.hide().whenComplete(() {
        //     Fluttertoast.showToast(msg: "Trancation Cancel");
        //   });
        // }

      } else {
        // Fluttertoast.showToast(
        //     msg: "result message get as null: ${terminal.stx}",
        //     timeInSecForIosWeb: 5);
      }
    } on PlatformException catch (e) {
      // dialog.hide().whenComplete(() {
      Fluttertoast.showToast(msg: " terminal null : ${e.message}");
      // });
    }
  }

  @override
  void initState() {
    count = 0;

    readSystem();
    getData();
    super.initState();
  }

  // ProgressDialog dialog;

  double getCurrencyRate(String cashCode) {
    double cashRate = 0;
    for (int i = 0; i < widget.currencyList.length; i++) {
      if (cashCode == widget.currencyList[i].t1) {
        cashRate = widget.currencyList[i].n2;
      }
    }
    return cashRate;
  }

  @override
  Widget build(BuildContext context) {
    // Fluttertoast.showToast(msg: 'Testing build come  ');
    count++;
    if (count == 1) {
      if (widget.cashorpoint == 1) {
        if (widget.cash != 0.toString()) {
          if (widget.terOpenFlag) {
            // Fluttertoast.showToast(
            //     msg:
            //         "get resultMessage from if block: ${widget.resultMessage.etx}",
            //     timeInSecForIosWeb: 5);
            payment1(widget.resultMessage);
            // paymentTerminal(widget.cash.toString());
          }
        }
        // else {
        //   pointPayment();
        // }
      } else {
        if (widget.cash != 0.toString()) {
          if (widget.terOpenFlag) {
            // Fluttertoast.showToast(
            //     msg:
            //         "get resultMessage from else block : ${widget.resultMessage.etx}",
            //     timeInSecForIosWeb: 5);
            payment1(widget.resultMessage);
            // paymentTerminal(widget.cash.toString());
          }
        } else {
          citycashPayment();
        }
      }
    }

    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height:screenHeight(context, dividedBy:7),
              margin: const EdgeInsets.only(top: 80.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(getTranslated(context, "insert_card_into_terminal"),
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),
            Image.asset("assets/images/card.jpg"),
            Container(
              margin: EdgeInsets.only(right: 50.0, bottom: 15),
              height:screenHeight(context, dividedBy: 16),
              width:screenWidth(context, dividedBy: 2),
              child: Center(
                child: Text(
                  "Please wait processing...",
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // void pointPayment() {
  //   final providerheader =
  //       Provider.of<SaveCheckHeaderProvider>(context, listen: false);
  //   final stockProvider = Provider.of<StockProvider>(context, listen: false);
  //   // final printerprovider =
  //   //     Provider.of<PrintCitycardProvider>(context, listen: false);
  //   final memberScanProvider =
  //       Provider.of<MemberScanProvider>(context, listen: false);
  //   //  final   connectionProvider = Provider.of<ConnectionProvider>(context);
  //   int i = 0;
  //   // connectionProvider.checkconnection().then((onValue) {
  //   // if (onValue) {
  //   try {
  //     payTypeCode = "20";
  //     if (widget.cardUsage != null && widget.cardUsage.resultCode == "200") {
  //       i++;
  //       widget.payTypeList.forEach((value) {
  //         if (value.t1 == "20") {
  //           print('20');
  //           paymentType = value;
  //         }
  //       });
  //       paymentData = new PaymentData(
  //           id: "0",
  //           syskey: 0,
  //           autokey: 0,
  //           createddate: providerheader.chkHeader.createddate,
  //           modifieddate: providerheader.chkHeader.modifieddate,
  //           userid: providerheader.chkHeader.userid,
  //           username: widget.cardUsage.resultRef,
  //           territorycode: 0,
  //           salescode: 0,
  //           projectcode: 0,
  //           ref1: 0.0,
  //           ref2: double.parse(memberScanProvider.getMemberScan().cardTypeID),
  //           ref3: widget.point.toDouble(),
  //           ref4: 0.0,
  //           ref5: 0.0,
  //           ref6: 0.0,
  //           saveStatus: 8,
  //           parentid: providerheader.chkHeader.syskey,
  //           recordStatus: 1,
  //           syncStatus: 0,
  //           syncBatch: 0,
  //           t1: memberScanProvider.getMemberScan().cardNumber,
  //           t2: paymentType.t3,
  //           n1: "20",
  //           n2: i,
  //           n3: widget.point.toDouble(),
  //           n4: getCurrencyRate(paymentType.t3),
  //           n5: 1,
  //           n6: 0,
  //           n7: providerheader.chkHeader.n26,
  //           n8: "0",
  //           userSysKey: providerheader.chkHeader.userSysKey,
  //           t3: providerheader.chkHeader.modifieddate,
  //           payTypecode: payTypeCode);

  //       paymentdataList.add(paymentData);
  //     }
  //     print('payment data list $paymentdataList');
  //     // if (widget.cardUsage == null) {
  //     //   crdUsage = new CardUsage();
  //     // } else {
  //     //   crdUsage = widget.cardUsage;
  //     // }
  //     if (paymentdataList.length > 0) {
  //       // dialog.show();
  //       Provider.of<SavePaymentProvider>(context, listen: false)
  //           .fetchSavePayment(
  //               paymentdataList,
  //               providerheader.chkHeader,
  //               stockProvider.getchkdtlsList(),
  //               memberScanProvider.getMemberScan(),
  //               null)
  //           .catchError((onError) {
  //         // dialog.hide().whenComplete(() {
  //         Fluttertoast.showToast(
  //             msg: "Save Payment Error! $onError", timeInSecForIosWeb: 4);
  //         // });
  //       }).then((onResult) {
  //         print('save payment result $onResult');
  //         if (onResult != null) {
  //           if (providerheader.chkHeader.t15 != "") {
  //             print('call member scan');
  //             Provider.of<MemberScanProvider>(context, listen: false)
  //                 .fetchPromotionUseSubmit(
  //               stockProvider.getchkdtlsList(),
  //               providerheader.chkHeader,
  //               memberScanProvider.getMemberScan(),
  //               memberScanProvider.getOrderValue(),
  //               memberScanProvider.getPromoUseValues(),
  //               widget.cardUsage,
  //               paymentdataList,
  //             )
  //                 .catchError((onError) {
  //               // dialog.hide().whenComplete(() {
  //               Fluttertoast.showToast(
  //                   msg: "Promotion Use Error! $onError",
  //                   timeInSecForIosWeb: 4);
  //               // });
  //             }).then((onValue) {
  //               memberScanProvider
  //                   .fetchMemberScan(providerheader.chkHeader.t15)
  //                   .catchError((onError) {
  //                 Fluttertoast.showToast(msg: "error 621");
  //                 // dialog.hide().whenComplete(() {
  //                 Fluttertoast.showToast(
  //                     msg: "Member Scan Error! $onError",
  //                     timeInSecForIosWeb: 4);
  //                 // });
  //               }).then((onResult) {
  //                 // dialog.hide().whenComplete(() {
  //                 // Navigator.of(context).pop();
  //                 Navigator.of(context).pushReplacement(
  //                   MaterialPageRoute(
  //                       builder: (context) => PaymentSuccessScreen(
  //                           onResult,
  //                           int.parse(widget.cash),
  //                           widget.point,
  //                           onValue,
  //                           paymentdataList,
  //                           widget.t2pPaymentList,
  //                           widget.couponCount,
  //                           providerheader.chkHeader)),
  //                 );
  //                 // });

  //               });
  //             });
  //           }
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     // dialog.hide().whenComplete(() {
  //     Fluttertoast.showToast(msg: '${e.message}');
  //     // });
  //   }
  //   // } else {
  //   //   // dialog.hide().whenComplete(() {
  //   // Fluttertoast.showToast(
  //   //     msg: getTranslated(context, "no_internet_connection"),
  //   //     timeInSecForIosWeb: 4);
  //   //   // });
  // }
  // // });
  // // }

  void citycashPayment() async {
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final memberScanProvider =
        Provider.of<MemberScanProvider>(context, listen: false);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    int i = 0;
    connectionProvider.checkconnection().then((onValue) {
      if (onValue) {
        try {
          payTypeCode = "19";
          if ((widget.cardUsage != null &&
                  widget.cardUsage.resultCode == "200") ||
              widget.cardUsageDuplicate == true) {
            i++;
            widget.payTypeList.forEach((value) {
              if (value.t1 == "19") {
                print('19');
                paymentType = value;
              }
            });
            print("payment type $paymentType");
            print("t2 ${paymentType.t3}");
            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: providerheader.chkHeader.userid,
                username: widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "19",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataList.add(paymentData);

            paymentData = new PaymentData(
                id: "0",
                syskey: 0,
                autokey: 0,
                createddate: providerheader.chkHeader.createddate,
                modifieddate: providerheader.chkHeader.modifieddate,
                userid: payTypeCode,
                username: widget.cardUsage.resultRef,
                territorycode: 0,
                salescode: 0,
                projectcode: 0,
                ref1: 0.0,
                ref2:
                    double.parse(memberScanProvider.getMemberScan().cardTypeID),
                ref3: widget.point.toDouble(),
                ref4: 0.0,
                ref5: 0.0,
                ref6: 0.0,
                saveStatus: 8,
                parentid: providerheader.chkHeader.syskey,
                recordStatus: 1,
                syncStatus: 0,
                syncBatch: 0,
                t1: memberScanProvider.getMemberScan().cardNumber,
                t2: paymentType.t3,
                n1: "19",
                n2: i,
                n3: widget.point.toDouble(),
                n4: getCurrencyRate(paymentType.t3),
                n5: 1,
                n6: 0,
                n7: providerheader.chkHeader.n26,
                n8: "0",
                userSysKey: providerheader.chkHeader.userSysKey,
                t3: providerheader.chkHeader.modifieddate,
                payTypecode: payTypeCode);

            paymentdataListNew.add(paymentData);
          }
          print('payment data list $paymentdataList');
          if (widget.cardUsage == null) {
            crdUsage = new CardUsage();
          } else {
            crdUsage = widget.cardUsage;
          }
          print("card useage in insert card $crdUsage");
          if (paymentdataList.length > 0) {
            String formattedTime = DateFormat("HHmmss").format(DateTime.now());
            CheckHeader chkHdr =  providerheader.chkHeader;
            chkHdr.t11 = formattedTime;
            // dialog.show();
            Provider.of<SavePaymentProvider>(context, listen: false)
                .fetchSavePayment(
                    paymentdataList,
                    chkHdr,
                    stockProvider.getchkdtlsList(),
                    memberScanProvider.getMemberScan(),
                    null)
                .catchError((onError) {
              print("save payment error $onError");
              // dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: "Save Payment Error! $onError", timeInSecForIosWeb: 4);
              // });
            }).then((onResult) {
              print('save payment result $onResult');
              if (onResult != null && onResult.result == "Success") {
                if (providerheader.chkHeader.t15 != "") {
                  print('call member scan');
                  Provider.of<MemberScanProvider>(context, listen: false)
                      .fetchPromotionUseSubmit(
                    stockProvider.getchkdtlsList(),
                    providerheader.chkHeader,
                    memberScanProvider.getMemberScan(),
                    memberScanProvider.getOrderValue(),
                    memberScanProvider.getPromoUseValues(),
                    widget.cardUsage,
                    paymentdataList,
                    paymentdataListNew,
                  )
                      .catchError((onError) {
                    // dialog.hide().whenComplete(() {
                    Fluttertoast.showToast(
                        msg: "Promotion Use Error! $onError",
                        timeInSecForIosWeb: 4);
                    // });
                  }).then((onValue) {
                    memberScanProvider
                        .fetchMemberScan(providerheader.chkHeader.t15)
                        .catchError((onError) {
                      Fluttertoast.showToast(msg: "error 621");
                      // dialog.hide().whenComplete(() {
                      Fluttertoast.showToast(
                          msg: "Member Scan Error! $onError",
                          timeInSecForIosWeb: 4);
                      // });
                    }).then((onResult) {
                      // dialog.hide().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => PaymentSuccessScreen(
                                onResult,
                                int.parse(widget.cash),
                                widget.point,
                                onValue,
                                paymentdataList,
                                widget.t2pPaymentList,
                                widget.couponCount,
                                chkHdr)),
                      );
                      // });
                    });
                  });
                }
              } else {
                Fluttertoast.showToast(
                    msg: "${onResult.result}", timeInSecForIosWeb: 4);
              }
            });
          }
        } catch (e) {
          // dialog.hide().whenComplete(() {
          Fluttertoast.showToast(msg: '${e.message}');
          // });
        }
      } else {
        // dialog.hide().whenComplete(() {
        Fluttertoast.showToast(
            msg: getTranslated(context, "no_internet_connection"),
            timeInSecForIosWeb: 4);
        // });
      }
    });
  }
}
