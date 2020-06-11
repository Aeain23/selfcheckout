// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:number_display/number_display.dart';
// import 'package:provider/provider.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../localization/language_constants.dart';
// import '../models/payment_currency.dart';
// import '../models/payment_type.dart';
// import '../providers/payment_currency_provider.dart';
// import '../providers/payment_type_provider.dart';
// import '../models/terminal_result_message.dart';
// import '../models/card_usage.dart';
// import '../providers/card_usage_provider.dart';
// import '../providers/member_scan_provider.dart';
// import '../providers/save_checkheader_provider.dart';
// import '../providers/stock_provider.dart';
// import '../screens/insert_card_screen.dart';
// import '../widgets/app_bar_widget.dart';
// import '../widgets/round_slider_track_shape.dart';
// import '../models/t2printData.dart';
// import '../providers/connectionprovider.dart';

// class CityCashTerminal extends StatefulWidget {
//   final String cash;
//   final String point;
//   final double total;
//   final String name;
//   final bool terminalFlag;
//   final int couponcount;
//   CityCashTerminal(
//       {this.cash,
//       this.point,
//       this.total,
//       this.name,
//       this.terminalFlag,
//       this.couponcount});

//   @override
//   _CityCashTerminalState createState() => _CityCashTerminalState();
// }

// class _CityCashTerminalState extends State<CityCashTerminal> {
//   var numSeparate;
// String ref;
//   double _remainValue = 0;
//   double _value;
//   int remainder;
//   int max, cityCash, creditAmount;
//   CardUsage cardUsage;
//   List<T2pPaymentList> t2pPaymentDataList = [];
//   List<Currency> currencyList = [];
//   List<PaymentType> payTypeList = [];
//   bool iscontinue = false;
//   TerminalResultMessage resultMessage = new TerminalResultMessage(
//       etx: null,
//       len: null,
//       mAccountNo: null,
//       mAmount: null,
//       mApprovalCode: null,
//       mCardType: null,
//       mCurrencyCode: null,
//       mDate: null,
//       mExpDate: null,
//       mInvoiceNo: null,
//       mMerchantID: null,
//       mPAN: null,
//       mPOSEntry: null,
//       mRRN: null,
//       mRespCode: null,
//       mSTAN: null,
//       mTerminalID: null,
//       mTime: null,
//       stx: null);
//   // var resultMessage;
//     void refCode() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     setState(() {
     
//       ref = preferences.getString("ref");
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     refCode() ;
//     _value = (widget.total ~/ 100).toDouble();
//     // if (widget.point == null) {
//     if (widget.total == null) {
//       max = 0;
//     }
//     //  else if (double.parse(widget.point).round() < 100) {
//     //   max = 0;
//     // }
//     else {
//       // max = (double.parse(widget.point).round() ~/ 100);
//       max = (widget.total.round() ~/ 100);
//     }
//   }

//   ProgressDialog dialog;
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<StockProvider>(context);
//     String total = provider.totalAmount.round().toString();
//     final providerheader =
//         Provider.of<SaveCheckHeaderProvider>(context, listen: false);
//     final cardusageProvider = Provider.of<CardUsageProvider>(context);
//     final memberScanProvider = Provider.of<MemberScanProvider>(context);
//     final connectionProvider = Provider.of<ConnectionProvider>(context);
//     remainder = provider.totalAmount.round() % 100;
//     final paymentTypeProvider =
//         Provider.of<PaymentTypeProvider>(context, listen: false);
//     final currencyProvider =
//         Provider.of<PaymentCurrencyProvider>(context, listen: false);
//     paymentTypeProvider.fetchPaymentType().catchError((onError) {
//       // dialog.hide();
//     }).then((result) {
//       print("payment list in city cash $result");
//       payTypeList = result;
//     });
//     print('Pay list $payTypeList');
//     currencyProvider.fetchCurrency().catchError((onError) {
//       // dialog.hide();
//     }).then((result) {
//       print("currency list in city cash $result");
//       currencyList = result;
//     });
//     print('currency list $currencyList');
//     numSeparate = createDisplay(length: 16, separator: ',');

