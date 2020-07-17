import 'package:flutter/material.dart';
import '../models/member_scan.dart';
import '../models/promotion_use.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/payment_widget.dart';

class PaymentTypeScreen extends StatelessWidget {
  final String cash;
  final String point;
  final String name;
  final MemberScan memberScan;
  final PromotionUse promotionUse;
  final int cuponCount;
 
  PaymentTypeScreen(
      {this.cash,
      this.point,
      this.name,
      this.memberScan,
      this.promotionUse,
      this.cuponCount,
    
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: PaymentWidget(
        cash: cash,
        point: point,
        name: name,
        memberScan: memberScan,
        promotionUse: promotionUse,
        cuponCount: cuponCount,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor:Color(0xFF6F51A1),
        child: Icon(
          Icons.reply,
          color: Colors.white,
        ),
        onPressed: () {
         Navigator.of(context).pop();
        },
      ),
    );
  }
}
