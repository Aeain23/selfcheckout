import 'package:flutter/material.dart';
import '../localization/language_constants.dart';

class PaymentUnSuccessWidget extends StatefulWidget {
  @override
  _PaymentUnSuccessWidgetState createState() => _PaymentUnSuccessWidgetState();
}

class _PaymentUnSuccessWidgetState extends State<PaymentUnSuccessWidget> {
  @override
  Widget build(BuildContext context) {
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
              getTranslated(context, "unsuccessful"),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                "assets/images/false.jpg",
                color: Colors.red,
              ),
            ),
            Text(getTranslated(context, "please_try_again_or"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(getTranslated(context, "choose_a_different"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(getTranslated(context, "payment_method"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Container(
            //   width: MediaQuery.of(context).size.width / 2,
            //   child: RaisedButton(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: new BorderRadius.circular(22.0),
            //       ),
            //       child: Text(
            //         "Back",
            //         style: TextStyle(color: Colors.black, fontSize: 20),
            //       ),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