//     dialog = new ProgressDialog(context, isDismissible: false);
//     dialog.style(
//       message: "Please Wait...",
//       progressWidget: Center(
//         child: CircularProgressIndicator(),
//       ),
//       insetAnimCurve: Curves.easeInOut,
//     );
//     return Scaffold(
//       appBar: AppBarWidget(),
//       body: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       (widget.cash != null || widget.point != null)
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 Image.asset("assets/images/city_reward.jpg"),
//                                 Text(
//                                   "  Welcome back ${widget.name},",
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             )
//                           : SizedBox(),
//                       (widget.cash != null || widget.point != null)
//                           ? Column(
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 18.0),
//                                   child: Text(
//                                       "You have in your City Rewards balance"),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     top: 20.0,
//                                   ),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Text("CityCash: "),
//                                       Text(
//                                           "Ks ${numSeparate(double.parse(widget.cash).round())}"),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Text("Points:  "),
//                                       Text(
//                                           "${numSeparate(double.parse(widget.point).round())}"),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : SizedBox(),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0),
//                         child: Text(
//                           "Total",
//                           style: TextStyle(fontSize: 28, color: Colors.orange),
//                         ),
//                       ),
//                       Text(
//                         "Ks ${numSeparate(provider.totalAmount.round())}",
//                         style: TextStyle(fontSize: 28, color: Colors.orange),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       Text(
//                         "Payment by Credit Card",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 30.0),
//                         child: Card(
//                           color: Colors.white70,
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     flex: 3,
//                                     child: Text(
//                                       "Credit Card",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 5,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: <Widget>[
//                                         SliderTheme(
//                                           data:
//                                               SliderTheme.of(context).copyWith(
//                                             activeTrackColor: Colors.orange,
//                                             inactiveTrackColor: Colors.orange,
//                                             trackShape: RoundSliderTrackShape(
//                                                 radius: 10),
//                                             trackHeight: 13.0,
//                                             thumbColor: Colors.grey,
//                                             overlayColor: Colors.grey,
//                                           ),
//                                           child: Slider(
//                                             value: _value,
//                                             min: 0,
//                                             max: max.toDouble(),
//                                             onChanged: (double newValue) {
//                                               setState(() {
//                                                 _value = newValue;
//                                               });
//                                               _remainValue = ((provider
//                                                           .totalAmount
//                                                           .round() ~/
//                                                       100) -
//                                                   _value);
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Text(
//                                       "  City Cash",
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   Expanded(
//                                     flex: 2,
//                                     child: Text(
//                                       "  Ks ${_value.round() * 100 + remainder}",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 20),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 3,
//                                     child: Text(
//                                       "",
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Text(
//                                       "${_remainValue.round() * 100}",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 20),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     Expanded(
//                                       flex: 2,
//                                       child: Text(
//                                         "To be paid",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontStyle: FontStyle.italic),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 3,
//                                       child: Text(
//                                         "",
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 2,
//                                       child: Text(
//                                         "   To be used",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontStyle: FontStyle.italic),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(right: 50.0),
//             height: MediaQuery.of(context).size.height / 16,
//             width: MediaQuery.of(context).size.width / 2,
//             child: RaisedButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: new BorderRadius.circular(22.0),
//                   side: BorderSide(color: Colors.orange)),
//               color: Colors.orange,
//               child: Text(
//                 "Confirm",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//               onPressed: () {
//                 bool isValid = validation();
//                 if (isValid) {
//                   connectionProvider.checkconnection().then((onValue) {
//                     dialog.show();
//                     if (onValue) {
//                       cityCash = _remainValue.round() * 100;
//                       creditAmount = _value.round() * 100 + remainder;
//                       //TerminalResultMessage result;
//                       // TerminalResultMessage termianlReturn = paymentTerminal(cash.toString());
//                       // paymentTerminal(cash.toString()).then((onResult) {
//                       //   result = onResult;
//                       // });
//                       print("point $cityCash");
//                       print("cash $creditAmount");
//                       print("total $total");

//                       // bool saypayment=false;
//                       // if (cash.toString() == total || point.toString() == total) {
//                       //   saypayment = true;
//                       // } else {
//                       //   saypayment = false;
//                       // }
//                       //bool iscontinue = false;

//                       print('point in confirm >> $cityCash');
//                       if ((cityCash + creditAmount).toString() == total) {
//                         if (cityCash != 0) {
//                           iscontinue = false;
//                           String cardBalance = "0";
//                           String pointBalance = "0";
//                           String cardPreviousBalance = "0";
//                           String pointPreviousBalance = "0";
//                           //String creditExpirePoint = "0";
//                           //String cardExpire = "";
//                           for (var i = 0;
//                               i <
//                                   memberScanProvider
//                                       .getMemberScan()
//                                       .cardBalance
//                                       .length;
//                               i++) {
//                             if (memberScanProvider
//                                     .getMemberScan()
//                                     .cardBalance[i]
//                                     .creditCode ==
//                                 "CITYCASH") {
//                               cardPreviousBalance = memberScanProvider
//                                   .getMemberScan()
//                                   .cardBalance[i]
//                                   .creditAmount;
//                             } else {
//                               pointPreviousBalance = memberScanProvider
//                                   .getMemberScan()
//                                   .cardBalance[i]
//                                   .creditAmount;
//                               // creditExpirePoint = memberScanProvider
//                               //     .getMemberScan()
//                               //     .cardBalance[i]
//                               //     .creditExpireAmount;
//                               // cardExpire = memberScanProvider
//                               //     .getMemberScan()
//                               //     .cardBalance[i]
//                               //     .creditExpireDate;
//                             }
//                           }
//                           cardusageProvider
//                               .fetchCardUsage(
//                                   memberScanProvider.getMemberScan(),
//                                   providerheader.chkHeader,
//                                   provider.totalAmount.toInt(),
//                                   cityCash,
//                                   0,
//                                   creditAmount,
                                 
//                                   )
//                               .then((result) {
//                             cardUsage = result;
//                             if (cardUsage.resultCode == "200") {
//                               //iscontinue = true;
//                               for (var i = 0; i < cardUsage.dd.length; i++) {
//                                 if (cardUsage.dd[i].type == "Money") {
//                                   cardBalance = cardUsage.dd[i].amount;
//                                 } else {
//                                   pointBalance = cardUsage.dd[i].amount;
//                                 }
//                               }

//                               T2pPaymentList t2pPaymentData =
//                                   new T2pPaymentList(
//                                       paymentType: "CITYCASH",
//                                       paidBy: memberScanProvider
//                                           .getMemberScan()
//                                           .cardType,
//                                       cardNumber: memberScanProvider
//                                           .getMemberScan()
//                                           .cardNumber,
//                                       prevPoint: pointPreviousBalance,
//                                       pointBalance: pointBalance,
//                                       prevAmt: cardPreviousBalance,
//                                       amtBalance: cardBalance);
//                               t2pPaymentDataList.add(t2pPaymentData);
//                               iscontinue = true;
//                             } else if (cardUsage.resultCode == "300" &&
//                                 cardUsage.resultDesc.contains(
//                                     "Duplicate submited RequestNumber")) {
//                               iscontinue = true;
//                             } else {
//                               Fluttertoast.showToast(
//                                   msg: "${cardUsage.resultDesc}",
//                                   timeInSecForIosWeb: 4);
//                               Navigator.pop(context);
//                             }
//                             // if (cardUsage.resultCode != "200") {
//                             //   Fluttertoast.showToast(msg: cardUsage.resultDesc);
//                             //   //iscontinue = false;
//                             // }

//                             // if (t2pPaymentDataList.length > 0) {
//                             if (iscontinue) {
//                               Navigator.of(context).pushReplacement(
//                                 MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         InsertCardScreen(
//                                             creditAmount.toString(),
//                                             cardUsage,
//                                             cityCash,
//                                             t2pPaymentDataList,
//                                             widget.terminalFlag,
//                                             widget.couponcount,
//                                             0,
//                                             currencyList,
//                                             payTypeList)),
//                               );
//                             }
//                           });
//                         } else {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     InsertCardScreen(
//                                         creditAmount.toString(),
//                                         cardUsage,
//                                         cityCash,
//                                         t2pPaymentDataList,
//                                         widget.terminalFlag,
//                                         widget.couponcount,
//                                         0,
//                                         currencyList,
//                                         payTypeList)),
//                           );
//                         }
//                         // if ((cash != 0 && point == 0) ||
//                         //     (point != 0 && cash == 0 && iscontinue) ||
//                         //     (cash != 0 && point != 0 && iscontinue)) {

//                         // }
//                       }
//                     } else {
//                       Fluttertoast.showToast(
//                           msg: "No Internet Connection", timeInSecForIosWeb: 4);
//                     }
//                   });
//                 }
//               },
//             ),
//           ),
//           SizedBox(width: 20),
//           FloatingActionButton(
//             backgroundColor: Colors.white,
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               child: Icon(
//                 Icons.reply,
//                 color: Colors.black,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   bool validation() {
//     bool isReturn = true;
//     double valueCash = double.parse(widget.cash);
//     double valuePoint = double.parse(widget.point);
//     double total = widget.total;
//     print("Value ----- $_value");
//     print("RemainValue ----- $_remainValue");
//     if (_value.round() < 0 || _remainValue.round() < 0) {
//       isReturn = false;
//       Fluttertoast.showToast(
//           msg: getTranslated(context, "invalid_amount"), timeInSecForIosWeb: 4);
//     }

//     if ((valueCash + valuePoint) < total) {
//       isReturn = false;
//       Fluttertoast.showToast(
//           msg: getTranslated(context, "not_enough_amount"),
//           timeInSecForIosWeb: 4);
//       Navigator.pop(context);
//     }

//     if (valueCash < _remainValue * 100) {
//       isReturn = false;
//       Fluttertoast.showToast(
//           msg: getTranslated(context, "not_enough_amount"),
//           timeInSecForIosWeb: 4);
//       Navigator.pop(context);
//     }

//     return isReturn;
//   }
// }
