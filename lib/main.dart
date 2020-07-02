import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './providers/print_provider.dart';
import './screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './providers/payment_currency_provider.dart';
import './providers/payment_type_provider.dart';
import './providers/get_checkdetails_provider.dart';
import './providers/card_usage_provider.dart';
import './providers/location_provider.dart';
import './providers/login_provider.dart';
import './providers/update_checkdetail_provider.dart';
import './screens/location_screen.dart';
import './providers/connectionprovider.dart';
import './providers/member_scan_provider.dart';
import './providers/stock_provider.dart';
import './screens/splash_screen.dart';
import './providers/save_checkheader_provider.dart';
import './localization/demo_localization.dart';
import './localization/language_constants.dart';
import 'providers/prepare_printdata_provider.dart';

void main() => runApp(Phoenix(child: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  String username;
  String password;
  String locationSyskey;
  String counterSyskey;
  readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      password = preferences.getString("password");
      locationSyskey = preferences.getString("locationSyskey");
      counterSyskey = preferences.getString("counterSyskey");
      print("username $username");
      print("password $password");
      print("location $locationSyskey");
      print("counter $counterSyskey");
    });
  }

  @override
  void initState() {
    super.initState();
    readLogin();
  }

  Widget getScreen() {
    if (locationSyskey == null || counterSyskey == null) {
      return LocationScreen();
    } else if (username == null && password == null) {
      return LoginScreen();
    } else {
      return SplashsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: StockProvider(),
        ),
        ChangeNotifierProvider.value(
          value: MemberScanProvider(),
        ),
        ChangeNotifierProvider.value(
          value: SaveCheckHeaderProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ConnectionProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CardUsageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: SavePaymentProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LocationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LoginProvider(),
        ),
        ChangeNotifierProvider.value(
          value: UpdateCheckDetailProvider(),
        ),
        ChangeNotifierProvider.value(
          value: GetCheckDetailsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PaymentTypeProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PreparePrintDataProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PaymentCurrencyProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CardTypeListProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PrintProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Self Checkout',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: _locale,
        supportedLocales: [Locale("en", "US"), Locale("hi", "IN")],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: getScreen(),
      ),
    );
  }
}
