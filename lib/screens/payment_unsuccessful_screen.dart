import 'package:flutter/material.dart';
import '../localization/language_constants.dart';
import '../widgets/payment_unsuccess_widget.dart';
import '../widgets/app_bar_widget.dart';

class PaymentUnsuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: PaymentUnSuccessWidget(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 30.0),
            height: MediaQuery.of(context).size.height / 16,
            width: MediaQuery.of(context).size.width / 2,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(22.0),
                //  side: BorderSide(color: Colors.orange)
              ),
              //  color: Colors.orange,
              child: Text(
                getTranslated(context, "back"),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //       builder: (context) => InsertCardScreen()),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
