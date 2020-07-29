import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';

class LocalSettingsScreen extends StatefulWidget {
  @override
  _LocalSettingsScreenState createState() => _LocalSettingsScreenState();
}

class _LocalSettingsScreenState extends State<LocalSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController codeController = new TextEditingController(text: '');
  TextEditingController brandController = new TextEditingController(text: '');
  TextEditingController printerController = new TextEditingController(text: '');
  String locationCode, brandName;
  String getCode, getBrandName, macAddress;
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
    // setState(() {
    sharedPreferences.setString("locationCode", locationCode);
    sharedPreferences.setString('brandName', brandName);
    sharedPreferences.setString('macAddress', macAddress);
    // });
  }

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // setState(() {
    getCode = sharedPreferences.getString("locationCode");
    getBrandName = sharedPreferences.getString('brandName');
    macAddress = sharedPreferences.getString('macAddress');
    codeController.text = getCode;
    brandController.text = getBrandName;
    printerController.text = macAddress;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(getTranslated(context, "local_settings")),
        backgroundColorStart: Color(0xFF41004D),
        backgroundColorEnd: Color(0xFFA5418C),
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
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: getTranslated(context, "location_code"),
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
                  validator: (values) {
                    if (values.isEmpty) {
                      return getTranslated(context, "empty_location_code");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    locationCode = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: getTranslated(context, "brand_name"),
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
                      return getTranslated(context, "empty_brand_name");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    brandName = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 18.0),
                child: TextFormField(
                  controller: printerController,
                  decoration: InputDecoration(
                    labelText: getTranslated(context, "printer_mac"),
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
                      // return getTranslated(context, "empty_printer_mac");
                      return null;
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    macAddress = value;
                  },
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 18.0),
                child: RaisedButton(
                  elevation: 10,
                  hoverElevation: 10,
                  padding: EdgeInsets.all(18),
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                 splashColor:Color(0xFFD6914F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    getTranslated(context, "ok"),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button.color),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _saveUrl();
                      Navigator.pop(context);
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
