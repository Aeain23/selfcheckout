import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';

class ConnectionProvider with ChangeNotifier {
  Future<bool> checkconnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return null;
  }
}
