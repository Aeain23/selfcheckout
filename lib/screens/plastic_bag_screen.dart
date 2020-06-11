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
        backgroundColor: Colors.white,
        child: Icon(
          Icons.reply,
          color: Colors.black,
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
