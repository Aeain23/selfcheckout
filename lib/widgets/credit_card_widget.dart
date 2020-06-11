import 'package:flutter/material.dart';
import 'package:number_display/number_display.dart';
import 'package:provider/provider.dart';
import '../localization/language_constants.dart';
import '../widgets/round_slider_track_shape.dart';
import '../providers/stock_provider.dart';

class CreditCardWidget extends StatefulWidget {
  final String cash;
  final String point;
  final double total;
  final String name;
  CreditCardWidget({this.cash, this.point, this.total, this.name});

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  var numSeparate;
  double _remainValue = 0;
  double _value;
  int remainder;
  int max;
  @override
  void initState() {
    super.initState();
    max = ((widget.total).round() ~/ 100);
    _value = (widget.total ~/ 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context, listen: true);
    // final providerheader =
    //     Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    remainder = provider.totalAmount.round() % 100;
    print("maximum ---------$remainder");
    numSeparate = createDisplay(length: 16, separator: ',');

    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    (widget.cash != null || widget.point != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Image.asset("assets/images/city_reward.jpg"),
                              Text(
                                getTranslated(context, "welcome_back"),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : SizedBox(),
                    (widget.cash != null || widget.point != null)
                        ? Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(getTranslated(context,
                                    "you_have_in_your_city_rewards_balance")),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20.0,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text(getTranslated(context, "city_cash")),
                                    Text(
                                        ": Ks ${numSeparate(double.parse(widget.cash).round())}"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(getTranslated(context, "points")),
                                    Text(
                                        ": ${numSeparate(double.parse(widget.cash).round())}"),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        getTranslated(context, "total"),
                        style: TextStyle(fontSize: 28, color: Colors.orange),
                      ),
                    ),
                    Text(
                      "Ks ${numSeparate(provider.totalAmount.round())}",
                      style: TextStyle(fontSize: 28, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      getTranslated(context, "payment_by_credit_card"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Card(
                        color: Colors.white70,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    getTranslated(context, "credit_card"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          activeTrackColor: Colors.orange,
                                          inactiveTrackColor: Colors.orange,
                                          trackShape:
                                              RoundSliderTrackShape(radius: 10),
                                          trackHeight: 13.0,
                                          thumbColor: Colors.grey,
                                          overlayColor: Colors.grey,
                                        ),
                                        child: Slider(
                                          value: _value,
                                          min: 0,
                                          max: max.toDouble(),
                                          onChanged: (double newValue) {
                                            setState(() {
                                              _value = newValue;
                                            });
                                            _remainValue = ((provider
                                                        .totalAmount
                                                        .round() ~/
                                                    100) -
                                                _value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    getTranslated(context, "points"),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "  Ks ${_value.round() * 100 + remainder}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "",
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${_remainValue.round() * 100}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      getTranslated(context, "to_be_paid"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      getTranslated(context, "to_be_used"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // RaisedButton(child: Text("Test"),onPressed:(){
                    //   int val=_value.round();
                    //   int remainder=val%100;
                    //   print("Remainder$remainder");
                    // } ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
