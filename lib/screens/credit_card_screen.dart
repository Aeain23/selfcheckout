import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../models/check_header_item.dart';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';
import '../screens/splash_screen.dart';
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
import '../screensize_reducer.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/round_slider_track_shape.dart';
import '../models/t2printData.dart';
import '../providers/connectionprovider.dart';
import 'package:spring_button/spring_button.dart';

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
  List<PaymentData> paymentdataListNew = [];
  bool cardUsageDuplicate = false;
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
  int resultSendMessage = 0;
  String resultReturnMessage = "";
  @override
  void initState() {
    super.initState();
    _value = (widget.total ~/ 100).toDouble();
    if (widget.cash == null && widget.point == null) {
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
    try {
      resultSendMessage = await platform.invokeMethod('paymentTerminal', {
        "mbalanceDue": mbalanceDue,
      });
      if (resultSendMessage > 0) {
        readReturnMessage();
      } else {
        setState(() {
          Future.delayed(Duration(seconds: 1)).then((va) {
            dialog.hide().whenComplete(() {
              Fluttertoast.showToast(
                  msg: getTranslated(context, "error_tran"),
                  timeInSecForIosWeb: 5);
              Navigator.of(context).pop();
            });
          });
        });
      }
    } on PlatformException catch (e) {
      dialog.hide().whenComplete(() {
        Fluttertoast.showToast(msg: "${e.message}");
      });
    }
  }

  Future<Null> readReturnMessage() async {
    try {
      int i = 0;
      Timer.periodic(Duration(seconds: 5), (timer) async {
        i = i + 5;
        resultReturnMessage =
            await platform.invokeMethod('readReturnMessage', {});
        print("terminal return before json $resultReturnMessage");
        if (resultReturnMessage != "") {
          var map = json.decode(resultReturnMessage);
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
              timer.cancel();
            } else if (resultMessage.stx == 2 &&
                resultMessage.len == 20 &&
                resultMessage.etx == 3) {
              setState(() {
                Future.delayed(Duration(seconds: 1)).then((va) {
                  dialog.hide().whenComplete(() {
                    Fluttertoast.showToast(
                        msg: getTranslated(context, "card_trans_by_system"),
                        timeInSecForIosWeb: 5);
                    Navigator.of(context).pop();
                  });
                });
              });
              timer.cancel();
            } else {
              setState(() {
                Future.delayed(Duration(seconds: 1)).then((va) {
                  dialog.hide().whenComplete(() {
                    Fluttertoast.showToast(
                        msg: getTranslated(context, "error_tran"),
                        timeInSecForIosWeb: 5);
                    Navigator.of(context).pop();
                  });
                });
              });
              timer.cancel();
            }
          } else {
            setState(() {
              Future.delayed(Duration(seconds: 1)).then((va) {
                dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: getTranslated(context, "error_tran"),
                      timeInSecForIosWeb: 5);
                  Navigator.of(context).pop();
                });
              });
            });
            timer.cancel();
          }
        } else if (i >= 90) {
          setState(() {
            Future.delayed(Duration(seconds: 1)).then((va) {
              dialog.hide().whenComplete(() {
                Fluttertoast.showToast(
                    msg: getTranslated(context, "tran_timeout"),
                    timeInSecForIosWeb: 5);
                Navigator.of(context).pop();
              });
            });
          });
          timer.cancel();
        }
      });
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

    paymentData = new PaymentData(
        id: "0",
        syskey: 0,
        autokey: 0,
        createddate: providerheader.chkHeader.createddate,
        modifieddate: providerheader.chkHeader.modifieddate,
        userid: payTypeCode,
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

    paymentdataListNew.add(paymentData);

    if (paymentdataList.length > 0) {
      dialog = new ProgressDialog(context, isDismissible: false);
      dialog.style(
        message: "Please Wait...",
        progressWidget: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor),
          ),
        ),
        insetAnimCurve: Curves.easeInOut,
      );
      dialog.show();
      String formattedTime = DateFormat("HHmmss").format(DateTime.now());
      CheckHeader chkHdr = providerheader.chkHeader;
      chkHdr.t11 = formattedTime;
      Provider.of<SavePaymentProvider>(context, listen: false)
          .fetchSavePayment(
              paymentdataList,
              chkHdr,
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
              paymentdataListNew,
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
                          chkHdr)),
                );
              });
            });
          }
        } else {
          dialog.hide().whenComplete(() {
            Fluttertoast.showToast(
                msg: "${onResult.result}", timeInSecForIosWeb: 4);
            if (onResult.result == "This Slip is already paid!") {
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
    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 8),
                                          child: Text(
                                            getTranslated(
                                                context, "credit_card"),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 30),
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 8),
                                          child: Text(
                                            "Ks ${numSeparate(double.parse(widget.cash).round())}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 8),
                                          child: Text(
                                            getTranslated(context, "points"),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 30),
                                          child: Text(
                                            ":",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          width: screenWidth(context,
                                              dividedBy: 8),
                                          child: Text(
                                            "${numSeparate(double.parse(widget.point).round())}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .buttonColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            getTranslated(context, "total"),
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).buttonColor),
                          ),
                        ),
                        Text(
                          "Ks ${numSeparate(provider.totalAmount.round())}",
                          style: TextStyle(
                            fontSize: 28,
                            color: Theme.of(context).buttonColor,
                          ),
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
                          getTranslated(context, "payment_by_credit_card"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Card(
                            elevation: 3,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 84.0),
                                        child: Text(
                                          getTranslated(context, "credit_card"),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 28.0),
                                        child: IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.minusCircle),
                                          alignment: Alignment.centerLeft,
                                          color: Color(0xFFA5418C),
                                          onPressed: _remainValue <= 0 || widget.cash == null &&
                                                    widget.point == null
                                              ? null 
                                              : () {
                                                  print(_value);
                                                  print(_remainValue);
                                                  if (_remainValue > 0) {
                                                    setState(() {
                                                      _remainValue =
                                                          _remainValue.round() -
                                                              1.0;
                                                      _value =
                                                          _value.round() + 1.0;
                                                    });
                                                  }
                                                },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color,
                                          inactiveTrackColor: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color,
                                          trackShape:
                                              RoundSliderTrackShape(radius: 10),
                                          trackHeight: 13.0,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 12.0),
                                          thumbColor: Colors.grey,
                                          overlayColor: Colors.grey,
                                        ),
                                        child: Slider(
                                           value: widget.cash == null &&
                                                    widget.point == null
                                                ? 0
                                                : _value,
                                            min: 0,
                                            max: max.toDouble(),
                                          onChanged: (double newValue) {
                                            setState(() {
                                              _value = newValue.roundToDouble();
                                            });

                                            _remainValue =
                                                (provider.totalAmount.round() ~/
                                                        100) -
                                                    _value.roundToDouble();
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(FontAwesomeIcons.plusCircle),
                                        color: Color(0xFFA5418C),
                                        onPressed: _value <= 0 || widget.cash == null &&
                                                    widget.point == null
                                       
                                            ? null
                                            : () {
                                                if (_value > 0) {
                                                  print(_value);
                                                  print(_remainValue);
                                                  setState(() {
                                                    _value =
                                                        _value.round() - 1.0;
                                                    _remainValue =
                                                        _remainValue.round() +
                                                            1.0;
                                                  });
                                                }
                                              },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 100.0),
                                        child: Text(
                                          getTranslated(context, "points"),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          "   Ks ${numSeparate(_value.round() * 100 + remainder)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 11,
                                        child: Text(
                                          "",
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 64.0),
                                          child: Text(
                                            "${numSeparate(_remainValue.round() * 100)}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
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
                                          getTranslated(context, "to_be_paid"),
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
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 56.0),
                                          child: Text(
                                            getTranslated(
                                                context, "to_be_used"),
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 50.0),
            height: MediaQuery.of(context).size.height / 16,
            width: MediaQuery.of(context).size.width / 2,
            child: SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    "Confirm",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              onTap: () async {
                dialog = new ProgressDialog(context, isDismissible: false);
                dialog.style(
                  message: "Please Wait...",
                  progressWidget: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  insetAnimCurve: Curves.easeInOut,
                );
                bool isValid = validation();
                if (isValid) {
                  await connectionProvider
                      .checkconnection()
                      .then((onValue) async {
                    await dialog.show();
                    if (onValue) {
                      point = _remainValue.round() * 100;
                      cash = _value.round() * 100 + remainder;
                      if ((point + cash).toString() == total) {
                        String cardBalance = "0";
                        String pointBalance = "0";
                        String cardPreviousBalance = "0";
                        String pointPreviousBalance = "0";
                        if (providerheader.chkHeader.t15 != null &&
                            providerheader.chkHeader.t15 != "") {
                          for (int i = 0;
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
                              for (int i = 0; i < cardUsage.dd.length; i++) {
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
                              if (cardUsage.resultDesc ==
                                  "This Slip is already paid!") {
                                provider.removeAll();
                                providerheader.chkHeader = null;
                                if (provider.totalAmount == 0.0) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SplashsScreen(),
                                    ),
                                  );
                                }
                              } else {
                                Navigator.pop(context);
                              }
                            }
                            if (iscontinue) {
                              savePaymentProcess();
                            }
                          });
                        } else if (point != 0 && cash != 0) {
                          //  Terminal plus point
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
                              for (int i = 0; i < cardUsage.dd.length; i++) {
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
                              if (cardUsage.resultDesc ==
                                  "This Slip is already paid!") {
                                provider.removeAll();
                                providerheader.chkHeader = null;
                                if (provider.totalAmount == 0.0) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SplashsScreen(),
                                    ),
                                  );
                                }
                              } else {
                                Navigator.pop(context);
                              }
                            }
                            if (iscontinue) {
                              // screen change
                              paymentTerminal(cash.toString());
                            }
                          });
                        } else {
                          // Terminal ONLY
                          paymentTerminal(cash.toString());
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
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            elevation: 10,
            backgroundColor: Theme.of(context).buttonColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(
                Icons.reply,
                color: Theme.of(context).textTheme.button.color,
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
              shape: InputBorder.none,
              child: new Text(
                "Ok",
                style: TextStyle(color: Color(0xFF6F51A1)),
              ),
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
    double valuePoint = 0;
    if (widget.cash != null && widget.point != null) {
      valuePoint = double.parse(widget.point);
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
    }
    return isReturn;
  }
}
