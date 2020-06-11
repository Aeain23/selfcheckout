import 'package:flutter/material.dart';
import '../widgets/member_sku_discount_widget.dart';
import '../widgets/app_bar_widget.dart';

class MemberWidget extends StatefulWidget {
  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: MemberSKUDiscount(),
    );
  }
}
