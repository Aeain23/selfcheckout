import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
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

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getRadio = sharedPreferences.getInt("radio");
    getUrl = sharedPreferences.getString("url");
    // getReward = sharedPreferences.getString("reward");
    _currVal = getRadio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart:Color(0xFF41004D),
        backgroundColorEnd: Color(0xFFA5418C),
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
                  activeColor: Theme.of(context).buttonColor,
                  onChanged: (val) {
                    setState(() {
                      _currVal = val;
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
