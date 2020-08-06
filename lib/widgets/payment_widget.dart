import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../screens/splash_screen.dart';
import '../localization/language_constants.dart';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';
import '../screensize_reducer.dart';
import '../widgets/card_widget.dart';
import '../widgets/city_cash_widget.dart';
import '../providers/stock_provider.dart';
import '../screens/credit_card_screen.dart';
import 'package:flutter_dash/flutter_dash.dart';

class PaymentWidget extends StatefulWidget {
  final String cash;
  final String point;
  final String name;
  final MemberScan memberScan;
  final PromotionUse promotionUse;
  final int cuponCount;
  PaymentWidget(
      {this.cash,
      this.point,
      this.name,
      this.memberScan,
      this.promotionUse,
      this.cuponCount});
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  var numSeparate;
  double totalAmt;
  String cashforCredit;
  String pointforCredit;
  String nameforCredit;
  MemberScan memberScanforCredit;
  PromotionUse promotionUseForCredit;
  int cuponCountforCredit;
  @override
  void initState() {
    setState(() {
      cashforCredit = widget.cash;
      pointforCredit = widget.point;
      nameforCredit = widget.name;
      memberScanforCredit = widget.memberScan;
      promotionUseForCredit = widget.promotionUse;
      cuponCountforCredit = widget.cuponCount;
    });
    super.initState();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(
            getTranslated(context, "cannot_connect_terminal"),
          ),
          actions: <Widget>[
            new FlatButton(
              shape: InputBorder.none,
              child: new Text(
                getTranslated(context, "ok"),
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

  static const platform = const MethodChannel('flutter.native/helper');
  bool terminalResponse = false;
  Future<Null> connectTerminal() async {
    try {
      final bool result = await platform.invokeMethod('connectTerminal');
      terminalResponse = result;
      // Fluttertoast.showToast(msg: 'Connect Terminal>>$result');
      if (terminalResponse) {
        // _cashOrPointDialog();
        // Fluttertoast.showToast(msg: 'navigate to CreditCardScreen>>$terminalResponse');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CreditCardScreen(
            cashforCredit: cashforCredit,
            pointforCredit: pointforCredit,
            nameforCredit: nameforCredit,
            memberScanforCredit: memberScanforCredit,
            promotionUseForCredit: promotionUseForCredit,
            cuponCountforCredit: cuponCountforCredit,
            cash: widget.cash,
            point: widget.point,
            total: totalAmt,
            name: widget.name,
            terminalFlag: terminalResponse,
            couponcount: widget.cuponCount,
          ),
        ));
      } else {
        _showDialog();
      }
    } on PlatformException catch (e) {
      print("Failed to Connect Terminal: '${e.message}'.");
    }
  }

  ProgressDialog dialog;
  // Widget _createRaisedButton(Image img, String title, Function handler) {
  //   return Container(
  //     height: screenHeight(context, dividedBy: 6),
  //     width: screenWidth(context, dividedBy: 4),
  //     child: RaisedButton(
  //       textColor: Color(0xFF6F51A1),
  //       color: Colors.grey[300],
  //       shape: RoundedRectangleBorder(
  //           borderRadius: new BorderRadius.circular(20.0),
  //           side: BorderSide(color: Colors.grey[300])),
  //       onPressed: handler,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Text(title),
  //           img,
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context, listen: true);
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    totalAmt = provider.totalAmount;
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: getTranslated(context, "please_wait"),
      progressWidget: Center(
        child: CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    numSeparate = createDisplay(length: 16, separator: ',');
    return (widget.cash != null || widget.point != null)
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset("assets/images/city_reward.jpg"),
                              Text(
                                getTranslated(context, "welcome_back"),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(getTranslated(context,
                                                "want_to_change_card")),
                                            actions: <Widget>[
                                              FlatButton(
                                                shape: InputBorder.none,
                                                child: Text(
                                                  getTranslated(context, "no"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .buttonColor),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                shape: InputBorder.none,
                                                child: Text(
                                                    getTranslated(
                                                        context, "yes"),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .buttonColor)),
                                                onPressed: () {
                                                  // dialog.show();
                                                  // Future.delayed(
                                                  //         Duration(seconds: 3))
                                                  //     .then((value) {
                                                  //   dialog
                                                  //       .hide()
                                                  //       .whenComplete(() {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CardWidget(),
                                                    ),
                                                  );

                                                  // });
                                                  // });
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "${widget.name},",
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(getTranslated(context,
                                "you_have_in_your_city_rewards_balance")),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: screenWidth(context, dividedBy: 8),
                                  child: Text(
                                    getTranslated(context, "city_cash"),
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: screenWidth(context, dividedBy: 30),
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: screenWidth(context, dividedBy: 8),
                                  child: Text(
                                    "Ks ${numSeparate(double.parse(widget.cash).round())}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
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
                                  width: screenWidth(context, dividedBy: 8),
                                  child: Text(
                                    getTranslated(context, "points"),
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: screenWidth(context, dividedBy: 30),
                                  child: Text(
                                    ":",
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: screenWidth(context, dividedBy: 8),
                                  child: Text(
                                    "${numSeparate(double.parse(widget.point).round())}",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              getTranslated(context, "total"),
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).buttonColor
                                  // color: Color(0xFFFAA755)
                                  ),
                            ),
                          ),
                          Text(
                            "Ks ${numSeparate(provider.totalAmount.round())}",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).buttonColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "choose_payment_method"),
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 38.0),
                                  child: InkWell(
                                    onTap: () {
                                      double cash = double.parse(widget.cash);
                                      double point = double.parse(widget.point);
                                      String name = widget.name;
                                      double total = provider.totalAmount;
                                      print('total in payment $total');
                                      if ((cash + point) < total) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Text(getTranslated(
                                                    context,
                                                    "your_amount_is_insufficient")),
                                                actions: <Widget>[
                                                  RaisedButton(
                                                    elevation: 10,
                                                    hoverElevation: 10,
                                                    splashColor:
                                                        Color(0xFFD6914F),
                                                    textColor: Colors.lightBlue,
                                                    child: Text(getTranslated(
                                                        context,
                                                        "change_payment_type")),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  RaisedButton(
                                                    elevation: 10,
                                                    hoverElevation: 10,
                                                    splashColor:
                                                        Color(0xFFD6914F),
                                                    textColor: Colors.lightBlue,
                                                    child: Text(getTranslated(
                                                        context, "top_up")),
                                                    onPressed: () {
                                                      Provider.of<SaveCheckHeaderProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchVoidCheckHeader(
                                                              providerheader
                                                                  .chkHeader)
                                                          .then((onValue1) {
                                                        print(onValue1);
                                                        provider.chkdtlsList =
                                                            [];
                                                        providerheader
                                                            .chkHeader = null;
                                                        if (provider
                                                                .totalAmount ==
                                                            0.0) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SplashsScreen(),
                                                            ),
                                                          );
                                                        }
                                                      });
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                        // Navigator.pop(context);
                                      } else {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => CityCashWidget(
                                            cash: cash,
                                            point: point,
                                            name: name,
                                            total: total,
                                            memberScan: widget.memberScan,
                                            promotionUse: widget.promotionUse,
                                            couponCount: widget.cuponCount,
                                          ),
                                        ));
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            height: screenHeight(context,
                                                dividedBy: 6),
                                            width: screenWidth(context,
                                                dividedBy: 6),
                                            child: Image.asset(
                                                "assets/images/city.png")),
                                        Text(
                                          "City Cash",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 26.0),
                                  child:
                                   Dash(
                                      direction: Axis.vertical,
                                      length: 300,
                                      dashGap: 0,
                                      dashLength: 30,
                                      dashColor: Theme.of(context).buttonColor),
                                ),
                                InkWell(
                                  onTap: () {
                                    connectTerminal();
                                    //                              Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (context) => CreditCardScreen(
                                    //     cashforCredit: cashforCredit,
                                    //     pointforCredit: pointforCredit,
                                    //     nameforCredit: nameforCredit,
                                    //     memberScanforCredit: memberScanforCredit,
                                    //     promotionUseForCredit: promotionUseForCredit,
                                    //     cuponCountforCredit: cuponCountforCredit,
                                    //     cash: widget.cash,
                                    //     point: widget.point,
                                    //     total: totalAmt,
                                    //     name: widget.name,
                                    //     terminalFlag: terminalResponse,
                                    //     couponcount: widget.cuponCount,
                                    //   ),
                                    // ));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height:
                                            screenHeight(context, dividedBy: 6),
                                        width:
                                            screenWidth(context, dividedBy: 6),
                                        child: Image.asset(
                                            "assets/images/mpu5.png"),
                                      ),
                                      Text(
                                        "Credit & Debit Cards",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Dash(
                              dashBorderRadius: 50,
                              dashGap: 0,
                              direction: Axis.horizontal,
                              length: 600,
                              dashLength: 30,
                              dashColor: Theme.of(context).buttonColor),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height:
                                          screenHeight(context, dividedBy: 6),
                                      width: screenWidth(context, dividedBy: 7),
                                      child: Image.asset(
                                          "assets/images/money.png"),
                                    ),
                                    Text(
                                      "Mobile Wallet",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22),
                                    )
                                  ],
                                ),
                              ),
                                Dash(
                                      direction: Axis.vertical,
                                      length: 300,
                                      dashGap: 0,
                                      dashLength: 30,
                                      dashColor: Theme.of(context).buttonColor),
                              // Dash(
                              //     direction: Axis.vertical,
                              //     length: 400,
                              //     dashGap: 0,
                              //     dashLength: 30,
                              //     dashColor: Theme.of(context).buttonColor),
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        height:
                                            screenHeight(context, dividedBy: 6),
                                        width:
                                            screenWidth(context, dividedBy: 8),
                                        child: Image.asset(
                                            "assets/images/kk.png")),
                                    Text(
                                      "Mobile Wallet",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      getTranslated(context, "total"),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).buttonColor
                          // color: Colors.orange
                          ),
                    ),
                  ),
                  Text(
                    "Ks ${numSeparate(provider.totalAmount.round())}",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).buttonColor
                        // color: Colors.orange
                        ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Text(
                              getTranslated(context, "choose_payment_method"),
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 40.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[

                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    connectTerminal();
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height:
                                            screenHeight(context, dividedBy: 6),
                                        width:
                                            screenWidth(context, dividedBy: 5),
                                        child: Image.asset(
                                            "assets/images/mpu5.png"),
                                      ),
                                      Text(
                                        "Credit & Debit Cards",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          height: screenHeight(context,
                                              dividedBy: 6),
                                          width: screenWidth(context,
                                              dividedBy: 7),
                                          child: Image.asset(
                                              "assets/images/kk.png")),
                                      Text(
                                        "Mobile Wallet",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height:
                                            screenHeight(context, dividedBy: 6),
                                        width:
                                            screenWidth(context, dividedBy: 6),
                                        child: Image.asset(
                                            "assets/images/money.png"),
                                      ),
                                      Text(
                                        "Mobile Wallet",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 22),
                                      )
                                    ],
                                  ),
                                ),
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
          );
  }
}
