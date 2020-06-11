import 'package:flutter/material.dart';
import 'package:self_check_out/models/check_header_item.dart';
import '../models/member_scan.dart';
import '../models/payment_data.dart';
import '../models/promotion_use.dart';
import '../models/t2printData.dart';
import '../widgets/payment_success_widget.dart';
import '../widgets/app_bar_widget.dart';

class PaymentSuccessScreen extends StatefulWidget {
     final MemberScan memberScan;
     final int cash;
     final int point;
     final PromotionUse promotionUse;
      final List<PaymentData> paymentDataList;
  final List<T2pPaymentList> t2pPaymentList;
  final int couponCount;
  final CheckHeader checkHeader;
     PaymentSuccessScreen(this.memberScan,this.cash,this.point,this.promotionUse,this.paymentDataList,this.t2pPaymentList,this.couponCount,this.checkHeader);
  @override
  _PaymentSuccessScreenState createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarWidget(),
        body: PaymentSuccessWidget(widget.memberScan,widget.cash,widget.point,widget.promotionUse,widget.paymentDataList,widget.t2pPaymentList,widget.couponCount,widget.checkHeader),
      ),
    );
  }
}
