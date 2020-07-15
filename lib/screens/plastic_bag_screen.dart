import 'package:flutter/material.dart';
import '../screens/stock_list_screen.dart';
import '../widgets/plastic_bag_widget.dart';
import '../widgets/app_bar_widget.dart';

class PlasticBagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: PlasticBagWidget(),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Color(0xFF6F51A1),
        child: Icon(
          Icons.reply,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StockListScreen(),
            ),
          );
        },
      ),
    );
  }
}
