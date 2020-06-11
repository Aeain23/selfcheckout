import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/url_screen.dart';

class GroupModel {
  String text;
  int index;
  GroupModel({this.text, this.index});
}

class CloudScreen extends StatefulWidget {
  @override
  _CloudScreenState createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  int _currVal = 1;
  String getUrl;
  int getRadio;
  String getReward;
  // String demoUrl = 'http://localhost:8080/';
  List<GroupModel> _group = [
    GroupModel(
      text: "Domain",
      index: 1,
    ),
    GroupModel(
      text: "URL",
      index: 2,
    ),
    GroupModel(
      text: "Local",
      index: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _readUrl();
  }

  // void _saveUrl() async {
  //   _currVal = 1;
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(
  //     () {
  //       sharedPreferences.setInt("radio", 1);
  //       sharedPreferences.setString("url", demoUrl);
  //     },
  //   );
  // }

  // void _clearUrl() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     preferences.clear();
  //   });
  // }

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      getRadio = sharedPreferences.getInt("radio");
      getUrl = sharedPreferences.getString("url");
      // getReward = sharedPreferences.getString("reward");
      _currVal = getRadio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        height: 350.0,
        child: Column(
          children: _group
              .map(
                (t) => RadioListTile(
                  title: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currVal = t.index;
                          // if (t.index == 1) {
                          //   _saveUrl();
                          //   _readUrl();
                          // }
                          if (t.index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UrlScreen(),
                              ),
                            );
                          }
                        });
                      },
                      child: Text("${t.text}")),
                  groupValue: _currVal,
                  value: t.index,
                  onChanged: (val) {
                    setState(() {
                      _currVal = val;
                      // if (t.index == 1) {
                      //   if (getUrl == null) {
                      //     _clearUrl();
                      //   }
                      // }
                      if (t.index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UrlScreen(),
                          ),
                        );
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
