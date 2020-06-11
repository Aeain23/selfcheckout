import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/models/check_header_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';
import '../models/member_scan.dart';
import '../models/payment_data.dart';
import '../models/promotion_use.dart';
import '../models/t2printData.dart';
import '../providers/print_citycard_provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/main_screen.dart';

class PaymentSuccessWidget extends StatefulWidget {
  final MemberScan memberScan;
  final int cash;
  final int point;
  final PromotionUse promotionUse;
  final List<PaymentData> paymentDataList;
  final List<T2pPaymentList> t2pPaymentList;
  final int couponCount;
  final CheckHeader checkHeader;
  PaymentSuccessWidget(
      this.memberScan,
      this.cash,
      this.point,
      this.promotionUse,
      this.paymentDataList,
      this.t2pPaymentList,
      this.couponCount,
      this.checkHeader);
  @override
  _PaymentSuccessWidgetState createState() => _PaymentSuccessWidgetState();
}

class _PaymentSuccessWidgetState extends State<PaymentSuccessWidget> {
  String counter, username, macAddress, system, locCode, branch;
  void getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(
      () {
        locCode = sharedPreferences.getString("locationCode");
        branch = sharedPreferences.getString("branch");
        print('branch $branch');
        print('locCode $locCode');
      },
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  String response = "";
  static const platform = const MethodChannel('flutter.native/helper');

  Future<Null> responseFromNativeCode(
    String data,
    String isreprint,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      counter = sharedPreferences.getString("getCounter");
      username = sharedPreferences.getString("username");
      macAddress = sharedPreferences.getString("macAddress");
      system = sharedPreferences.getString("name");
      print("system$system");
      print("counter $counter");
      print("username $username");
      print("macAddress $macAddress");
    });
    try {
      final String result = await platform.invokeMethod('helloFromNativeCode', {
        "data": data,
        "system": system,
        "counter": counter,
        "userid": username,
        "isreprint": isreprint,
        "macAddress": macAddress,
      });

      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }

  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final printerprovider =
        Provider.of<PrintCitycardProvider>(context, listen: false);
    final saveCheckProvider =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    print('Header data  ${widget.checkHeader}');
    var printString = printerprovider.fetchPrint(
        widget.checkHeader,
        widget.memberScan,
        stockProvider.getchkdtlsList(),
        widget.cash,
        widget.point,
        widget.promotionUse,
        widget.paymentDataList,
        widget.t2pPaymentList,
        branch,
        widget.couponCount);
    print("Print string $printString");
    if (stockProvider.chkdtlsList.length != 0) {
      responseFromNativeCode(printString, "false").then((value) {
        stockProvider.chkdtlsList = [];
        saveCheckProvider.chkHeader = null;
      });
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              getTranslated(context, "payment"),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              getTranslated(context, "successful"),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset("assets/images/true.jpg"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/qr.jpg",
                height: 300,
              ),
            ),
            Text(getTranslated(context, "please_take_your_receipt"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(getTranslated(context, "exiting_in"),
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                )),
          ],
        ),
      ),
    );
  }
}
