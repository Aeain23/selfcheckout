import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_display/number_display.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:self_check_out/models/member_scan.dart';
import 'package:self_check_out/models/promotion_use.dart';
import 'package:self_check_out/screens/splash_screen.dart';
import '../models/payment_data.dart';
import '../screens/payment_successful_screen.dart';
import '../localization/language_constants.dart';
import '../models/payment_currency.dart';
import '../models/payment_type.dart';
import '../providers/payment_currency_provider.dart';
import '../providers/payment_type_provider.dart';
import '../models/terminal_result_message.dart';
import '../models/card_usage.dart';
import '../providers/card_usage_provider.dart';
import '../providers/member_scan_provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/insert_card_screen.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/round_slider_track_shape.dart';
import '../models/t2printData.dart';
import '../providers/connectionprovider.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CreditCardScreen extends StatefulWidget {
  final String cashforCredit;
  final String pointforCredit;
  final String nameforCredit;
  final MemberScan memberScanforCredit;
  final PromotionUse promotionUseForCredit;
  final int cuponCountforCredit;
  final String cash;
  final String point;
  final double total;
  final String name;
  final bool terminalFlag;
  final int couponcount;
  CreditCardScreen(
      {this.cashforCredit,
      this.pointforCredit,
      this.nameforCredit,
      this.memberScanforCredit,
      this.promotionUseForCredit,
      this.cuponCountforCredit,
      this.cash,
      this.point,
      this.total,
      this.name,
      this.terminalFlag,
      this.couponcount});

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  var numSeparate;
  String payTypeCode;
  double _remainValue = 0;
  double _value = 0;
  int remainder;
  int max, point, cash;
  CardUsage cardUsage;
  List<T2pPaymentList> t2pPaymentDataList = [];
  bool iscontinue = false;
  List<Currency> currencyList = [];
  List<PaymentType> payTypeList = [];
  PaymentType paymentType;
  PaymentData paymentData;
  List<PaymentData> paymentdataList = [];
  bool cardUsageDuplicate = false;
  bool flag;
  TerminalResultMessage resultMessage = new TerminalResultMessage(
      etx: null,
      len: null,
      mAccountNo: null,
      mAmount: null,
      mApprovalCode: null,
      mCardType: null,
      mCurrencyCode: null,
      mDate: null,
      mExpDate: null,
      mInvoiceNo: null,
      mMerchantID: null,
      mPAN: null,
      mPOSEntry: null,
      mRRN: null,
      mRespCode: null,
      mSTAN: null,
      mTerminalID: null,
      mTime: null,
      stx: null);
  @override
  void initState() {
    super.initState();
     setState(() {
       flag = true;
     });
    // Fluttertoast.showToast(msg: "getData from payment widget ${widget.terminalFlag}");
    _value = (widget.total ~/ 100).toDouble();
    print("_value: dsfjkfj : $_value");
    print("remainValue: dsfjkfj : $_remainValue");
    if (widget.point == null) {
      max = 0;
    } else {
      max = (widget.total.round() ~/ 100);
    }
  }

  double getCurrencyRate(String cashCode) {
    double cashRate = 0;
    for (int i = 0; i < currencyList.length; i++) {
      if (cashCode == currencyList[i].t1) {
        cashRate = currencyList[i].n2;
      }
    }
    return cashRate;
  }

  static const platform = const MethodChannel('flutter.native/helper');
  Future<Null> paymentTerminal(String mbalanceDue) async {
    // TerminalResultMessage resultMessage;

    try {
      final String result = await platform.invokeMethod('paymentTerminal', {
        "mbalanceDue": mbalanceDue,
      });
      print("terminal return before json $result");
      if (result != "") {
        var map = json.decode(result);
        resultMessage = TerminalResultMessage.fromJson(map);
        print('terminal return message after json stx ${resultMessage.stx}');
        print('terminal return message after json etx ${resultMessage.etx}');
        print('terminal return message after json len ${resultMessage.len}');
        print(
            'terminal return message after json invoiceNo ${resultMessage.mInvoiceNo}');
        print('card type ${resultMessage.mCardType}');

        if (resultMessage.stx != null) {
          if (resultMessage.stx == 2 &&
              resultMessage.len > 20 &&
              resultMessage.etx == 3) {
            //  Fluttertoast.showToast(msg: 'return from terminal : ${resultMessage.stx}');
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => InsertCardScreen(
                      cash.toString(),
                      cardUsage,
                      point,
                      t2pPaymentDataList,
                      widget.terminalFlag,
                      widget.couponcount,
                      1,
                      currencyList,
                      payTypeList,
                      resultMessage,
                      cardUsageDuplicate)),
            );
          } else if (resultMessage.stx == 2 &&
              resultMessage.len == 20 &&
              resultMessage.etx == 3) {
                setState(() {
                  Future.delayed(Duration(seconds: 1)).then((va){
                        dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: getTranslated(context, "card_trans_by_system"),
                  timeInSecForIosWeb: 5);
                       Navigator.of(context).pop();
                  });
                });
          
          
              Navigator.of(context).pop();
            });
          } else {
              setState(() {
                  Future.delayed(Duration(seconds: 1)).then((va){
                        dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: getTranslated(context, "error_tran"),
                  timeInSecForIosWeb: 5);
                        Navigator.of(context).pop();
                  });
                });
          
              // Navigator.of(context).pop();
            });
          }
        } else {
          setState(() {
                  Future.delayed(Duration(seconds: 1)).then((va){
                        dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: getTranslated(context, "error_tran"),
                  timeInSecForIosWeb: 5);
                        Navigator.of(context).pop();
                  });
                });
        
         
          
            // Navigator.of(context).pop();
          });
        }
      } else {
          setState(() {
                  Future.delayed(Duration(seconds: 1)).then((va){
                        dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: getTranslated(context, "Trancation Cancel"),
                  timeInSecForIosWeb: 5);
                        Navigator.of(context).pop();
                  });
                });
         
          Navigator.of(context).pop();
        });
      

      }
    } on PlatformException catch (e) {
      dialog.hide().whenComplete(() {
        Fluttertoast.showToast(msg: "${e.message}");
      });
    }
  }

  savePaymentProcess() {
    int i = 0;
    String payTypeCode;
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final memberScanProvider = Provider.of<MemberScanProvider>(context);
    final stockProvider = Provider.of<StockProvider>(context);

    i++;
    payTypeList.forEach((value) {
      if (value.t1 == "20") {
        print('20');
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
        username: cardUsage.resultRef,
        territorycode: 0,
        salescode: 0,
        projectcode: 0,
        ref1: 0.0,
        ref2: double.parse(memberScanProvider.getMemberScan().cardTypeID),
        ref3: point.toDouble(),
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
        n3: point.toDouble(),
        n4: getCurrencyRate(paymentType.t3),
        n5: 1,
        n6: 0,
        n7: providerheader.chkHeader.n26,
        n8: "0",
        userSysKey: providerheader.chkHeader.userSysKey,
        t3: providerheader.chkHeader.modifieddate,
        payTypecode: payTypeCode);

    paymentdataList.add(paymentData);

    if (paymentdataList.length > 0) {
      dialog.show();

      Provider.of<SavePaymentProvider>(context, listen: false)
          .fetchSavePayment(
              paymentdataList,
              providerheader.chkHeader,
              stockProvider.getchkdtlsList(),
              memberScanProvider.getMemberScan(),
              null)
          .catchError((onError) {
        print("save Payment error $onError");
        dialog.hide().whenComplete(() {
          Fluttertoast.showToast(
              msg: "Save Payment Error! $onError", timeInSecForIosWeb: 5);
        });
      }).then((onResult) {
        if (onResult != null && onResult.result == "Success") {
          if (providerheader.chkHeader.t15 != "") {
            Provider.of<MemberScanProvider>(context, listen: false)
                .fetchPromotionUseSubmit(
              stockProvider.getchkdtlsList(),
              providerheader.chkHeader,
              memberScanProvider.getMemberScan(),
              memberScanProvider.getOrderValue(),
              memberScanProvider.getPromoUseValues(),
              cardUsage,
              paymentdataList,
            )
                .catchError((onError) {
              dialog.hide().whenComplete(() {
                Fluttertoast.showToast(
                    msg: "Promotion Use Error! $onError",
                    timeInSecForIosWeb: 5);
              });
            }).then((onValue) {
              memberScanProvider
                  .fetchMemberScan(providerheader.chkHeader.t15)
                  .catchError((onError) {
                dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "Member Scan Error! $onError",
                      timeInSecForIosWeb: 5);
                });
              }).then((onResult) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentSuccessScreen(
                          onResult,
                          cash.round(),
                          point.round(),
                          onValue,
                          paymentdataList,
                          t2pPaymentDataList,
                          widget.couponcount,
                          providerheader.chkHeader)),
                );
              });
            });
          }
        }else {
          dialog.hide().whenComplete(() {
            Fluttertoast.showToast(
                msg: "${onResult.result}", timeInSecForIosWeb: 4);
                if (onResult.result == "This Slip is already paid!" ) {
              stockProvider.chkdtlsList = [];
              providerheader.chkHeader = null;
              if (stockProvider.totalAmount == 0.0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashsScreen(),
                  ),
                );
              }
            }
          });
        }
      });
    }
  }

  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context);
    String total = provider.totalAmount.round().toString();
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final cardusageProvider = Provider.of<CardUsageProvider>(context);
    final memberScanProvider = Provider.of<MemberScanProvider>(context);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final paymentTypeProvider =
        Provider.of<PaymentTypeProvider>(context, listen: false);
    final currencyProvider =
        Provider.of<PaymentCurrencyProvider>(context, listen: false);
    paymentTypeProvider.fetchPaymentType().catchError((onError) {
      dialog.hide();
    }).then((result) {
      payTypeList = result;
    });
    print('Pay list $payTypeList');
    currencyProvider.fetchCurrency().catchError((onError) {
      dialog.hide();
    }).then((result) {
      currencyList = result;
    });
    remainder = provider.totalAmount.round() % 100;

    numSeparate = createDisplay(length: 16, separator: ',');

    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: "Please Wait...",
      progressWidget: Center(
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      (widget.cash != null || widget.point != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset("assets/images/city_reward.jpg"),
                                Text(
                                  "  Welcome back ${widget.name},",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : SizedBox(),
                      (widget.cash != null || widget.point != null)
                          ? Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Text(
                                      "You have in your City Rewards balance"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Text("CityCash: "),
                                      Text(
                                          "Ks ${numSeparate(double.parse(widget.cash).round())}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text("Points:  "),
                                      Text(
                                          "${numSeparate(double.parse(widget.point).round())}"),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Total",
                          style: TextStyle(fontSize: 28, color: Colors.orange),
                        ),
                      ),
                      Text(
                        "Ks ${numSeparate(provider.totalAmount.round())}",
                        style: TextStyle(fontSize: 28, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Payment by Credit Card",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Card(
                          color: Colors.white70,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Credit Card",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: Colors.orange,
                                            inactiveTrackColor: Colors.orange,
                                            trackShape: RoundSliderTrackShape(
                                                radius: 10),
                                            trackHeight: 13.0,
                                            thumbColor: Colors.grey,
                                            overlayColor: Colors.grey,
                                          ),
                                          child: Slider(
                                            value: _value,
                                            min: 0,
                                            max: max.toDouble(),
                                            onChanged: (double newValue) {
                                              setState(() {
                                                _value = newValue;
                                              });
                                              _remainValue = ((provider
                                                          .totalAmount
                                                          .round() ~/
                                                      100) -
                                                  _value);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "  Points",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: <Widget>[
                              //     Expanded(
                              //       flex: 2,
                              //       child: Text(
                              //         "  Ks ${_value.round() * 100 + remainder}",
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //             color: Colors.black, fontSize: 20),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 3,
                              //       child: Text(
                              //         "",
                              //       ),
                              //     ),
                              //     Expanded(
                              //       flex: 2,
                              //       child: Text(
                              //         "${_remainValue.round() * 100}",
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //             color: Colors.black, fontSize: 20),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(right:10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        "   Ks ${_value.round() * 100 + remainder}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                     Expanded(
                                        flex: 8,
                                        child: Text(
                                          "",
                                        ),
                                      ),
                                    Expanded(
                                      flex: 3,
                                      child: IconButton(
                                       
                                        icon: Icon(LineAwesomeIcons.plus_circle),
                                        iconSize: 30,
                                        onPressed: _value <= 0
                                            ? null
                                            : () {
                                                if (_value > 0) {
                                                  setState(() {
                                                    _value -= 1;
                                                    _remainValue += 1;
                                                  });
                                                }
                                              },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "${_remainValue.round() * 100}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: IconButton(
                                        icon: Icon(LineAwesomeIcons.minus_circle),
                                        alignment: Alignment.centerLeft,
                                        iconSize: 30,
                                        onPressed: _remainValue <= 0
                                            ? null
                                            : () {
                                                if (_remainValue > 0) {
                                                  setState(() {
                                                    _remainValue -= 1;
                                                    _value += 1;
                                                  });
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "To be paid",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "   To be used",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
         (flag == true)?
          Container(
            margin: EdgeInsets.only(right: 50.0),
            height: MediaQuery.of(context).size.height / 16,
            width: MediaQuery.of(context).size.width / 2,
            child: 
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(22.0),
                  side: BorderSide(color: Colors.orange)),
              color: Colors.orange,
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                bool isValid = validation();
                if (isValid) {
                  connectionProvider.checkconnection().then((onValue) {
                    dialog.show();
                    if (onValue) {
                      //  Fluttertoast.showToast(msg:"_remainValue before calculate $_remainValue");
                      // Fluttertoast.showToast(msg:"_value before calculate $_value");

                      point = _remainValue.round() * 100;
                      cash = _value.round() * 100 + remainder;

                      // Fluttertoast.showToast(msg:"point $point");
                      // Fluttertoast.showToast(msg:"cash $cash");
                      // Fluttertoast.showToast(msg:"total $total");

                      print('point in confirm >> $point');

                      if ((point + cash).toString() == total) {
                        // Fluttertoast.showToast(msg: 'Point plus cash : $total');
                        String cardBalance = "0";
                        String pointBalance = "0";
                        String cardPreviousBalance = "0";
                        String pointPreviousBalance = "0";
                        if (providerheader.chkHeader.t15 != null &&
                            providerheader.chkHeader.t15 != "") {
                          for (var i = 0;
                              i <
                                  memberScanProvider
                                      .getMemberScan()
                                      .cardBalance
                                      .length;
                              i++) {
                            if (memberScanProvider
                                    .getMemberScan()
                                    .cardBalance[i]
                                    .creditCode ==
                                "CITYCASH") {
                              cardPreviousBalance = memberScanProvider
                                  .getMemberScan()
                                  .cardBalance[i]
                                  .creditAmount;
                            } else {
                              pointPreviousBalance = memberScanProvider
                                  .getMemberScan()
                                  .cardBalance[i]
                                  .creditAmount;
                            }
                          }
                        }

                        if (point != 0 && cash == 0) {
                          //POINT ONLY
                          // Fluttertoast.showToast(msg: 'Point only : $point');
                          iscontinue = false;

                          cardusageProvider
                              .fetchCardUsage(
                                  memberScanProvider.getMemberScan(),
                                  providerheader.chkHeader,
                                  provider.totalAmount.toInt(),
                                  cash.toInt(),
                                  1,
                                  point)
                              .then((result) {
                            cardUsage = result;
                            if (cardUsage.resultCode == "200") {
                              for (var i = 0; i < cardUsage.dd.length; i++) {
                                if (cardUsage.dd[i].type == "Money") {
                                  cardBalance = cardUsage.dd[i].amount;
                                } else {
                                  pointBalance = cardUsage.dd[i].amount;
                                }
                              }

                              T2pPaymentList t2pPaymentData =
                                  new T2pPaymentList(
                                      paymentType: "CITYPOINT",
                                      paidBy: memberScanProvider
                                          .getMemberScan()
                                          .cardType,
                                      cardNumber: memberScanProvider
                                          .getMemberScan()
                                          .cardNumber,
                                      prevPoint: pointPreviousBalance,
                                      pointBalance: pointBalance,
                                      prevAmt: cardPreviousBalance,
                                      amtBalance: cardBalance);
                              t2pPaymentDataList.add(t2pPaymentData);
                              iscontinue = true;
                            } else if (cardUsage.resultCode == "300" &&
                                cardUsage.resultDesc.contains(
                                    "Duplicate submited RequestNumber")) {
                              cardUsageDuplicate = true;
                              iscontinue = true;
                            } else {
                              Fluttertoast.showToast(
                                  msg: "${cardUsage.resultDesc}",
                                  timeInSecForIosWeb: 4);
                              // Navigator.pop(context);   
                              if (cardUsage.resultDesc
                                    == "This Slip is already paid!") {
                                  provider.chkdtlsList = [];
                                  providerheader.chkHeader = null;
                                  if (provider.totalAmount == 0.0) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => SplashsScreen(),
                                      ),
                                    );
                                  }
                                }else{
                                  Navigator.pop(context);}
                            }
                            if (iscontinue) {
                              savePaymentProcess();
                            }
                          });
                        } else if (point != 0 && cash != 0) {
                          //  Terminal plus point
                          // Fluttertoast.showToast(msg: 'Terminal plus point : $point');
                          iscontinue = false;
                          cardusageProvider
                              .fetchCardUsage(
                                  memberScanProvider.getMemberScan(),
                                  providerheader.chkHeader,
                                  provider.totalAmount.toInt(),
                                  cash.toInt(),
                                  1,
                                  point)
                              .then((result) {
                            cardUsage = result;
                            if (cardUsage.resultCode == "200") {
                              //iscontinue = true;
                              for (var i = 0; i < cardUsage.dd.length; i++) {
                                if (cardUsage.dd[i].type == "Money") {
                                  cardBalance = cardUsage.dd[i].amount;
                                } else {
                                  pointBalance = cardUsage.dd[i].amount;
                                }
                              }

                              T2pPaymentList t2pPaymentData =
                                  new T2pPaymentList(
                                      paymentType: "CITYPOINT",
                                      paidBy: memberScanProvider
                                          .getMemberScan()
                                          .cardType,
                                      cardNumber: memberScanProvider
                                          .getMemberScan()
                                          .cardNumber,
                                      prevPoint: pointPreviousBalance,
                                      pointBalance: pointBalance,
                                      prevAmt: cardPreviousBalance,
                                      amtBalance: cardBalance);
                              t2pPaymentDataList.add(t2pPaymentData);
                              iscontinue = true;
                            } else if (cardUsage.resultCode == "300" &&
                                cardUsage.resultDesc.contains(
                                    "Duplicate submited RequestNumber")) {
                              cardUsageDuplicate = true;
                              iscontinue = true;
                            } else {
                              Fluttertoast.showToast(
                                  msg: "${cardUsage.resultDesc}",
                                  timeInSecForIosWeb: 4);
                              // Navigator.pop(context);
                              if (cardUsage.resultDesc
                                    == "This Slip is already paid!") {
                                  provider.chkdtlsList = [];
                                  providerheader.chkHeader = null;
                                  if (provider.totalAmount == 0.0) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => SplashsScreen(),
                                      ),
                                    );
                                  }
                                }else{
                                  Navigator.pop(context);}
                            }
                            if (iscontinue) {
                              // screen change
                         
                              paymentTerminal(cash.toString());
                              setState(() {
                                flag = false;
                              });
                              
                            }
                          });
                        } else {
                          // Terminal ONLY =
                    
                          paymentTerminal(cash.toString());
                          
                            setState(() {
                                flag = false;
                              });
                        
                        }
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "No Internet Connection", timeInSecForIosWeb: 4);
                    }
                  });
                }
              },
            ),
          ): Container(margin: EdgeInsets.only(right: 50.0),
            height: MediaQuery.of(context).size.height / 16,
            width: MediaQuery.of(context).size.width / 2,
            child:       RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(22.0),
                  side: BorderSide(color: Colors.orange)),
              color: Colors.orange,
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed:null),),
          SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(
                Icons.reply,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool validation() {
    bool isReturn = true;
    //double valueCash = 0;
    double valuePoint = 0;
    //double total = widget.total;
    // print('widget cash ${widget.cash}');
    if (widget.cash != null && widget.point != null) {
      //valueCash = double.parse(widget.cash);
      valuePoint = double.parse(widget.point);

      //     if ((valueCash + valuePoint) < total) {
      //   isReturn = false;
      //   Fluttertoast.showToast(
      //       msg: getTranslated(context, "not_enough_amount"),
      //       timeInSecForIosWeb: 4);
      //   Navigator.pop(context);
      // }
    }
    print("Value ----- $_value");
    print("RemainValue ----- $_remainValue");
    if (_value.round() < 0 || _remainValue.round() < 0) {
      isReturn = false;
      Fluttertoast.showToast(
          msg: getTranslated(context, "invalid_amount"), timeInSecForIosWeb: 4);
    }

    if (valuePoint < _remainValue * 100) {
      isReturn = false;
      _showDialog(getTranslated(context, "point_balance_not_enough"));
      // Fluttertoast.showToast(
      //     msg: getTranslated(context, "not_enough_amount"),
      //     timeInSecForIosWeb: 4);
      // Navigator.pop(context);
    }

    return isReturn;
  }
}

// }
