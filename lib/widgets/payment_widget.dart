import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/providers/save_checkheader_provider.dart';
import 'package:self_check_out/screens/splash_screen.dart';
import '../localization/language_constants.dart';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';
import '../widgets/card_widget.dart';
import '../widgets/city_cash_widget.dart';
import '../providers/stock_provider.dart';
import '../screens/credit_card_screen.dart';

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
              child: new Text(getTranslated(context, "ok")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void _cashOrPointDialog() {
  //   Widget optionOne = SimpleDialogOption(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text('City Cash', style: TextStyle(color: Colors.blue, fontSize: 16)),
  //         Divider(
  //           color: Colors.black12,
  //         ),
  //       ],
  //     ),
  //     onPressed: () {
  //       print('City Cash');
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => CityCashTerminal(
  //           cash: widget.cash,
  //           point: widget.point,
  //           total: totalAmt,
  //           name: widget.name,
  //           terminalFlag: terminalResponse,
  //           couponcount: widget.cuponCount,
  //         ),
  //       ));
  //     },
  //   );
  //   Widget optionTwo = SimpleDialogOption(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           'City Point',
  //           style: TextStyle(color: Colors.blue, fontSize: 16),
  //         ),
  //         Divider(
  //           color: Colors.black12,
  //         ),
  //       ],
  //     ),
  //     onPressed: () {
  //       print('City Point');
  //       // Navigator.of(context).pop();
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => CreditCardScreen(
  //           cash: widget.cash,
  //           point: widget.point,
  //           total: totalAmt,
  //           name: widget.name,
  //           terminalFlag: terminalResponse,
  //           couponcount: widget.cuponCount,
  //         ),
  //       ));
  //     },
  //   );

  //   // set up the SimpleDialog
  //   SimpleDialog dialog = SimpleDialog(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     title: Center(
  //         child: Text(
  //       'Choose Partial Payment',
  //       style: TextStyle(fontWeight: FontWeight.bold),
  //     )),
  //     children: <Widget>[
  //       optionOne,
  //       optionTwo,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return dialog;
  //     },
  //   );
  // }

  static const platform = const MethodChannel('flutter.native/helper');
  bool terminalResponse = false;
  Future<Null> connectTerminal() async {
    // Fluttertoast.showToast(msg: "Inside the connect Terminal");
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

  // bool terResponse = false;
  // Future<Null> connectTerminal1() async {
  //   try {
  //     final bool result = await platform.invokeMethod('connectTerminal');
  //     terResponse = result;
  //     print('Connect Terminal>>$result');
  //     if (terResponse) {
  //       // _cashOrPointDialog();
  //       Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => CreditCardScreen(
  //           cash: widget.cash,
  //           point: widget.point,
  //           total: totalAmt,
  //           name: widget.name,
  //           terminalFlag: terResponse,
  //           couponcount: widget.cuponCount,
  //         ),
  //       ));
  //     } else {
  //       _showDialog();
  //     }
  //   } on PlatformException catch (e) {
  //     print("Failed to Connect Terminal: '${e.message}'.");
  //   }
  // }

  ProgressDialog dialog;
  Widget _createRaisedButton(Image img, String title, Function handler) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 4,
      child: RaisedButton(
        textColor: Colors.black,
        color: Colors.white70,
        onPressed: handler,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(title), img],
        ),
      ),
    );
  }

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
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    numSeparate = createDisplay(length: 16, separator: ',');
    return (widget.cash != null || widget.point != null)
        ? SingleChildScrollView(
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
                                          title: Text(getTranslated(
                                              context, "want_to_change_card")),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                  getTranslated(context, "no")),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(getTranslated(
                                                  context, "yes")),
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
                                      color: Colors.purple,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        // Container(
                        //  margin: EdgeInsets.only(left: 280),
                        //   height: MediaQuery.of(context).size.height/30,
                        //       width: MediaQuery.of(context).size.width/2 ,
                        //       child:
                        //           Image.asset('assets/images/clickme.gif')),

                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(getTranslated(context,
                              "you_have_in_your_city_rewards_balance")),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(getTranslated(context, "city_cash")),
                                    Text(
                                        ": Ks ${numSeparate(double.parse(widget.cash).round())}"),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(getTranslated(context, "points")),
                                      Text(
                                          ": ${numSeparate(double.parse(widget.point).round())}"),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text(
                            getTranslated(context, "total"),
                            style:
                                TextStyle(fontSize: 28, color: Colors.orange),
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
                SizedBox(
                  height: 20,
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
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _createRaisedButton(
                                Image.asset("assets/images/city_reward.jpg"),
                                "City Cash",
                                () {
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
                                            content: Text(getTranslated(context,
                                                "your_amount_is_insufficient")),
                                            actions: <Widget>[
                                              RaisedButton(
                                                textColor: Colors.lightBlue,
                                                child: Text(getTranslated(
                                                    context,
                                                    "change_payment_type")),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              RaisedButton(
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
                                                    provider.chkdtlsList = [];
                                                    providerheader.chkHeader =
                                                        null;
                                                    if (provider.totalAmount ==
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
                              ),
                              _createRaisedButton(
                                  Image.asset("assets/images/visa.jpg"),
                                  "Credit & Debit Cards", () {
                                // _cashOrPointDialog();
                                connectTerminal();
                              }),
                              _createRaisedButton(
                                  Image.asset("assets/images/wave.jpg"),
                                  "Mobile Wallets",
                                  () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  getTranslated(context, "total"),
                  style: TextStyle(fontSize: 28, color: Colors.orange),
                ),
                Text(
                  "Ks ${numSeparate(provider.totalAmount.round())}",
                  style: TextStyle(fontSize: 28, color: Colors.orange),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                            getTranslated(context, "choose_payment_method"),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _createRaisedButton(
                                  Image.asset("assets/images/visa.jpg"),
                                  "Credit & Debit Cards", () {
                                // _cashOrPointDialog();
                                // Fluttertoast.showToast(msg: "Try to call terminal in payment Widget: ");
                                connectTerminal();
                              }),
                              _createRaisedButton(
                                  Image.asset("assets/images/wave.jpg"),
                                  "Mobile Wallets",
                                  () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
