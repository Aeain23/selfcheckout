import 'package:flutter/material.dart';
import 'package:self_check_out/screens/location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UrlScreen extends StatefulWidget {
  @override
  _UrlScreenState createState() => _UrlScreenState();
}

class _UrlScreenState extends State<UrlScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController =
      TextEditingController(text: 'http://localhost:8080/CityServer/');
  TextEditingController otherUrlController = TextEditingController(text: '');
  TextEditingController keyController = TextEditingController(text: '');
  TextEditingController rewardController =
      TextEditingController(text: 'https://pre-citymartposcrm.ibaht.com');
  String url, reward, getReward;
  String otherUrl;
  String key;
  String getUrl = "";
  String getOtherUrl = "";
  String getKey = "";
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    _readUrl();
  }

  @override
  void didChangeDependencies() {
    _readUrl();
    super.didChangeDependencies();
  }

  void _saveUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setInt("radio", 2);
      sharedPreferences.setString("url", url);
      sharedPreferences.setString('otherUrl', otherUrl);
      sharedPreferences.setString("reward", reward);
      sharedPreferences.setString('key', key);
    });
  }

  void _clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.remove("locationSyskey");
      sharedPreferences.remove("counterSyskey");
    });
  }

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      getUrl = sharedPreferences.getString("url");
      getReward = sharedPreferences.getString("reward");
      urlController.text = getUrl;
      rewardController.text = getReward;
      otherUrlController.text = getOtherUrl;
      keyController.text = getKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: urlController,
                  decoration: InputDecoration(
                    labelText: 'URL',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (values) {
                    if (values.isEmpty) {
                      return 'Empty URL';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      url = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: otherUrlController,
                  decoration: InputDecoration(
                    labelText: 'Other Service URL',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    setState(() {
                      otherUrl = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: rewardController,
                  decoration: InputDecoration(
                    labelText: 'Reward Url',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (values) {
                    if (values.isEmpty) {
                      return 'Empty Reward';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      reward = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: keyController,
                  decoration: InputDecoration(
                    labelText: 'Key',
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(6),
                      ),
                      borderSide: new BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    setState(() {
                      key = value;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 18.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(18),
                  color: Colors.blue[900],
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('OK'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print("url $url");
                      print("getUrl $getUrl");
                      if (getUrl != url) {
                        print("reach validation");
                        _saveUrl();
                        _clearData();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationScreen()),
                            (r) => false);
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => LocationScreen()));
                      } else {
                        _saveUrl();
                        Navigator.pop(context);
                      }
                    } else {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
