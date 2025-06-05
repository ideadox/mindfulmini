import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class OfflineStatusProvider with ChangeNotifier {
  OfflineStatusProvider() {
    _runListner();
  }

  late StreamSubscription<InternetStatus> listener;
  bool connected = true;
  _runListner() {
    listener = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      switch (status) {
        case InternetStatus.connected:
          log('interttt conttect');
          connected = true;
          notifyListeners();
          // The internet is now connected
          break;
        case InternetStatus.disconnected:
          log('no interttt conttect');
          connected = false;
          notifyListeners();
          // The internet is now disconnected
          break;

        // case   InternetStatus.values
      }
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }
}
