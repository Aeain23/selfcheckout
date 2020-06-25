import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/models/check_header_item.dart';
import 'package:self_check_out/providers/print_provider.dart';
import '../localization/language_constants.dart';
import '../models/member_scan.dart';
import '../models/payment_data.dart';
import '../models/promotion_use.dart';
import '../models/t2printData.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../screens/main_screen.dart';
import '../providers/prepare_printdata_provider.dart';

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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final printerprovider =
        Provider.of<PreparePrintDataProvider>(context, listen: false);
    final saveCheckProvider =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final printProvider = Provider.of<PrintProvider>(context, listen: false);
    print('Header data  ${widget.checkHeader}');
    printerprovider
        .fetchPrint(
            widget.checkHeader,
            widget.memberScan,
            stockProvider.getchkdtlsList(),
            widget.cash,
            widget.point,
            widget.promotionUse,
            widget.paymentDataList,
            widget.t2pPaymentList,
            widget.couponCount)
        .then((onResult) {
      print("print data $onResult");
      if (stockProvider.chkdtlsList.length != 0) {
        printProvider.responseFromNativeCode(onResult, "false").then((value) {
          stockProvider.chkdtlsList = [];
          saveCheckProvider.chkHeader = null;
        });
      }
    });

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
