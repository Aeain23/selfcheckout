import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';
import '../models/counter.dart';
import '../providers/location_provider.dart';
import '../screens/login_screen.dart';
import '../providers/connectionprovider.dart';

class CounterScreen extends StatefulWidget {
  final String station;
  CounterScreen({this.station});
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  String getCounter;
  String getStation;
  String counterName;
  void _saveCounter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(
      () {
        sharedPreferences.setString("getCounter", getCounter);
        sharedPreferences.setString("station", getStation);
        sharedPreferences.setString("counterName", counterName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue[900],
            // actions: <Widget>[
            //   IconButton(
            //       icon: Icon(
            //         Icons.settings,
            //         color: Colors.white,
            //       ),
            //       onPressed: null)
            // ],
          ),
          body: Center(
              child: Container(
            width: 300,
            height: 300,
            child: FutureBuilder<CounterData>(
                future: connectionProvider.checkconnection().then((onValue) {
                  var t;
                  if (onValue) {
                    t = provider.fetchCounter(widget.station);
                  } else {
                    t = Fluttertoast.showToast(
                      timeInSecForIosWeb: 4,
                      msg: getTranslated(context, "no_internet_connection"),
                    );
                  }
                  return t;
                }),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            getTranslated(context, "choose_station"),
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.lightBlue[900],
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.counter.length,
                              itemBuilder: (context, index) {
                                var counter = snapshot.data.counter[index];
                                return InkWell(
                                  onTap: () {
                                    connectionProvider
                                        .checkconnection()
                                        .then((onValue) {
                                      if (onValue) {
                                        Provider.of<LocationProvider>(context,
                                                listen: false)
                                            .fetchCheckCounter(counter)
                                            .then((onValue1) {
                                          getCounter = onValue1.t1;
                                          getStation=onValue1.t3;
                                          counterName=onValue1.t2;
                                          if (getCounter != null) {
                                            _saveCounter();
                                          }
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) => LoginScreen(
                                              widget.station,
                                              snapshot
                                                  .data.counter[index].syskey,
                                            ),
                                          ));
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: getTranslated(context,
                                                "no_internet_connection"),
                                            timeInSecForIosWeb: 4);
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.video_label,
                                              color: Colors.lightBlue[900],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(snapshot
                                                  .data.counter[index].t2),
                                              height: 70,
                                            ),
                                            //
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ))),
    );
  }
}
